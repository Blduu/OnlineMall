#!/bin/bash

# 设置日志输出
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "开始初始化 Alibaba Cloud Linux 服务器环境..."

# 更新系统
log "更新系统包..."
yum update -y

# 安装必要工具
log "安装必要工具..."
yum install -y yum-utils device-mapper-persistent-data lvm2 wget

# 添加Docker CE仓库
log "添加Docker CE仓库..."
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# 安装Docker CE
log "安装Docker CE..."
yum install -y docker-ce docker-ce-cli containerd.io

# 创建Docker配置目录
mkdir -p /etc/docker

# 配置Docker镜像加速
log "配置Docker镜像加速..."
cat > /etc/docker/daemon.json <<EOF
{
    "registry-mirrors": [
      "https://registry.cn-hangzhou.aliyuncs.com",  // 阿里云（推荐）
      "https://docker.mirrors.ustc.edu.cn",       // 中科大镜像源
      "https://hub-mirror.c.163.com"              // 网易镜像源
    ],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m",
    "max-file": "3"
  }
}
EOF

# 启动Docker服务
log "启动Docker服务..."
systemctl enable docker
systemctl start docker

# 安装Docker Compose
log "安装Docker Compose..."
rm -f /usr/local/bin/docker-compose /usr/bin/docker-compose
curl -L "https://github.com/docker/compose/releases/download/v2.20.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# 创建项目目录
log "创建项目目录..."
mkdir -p /root/OnlineMall-backend/sql

# 配置防火墙
log "配置防火墙..."
systemctl start firewalld
systemctl enable firewalld

# 开放必要端口
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --zone=public --add-port=6379/tcp --permanent
firewall-cmd --zone=public --add-port=22/tcp --permanent
firewall-cmd --reload

# 确保SSH密码登录已启用
log "配置SSH密码登录..."
sed -i 's/^#\?PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

log "服务器环境初始化完成！"
log "下一步: 使用 deploy.ps1 或 deploy.bat 脚本部署应用" 