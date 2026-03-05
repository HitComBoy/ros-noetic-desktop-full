# 使用 osrf/ros:noetic-desktop-full
FROM osrf/ros:noetic-desktop-full

USER root

# 1. 替換 apt 源並安裝依賴
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    # 【關鍵：加入 x11-xserver-utils 以獲得 xauth】
    x11-xserver-utils \
    # 增加 mesa 工具，方便排查 3D 渲染問題
    mesa-utils \
    libgoogle-glog-dev \
    zsh \
    vim \
    git \
    xterm \ 
    tmux \
    liblapack-dev libsuitesparse-dev libcxsparse3 libgflags-dev libgtest-dev && \
    # 安裝 jsk_rviz_plugins 及其依賴
    apt-get install -y ros-noetic-jsk-rviz-plugins && \
    # 清理快取
    rm -rf /var/lib/apt/lists/*

# 2. 創建 byd 用戶
# 加入 --uid 1000 以確保與宿主機普通用戶權限匹配，減少掛載時的權限困擾
RUN useradd -m -s /bin/zsh -u 1000 byd && \
    echo "byd:." | chpasswd && \
    # 確保 byd 用戶有 sudo 權限（雖然無 sudo 密碼）
    apt-get update && apt-get install -y sudo && \
    echo "byd ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    rm -rf /var/lib/apt/lists/*

# 3. 設置工作目錄
WORKDIR /home/byd

# 4. 切換到 byd 用戶
USER byd

# 5. 初始化 ROS 環境與 X11 授權路徑
RUN echo "source /opt/ros/noetic/setup.bash" >> /home/byd/.zshrc && \
    echo "source /opt/ros/noetic/setup.bash" >> /home/byd/.bashrc

# 保持容器運行（可選）
CMD ["/bin/zsh"]
