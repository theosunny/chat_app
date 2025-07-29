#!/bin/bash

set -e

# 定义路径
BACKEND_DIR="chat_app/backend"
FRONTEND_DIR="chat_app/frontend"

echo "🚀 开始初始化项目环境..."

# 初始化 Go 后端
echo "📦 初始化 Go 模块..."
cd $BACKEND_DIR
if [ ! -f "go.mod" ]; then
  go mod init chatapp
fi
go mod tidy

# 启动 Go 后端（默认端口 8080）
echo "▶️ 启动 Go 后端服务..."
gnome-terminal -- bash -c "go run main.go; exec bash" || \
osascript -e 'tell app "Terminal" to do script "cd '"$PWD"' && go run main.go"' || \
x-terminal-emulator -e "go run main.go" || \
echo "🟡 请手动运行: cd $BACKEND_DIR && go run main.go"

# 返回项目根目录
cd ../../

# 初始化 Flutter 项目依赖
echo "📱 安装 Flutter 依赖..."
cd $FRONTEND_DIR
flutter pub get

# 启动 Flutter（可选：你可手动运行 flutter run）
echo "▶️ 启动 Flutter 调试（你可跳过此步骤手动运行）"
flutter run || echo "⚠️ Flutter 未自动运行成功，请检查设备或手动执行 flutter run"

echo "✅ 项目启动完成"
setup_and_run
