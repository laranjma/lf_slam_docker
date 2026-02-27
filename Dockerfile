FROM osrf/ros:jazzy-desktop-full

ARG C_USER
ARG C_UID
ARG C_GID

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# ------------------------------------------------------------
# System-level packages (root)
# ------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    vim \
    git curl wget ca-certificates \
    build-essential cmake ninja-build \
    ros-jazzy-navigation2 ros-jazzy-nav2-bringup \
    libboost-all-dev libeigen3-dev libtbb-dev \
    libsuitesparse-dev libmetis-dev \
    libceres-dev \
    libopencv-dev \
    python3-pip \
    python3-dev \
    python3-numpy \
    python3-matplotlib \
    python3-setuptools \
    python3-venv \
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-gtsam\
    libgtsam-dev \
    zsh \
    locales \
    mesa-utils libgl1 libglx0 libegl1 \
&& rm -rf /var/lib/apt/lists/*

# Locale (avoids warnings in shells and ROS tools)
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# ------------------------------------------------------------
# Create/ensure user matching host UID/GID (handles existing UID=1000 in base image)
# ------------------------------------------------------------
RUN set -eux; \
    # 1) Ensure group with desired GID exists (create if missing)
    if ! getent group "${C_GID}" >/dev/null; then \
        groupadd --gid "${C_GID}" "${C_USER}"; \
    fi; \
    \
    # 2) If username already exists, just adjust uid/gid and home
    if id -u "${C_USER}" >/dev/null 2>&1; then \
        usermod  --uid "${C_UID}" --gid "${C_GID}" --home "/home/${C_USER}" --move-home "${C_USER}" || true; \
    else \
        # 3) If UID already taken by some other user (e.g., 'ros'), rename that user to C_USER
        if getent passwd "${C_UID}" >/dev/null; then \
            EXISTING_USER="$(getent passwd "${C_UID}" | cut -d: -f1)"; \
            echo "UID ${C_UID} already used by ${EXISTING_USER}; renaming ${EXISTING_USER} -> ${C_USER}"; \
            usermod -l "${C_USER}" "${EXISTING_USER}"; \
            usermod -d "/home/${C_USER}" -m "${C_USER}"; \
            usermod -g "${C_GID}" "${C_USER}"; \
        else \
            # 4) Otherwise create fresh user with that UID/GID
            useradd --uid "${C_UID}" --gid "${C_GID}" --create-home --shell /usr/bin/zsh "${C_USER}"; \
        fi; \
    fi; \
    \
    # 5) Sudo (passwordless)
    usermod -aG sudo "${C_USER}"; \
    echo "${C_USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/99-"${C_USER}"; \
    chmod 0440 /etc/sudoers.d/99-"${C_USER}"

# ------------------------------------------------------------
# rosdep (root)
# ------------------------------------------------------------
RUN rosdep init || true && rosdep update

# ------------------------------------------------------------
# Copy user-oriented install script
# ------------------------------------------------------------
COPY scripts/zsh-extras.zsh /home/${C_USER}/.zsh-extras.zsh
COPY scripts/custom-shell.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/custom-shell.sh
USER ${C_USER}
RUN /usr/local/bin/custom-shell.sh
WORKDIR /home/${C_USER}
CMD ["zsh"]
