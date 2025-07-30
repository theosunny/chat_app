# Docker Desktop 安装指南

## 系统要求
- Windows 10 64位：专业版、企业版或教育版（版本1903或更高版本）
- Windows 11 64位：家庭版或专业版（版本21H2或更高版本）
- 启用WSL 2功能
- 启用虚拟化功能

## 安装步骤

### 1. 下载Docker Desktop
访问官方下载页面：https://docs.docker.com/desktop/install/windows-install/ <mcreference link="https://docs.docker.com/desktop/setup/install/windows-install/" index="4">4</mcreference>

### 2. 启用WSL 2
以管理员身份运行PowerShell，执行以下命令：
```powershell
# 启用WSL功能
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# 启用虚拟机平台
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# 重启计算机
Restart-Computer
```

### 3. 安装WSL 2 Linux内核更新包
下载并安装：https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi

### 4. 设置WSL 2为默认版本
```powershell
wsl --set-default-version 2
```

### 5. 安装Docker Desktop
1. 运行下载的Docker Desktop安装程序
2. 在安装过程中确保选择"Use WSL 2 instead of Hyper-V"
3. 完成安装后重启计算机

### 6. 验证安装
```powershell
docker --version
docker run hello-world
```

## 注意事项
- Docker Desktop在大型企业（超过250名员工或年收入超过1000万美元）中的商业使用需要付费订阅 <mcreference link="https://docs.docker.com/desktop/setup/install/windows-install/" index="4">4</mcreference>
- 安装完成后建议配置资源限制以优化性能 <mcreference link="https://smartide.cn/zh/docs/install/docker/windows/" index="3">3</mcreference>

安装完成后，请重新运行后端服务。