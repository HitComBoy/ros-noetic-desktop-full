# 使用 osrf/ros:noetic-desktop-full 作为基础镜像 (已包含 rviz, gazebo 等)
FROM osrf/ros:noetic-desktop-full

# 1. 切换为 root 用户以便安装软件 (默认可能是 root，但显式声明更安全)
USER root

# 替换 apt 源并安装依赖
# 注意：必须在安装 jsk 插件前 update
RUN apt-get update && \
    # 安装系统工具库
    apt-get install -y --no-install-recommends \
    libgoogle-glog-dev \
    zsh \
    vim \
    git \
    tmux \
    liblapack-dev libsuitesparse-dev libcxsparse3 libgflags-dev libgoogle-glog-dev libgtest-dev && \
    # 【关键修改】安装 jsk_rviz_plugins 及其所有依赖 (含 jsk_recognition_msgs)
    apt-get install -y ros-noetic-jsk-rviz-plugins && \
    # 清理缓存以减小镜像体积
    rm -rf /var/lib/apt/lists/*

# 创建 byd 用户，并设置密码
# 注意：如果在上面安装了需要用户配置的包，顺序可能需要调整，但这里主要装库，顺序影响不大
RUN useradd -m -s /bin/bash byd && \
    echo "byd:." | chpasswd && \
    usermod -aG sudo byd

# 设置工作目录为 /home/byd
WORKDIR /home/byd

# 切换到 byd 用户
USER byd

# 【可选】初始化 ROS 环境到 by 用户的 bashrc，方便登录后直接使用
# 因为默认 entrypoint 可能会 source，但为了保险起见：
RUN echo "source /opt/ros/noetic/setup.bash" >> /home/byd/.bashrc
