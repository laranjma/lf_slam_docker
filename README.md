# LF-SLAM Container

Dockerized development environment for LF-SLAM (learned-feature SLAM) project.

## Overview

This container extends `jazzy-ws:dev` and adds common SLAM dependencies:

- `libceres-dev`
- `libopencv-dev`
- `python3-pip`, `python3-numpy`, `python3-matplotlib`
- `python3-gtsam`

Compose runs an interactive container (`lf-slam-dev`) with host networking, user mapping, and X11 forwarding.

## Files

- `Dockerfile`: image definition
- `docker-compose.yml`: dev service configuration
- `.env`: local environment values consumed by compose

## Prerequisites

- Docker Engine + Docker Compose plugin
- Base image `jazzy-ws:dev` available locally
- Linux host with X11 (`/tmp/.X11-unix`)
- LF-SLAM repo available at `${HOME}/dev/projects/robotics/lf_slam`

## .env

Create `.env` in this folder with:

```dotenv
USER=<your-username>
UID=<your-uid>
GID=<your-gid>
DISPLAY=<your-display>
GTSAM_BUILD_JOBS=2
```

## Usage

```bash
docker compose build
docker compose up -d
docker compose exec lf-slam-dev zsh
```

Stop and remove:

```bash
docker compose down
```

## Notes

- `network_mode: host` is enabled for robotics workflows.
- Container runs as your host user using `USER/UID/GID`.
- If GUI apps fail, verify `DISPLAY` and run `xhost +local:docker` on the host if needed.
