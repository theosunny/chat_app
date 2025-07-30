# MySQL 安装和配置指南

## 方法一：使用 MySQL Installer（推荐）

1. 下载 MySQL Installer
   - 访问 https://dev.mysql.com/downloads/installer/
   - 下载 MySQL Installer for Windows

2. 安装 MySQL
   - 运行下载的安装程序
   - 选择 "Developer Default" 或 "Server only"
   - 设置 root 密码为 `password`（与代码中的配置一致）
   - 完成安装

3. 启动 MySQL 服务
   - 安装完成后，MySQL 服务会自动启动
   - 可以在 Windows 服务管理器中查看 "MySQL80" 服务状态

## 方法二：使用 Chocolatey

```powershell
# 安装 Chocolatey（如果还没有安装）
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# 安装 MySQL
choco install mysql

# 启动 MySQL 服务
net start mysql80
```

## 方法三：使用 XAMPP

1. 下载 XAMPP
   - 访问 https://www.apachefriends.org/
   - 下载 XAMPP for Windows

2. 安装并启动
   - 安装 XAMPP
   - 打开 XAMPP Control Panel
   - 启动 MySQL 服务

## 创建数据库

安装完成后，需要创建数据库：

```sql
-- 连接到 MySQL（使用 MySQL Workbench 或命令行）
mysql -u root -p

-- 创建数据库
CREATE DATABASE chatapp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 创建用户（可选）
CREATE USER 'chatapp'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON chatapp.* TO 'chatapp'@'localhost';
FLUSH PRIVILEGES;
```

## 验证安装

```powershell
# 检查 MySQL 服务状态
Get-Service -Name "MySQL*"

# 或者使用 net 命令
net start | findstr MySQL
```

## 常见问题

1. **端口 3306 被占用**
   - 检查是否有其他 MySQL 实例在运行
   - 修改 MySQL 配置文件中的端口

2. **服务无法启动**
   - 检查 Windows 事件日志
   - 确保 MySQL 数据目录有正确的权限

3. **连接被拒绝**
   - 确保 MySQL 服务正在运行
   - 检查防火墙设置
   - 验证用户名和密码

## 配置说明

当前后端配置：
- 主机：localhost
- 端口：3306
- 用户名：root
- 密码：password
- 数据库：chatapp

如需修改配置，请编辑 `backend/config/config.go` 文件中的 `DatabaseDSN` 字段。