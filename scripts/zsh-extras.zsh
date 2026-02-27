# ------------------------------------------------------------
# Prompt customization
# ------------------------------------------------------------

WS_PREFIX='%B%F{white}WS%f%b ' # bold white "WS" prefix
PROMPT="${WS_PREFIX}${PROMPT}"

# ------------------------------------------------------------
# ROS2 customization
# ------------------------------------------------------------

# Source ROS 2 Jazzy
if [ -f /opt/ros/jazzy/setup.zsh ]; then
  source /opt/ros/jazzy/setup.zsh
fi
# Workspace overlay
if [ -f ${HOME}/lf_slam/ros2_ws/install/setup.zsh ]; then
  source ${HOME}/lf_slam/ros2_ws/install/setup.zsh
fi
# ROS autocompletion
source /opt/ros/jazzy/share/ros2cli/environment/ros2-argcomplete.zsh

# Aliases and functions
# ROS2 Build + source (fast, frequent use)
src_ros_install()
{
  source ${HOME}/lf_slam/ros2_ws/install/setup.zsh
  source /opt/ros/jazzy/share/ros2cli/environment/ros2-argcomplete.zsh
}
# Workspace build
cbws() {
  local WS="$HOME/lf_slam/ros2_ws"
  pushd "$WS" >/dev/null || return 1
  colcon build --symlink-install "$@" || { popd >/dev/null; return 1; }
  src_ros_install()
  popd >/dev/null
}
# ROS2 Clean build artifacts (handy when switching branches/ABI issues)
cwsclean() {
  local WS="$HOME/lf_slam/ros2_ws"
  rm -rf "$WS/build" "$WS/install" "$WS/log"
}
# Build only selected packages (fast iteration)
cbp() {
  local WS="$HOME/lf_slam/ros2_ws"
  pushd "$WS" >/dev/null || return 1
  colcon build --symlink-install --packages-select "$@" || { popd >/dev/null; return 1; }
  src_ros_install()
  popd >/dev/null
}
# Build selected packages + their deps (common dev workflow)
cbpu() {
  local WS="$HOME/lf_slam/ros2_ws"
  pushd "$WS" >/dev/null || return 1
  colcon build --symlink-install --packages-up-to "$@" || { popd >/dev/null; return 1; }
  src_ros_install()
  popd >/dev/null
}
