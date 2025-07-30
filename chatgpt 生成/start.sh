#!/bin/bash

echo "开始构建并启动 Docker 容器..."

docker-compose down

docker-compose up -d --build

echo "所有服务启动完毕。"
echo "前端访问: http://localhost:5000"
echo "后端 API: http://localhost:8080"
