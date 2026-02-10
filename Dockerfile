FROM jazzy-ws:dev

ARG DEBIAN_FRONTEND=noninteractive
ARG GTSAM_BUILD_JOBS=1

USER root

# --- Install libs
RUN apt-get update && apt-get install -y --no-install-recommends \
    git cmake ninja-build build-essential \
    libboost-all-dev libeigen3-dev libtbb-dev \
    libsuitesparse-dev libmetis-dev \
    libceres-dev \
    libopencv-dev \
    python3-dev pybind11-dev \
    python3-pip \
    python3-numpy \
    python3-matplotlib \
    python3-setuptools \
    libgtsam-dev python3-gtsam\
 && rm -rf /var/lib/apt/lists/*

# --- GTSAM sanity check at build time
RUN python3 -c "import gtsam, inspect; print('gtsam OK:', gtsam.__file__)"
    
USER ${C_USER}
