FROM jazzy-ws:dev

ARG DEBIAN_FRONTEND=noninteractive
ARG GTSAM_BUILD_JOBS=1

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    libceres-dev \
    libopencv-dev \
    python3-pip \
    python3-numpy \
    python3-matplotlib \
 && rm -rf /var/lib/apt/lists/*

# --- GTSAM build deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    libboost-all-dev \
    libtbb-dev \
    libeigen3-dev \
    libsuitesparse-dev \
    libmetis-dev \
    pybind11-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# --- Build & install GTSAM
RUN git clone --depth 1 https://github.com/borglab/gtsam.git /tmp/gtsam && \
    cmake -S /tmp/gtsam -B /tmp/gtsam/build -GNinja \
      -DCMAKE_BUILD_TYPE=Release \
      -DGTSAM_BUILD_TESTS=OFF \
      -DGTSAM_BUILD_EXAMPLES_ALWAYS=OFF \
      -DGTSAM_BUILD_UNSTABLE=OFF \
      -DGTSAM_BUILD_PYTHON=ON \
      -DGTSAM_PYTHON_VERSION=3 \
      -DCMAKE_INSTALL_PREFIX=/usr/local && \
    cmake --build /tmp/gtsam/build --parallel ${GTSAM_BUILD_JOBS} && \
    cmake --install /tmp/gtsam/build && \
    rm -rf /tmp/gtsam
    
USER ${C_USER}
