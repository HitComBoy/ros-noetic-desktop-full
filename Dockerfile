# 使用osrf/ros:noetic-desktop-full作为基础镜像
FROM osrf/ros:noetic-desktop-full

# 创建byd用户，并设置密码
RUN useradd -m -s /bin/bash byd && \
    echo "byd:." | chpasswd && \
    usermod -aG sudo byd

# 替换apt包并安装依赖
# 安装glog, zsh, vim, tmux等软件包
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libgoogle-glog-dev \
    zsh \
    vim \
    git \
    tmux \
    liblapack-dev libsuitesparse-dev libcxsparse3 libgflags-dev libgoogle-glog-dev libgtest-dev &&\
    rm -rf /var/lib/apt/lists/*


# 设置工作目录为/home/byd
WORKDIR /home/byd

# 切换到byd用户
USER byd
