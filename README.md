# LF-SLAM Docker Development Environment

Docker setup for a reproducible **LF-SLAM** development container based on `jazzy-ws:dev`, with extra SLAM and computer vision dependencies preinstalled.

## What this provides

- Base image: `jazzy-ws:dev`
- System dependencies for SLAM/vision:
  - `libceres-dev`
  - `libopencv-dev`
  - `python3-numpy`, `python3-matplotlib`, `python3-pip`
- GTSAM built from source (`borglab/gtsam`) with Python bindings enabled
- Interactive dev container with host networking and X11 forwarding

## Files

- `Dockerfile`: extends `jazzy-ws:dev` and installs/builds dependencies
- `docker-compose.yml`: defines the `lf-slam-dev` service
- `.env`: local user and display settings (`USER`, `UID`, `GID`, `DISPLAY`)

## Prerequisites

- Docker + Docker Compose plugin installed
- A local base image named `jazzy-ws:dev` available
- Linux host with X11 available (uses `/tmp/.X11-unix`)
- Project checked out at:
  - `${HOME}/dev/projects/robotics/lf_slam`

## Build and run

From this folder:

```bash
docker compose build
docker compose up -d
docker compose exec lf-slam-dev zsh
```

Stop container:

```bash
docker compose down
```

## Volume mounts

The compose service mounts:

- Project source:
  - `${HOME}/dev/projects/robotics/lf_slam -> /home/${USER}/lf_slam`
- Shared data:
  - `${HOME}/dev/shared/data -> /home/${USER}/data`
- SSH keys (read-only):
  - `${HOME}/.ssh -> /home/${USER}/.ssh`
- X11 socket:
  - `/tmp/.X11-unix -> /tmp/.X11-unix`

## Notes

- `network_mode: host` is enabled for easier robotics workflows.
- Container runs as your local user (`USER/UID/GID` from `.env`).
- If GUI apps fail to open, verify `DISPLAY` in `.env` matches your host session.
