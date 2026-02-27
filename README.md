# LF-SLAM Container

Dockerized development environment for LF-SLAM (learned-feature SLAM) project.

## Overview

This container extends `osrf/ros:jazzy-desktop-full` and adds common SLAM dependencies.

Compose runs an interactive container (`lf-slam-dev`) with host networking, user mapping, and X11 forwarding.

## Files

- `Dockerfile`: image definition
- `docker-compose.yml`: dev service configuration
- `.env`: local environment values consumed by compose
- `scripts/*`: scripts for shell customization

## Prerequisites

- Docker Engine + Docker Compose plugin
- Base image `osrf/ros:jazzy-desktop-full` available locally
- Linux host with X11 (`/tmp/.X11-unix`)
- LF-SLAM repo available at `${HOME}/dev/projects/robotics/lf_slam`

## .env

Create `.env` in this folder with:

```dotenv
USER=<your-username>
UID=<your-uid>
GID=<your-gid>
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
