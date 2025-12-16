# TermiOS - MacOS-style WebOS for Linux Server Management

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Version](https://img.shields.io/badge/version-1.0.0-green.svg)

[中文](#chinese) | [English](#english)

---

<a name="chinese"></a>
# TermiOS (中文版)

## 📖 项目介绍 | Introduction

TermiOS 是一个基于 Web 的操作系统界面，专为管理 Linux 服务器而设计。它将 macOS 的优雅体验带入了服务器管理领域，让用户能够通过熟悉的桌面环境与基础设施进行交互。TermiOS 通过集成的终端、文件管理器和系统监控工具，将复杂的命令行操作简化为直观的图形化交互，极大地提升了运维效率和体验。

## ✨ 功能特性 | Features

- **MacOS 风格 UI**: 完美的桌面体验，包含 Dock 栏、窗口管理、毛玻璃特效（Glassmorphism）和动态动画。
- **全功能终端**: 内置基于 xterm.js 的 SSH 终端，支持全彩显示和常用快捷键。
- **文件管理器 (Finder)**: 支持 SFTP 的文件管理，可轻松浏览、上传、下载和编辑服务器文件。
- **系统监控**: 类似 Activity Monitor 的实时监控，展示 CPU、内存、磁盘和网络状态。
- **多语言支持**: 内置国际化 (i18n) 支持，自动检测浏览器语言。
- **全局认证**: 统一的登录入口，一次登录即可访问所有应用。

## 📂 项目仓库 | Repositories

TermiOS 采用前后端分离架构，代码分布在以下仓库：

| 仓库 | 说明 |
|------|------|
| [TermiOS](https://github.com/TermiOSSH/TermiOS) | 📚 主仓库 - 文档和部署配置 (本仓库) |
| [termios-frontend](https://github.com/TermiOSSH/termios-frontend) | 🎨 前端 - Next.js + React |
| [termios-backend](https://github.com/TermiOSSH/termios-backend) | ⚙️ 后端 - Node.js + Express |

## 🛠 技术栈 | Tech Stack

### 前端 (Frontend)
- **Framework**: Next.js 16 (React 19)
- **Styling**: Tailwind CSS v4
- **State Management**: Zustand
- **Internationalization**: i18next
- **Components**: Framer Motion, Lucide React

### 后端 (Backend)
- **Runtime**: Node.js
- **Server**: Express
- **Communication**: Socket.IO (Real-time), SSH2 (Protocol)
- **System Info**: systeminformation

## 🚀 快速开始 | Quick Start

### 方式一：Docker 部署 (推荐)

TermiOS 提供两种 Docker 镜像，支持一体化部署或前后端分离部署。

#### 一体化部署 (Docker Compose)

最简单的运行方式，一键启动前后端：

```bash
docker compose up -d --build
```

#### 前后端分离部署

如果您需要将前端和后端部署到不同的服务器，可以单独运行：

**后端部署:**
```bash
docker run -d \
  --name termios-backend \
  -p 3001:3001 \
  -e CORS_ORIGIN="*" \
  -e SERVER_PASSWORD="your_secure_password" \
  --restart always \
  ccdecc/termios-backend:latest
```

> **配置说明**：
> - **`CORS_ORIGIN`**：
>   - `*` 或 `true`：放开所有跨域限制（适合开发或内网环境）
>   - 指定域名：如 `http://a.com,http://b.com`（逗号分隔多个，适合生产环境）
>   - 留空：同源模式，仅允许同域访问（最安全，适合反向代理场景）
> - **`SERVER_PASSWORD`** (可选)：
>   - 用于保护后端 WebSocket 连接的安全密码。配置后，前端连接时需输入此密码才能进行 SSH 认证。如果不设置，则默认无需密码即可连接 WebSocket。

**前端部署:**
```bash
# BACKEND_URL 指向后端地址（需包含协议和端口）
docker run -d \
  --name termios-frontend \
  -p 80:80 \
  -e BACKEND_URL="http://your-backend-server:3001" \
  --restart always \
  ccdecc/termios-frontend:latest
```

> ⚠️ **注意**: 前后端分离部署时，需要确保前端能够访问后端的 WebSocket 端口。如果使用 Nginx 反向代理，请参考项目中的 `nginx.conf.example` 配置 WebSocket 头。

#### 可用镜像

| 镜像名称 | 说明 | 平台 |
|---------|------|------|
| `ccdecc/termios:latest` | 一体化镜像（前后端合并） | amd64, arm64 |
| `ccdecc/termios-backend:latest` | 后端 API 服务 | amd64, arm64 |
| `ccdecc/termios-frontend:latest` | 前端静态资源 + Nginx | amd64, arm64 |

2.  **访问应用**
    浏览器访问 [http://localhost:3000](http://localhost:3000)

### 方式二：本地开发

如果您想进行二次开发或本地调试，请按以下步骤操作：

#### 1. 克隆仓库

```bash
# 克隆前端仓库
git clone https://github.com/TermiOSSH/termios-frontend.git frontend

# 克隆后端仓库
git clone https://github.com/TermiOSSH/termios-backend.git backend
```

#### 2. 安装依赖

```bash
# 安装后端依赖
cd backend
npm install

# 安装前端依赖
cd ../frontend
npm install
```

#### 3. 启动服务

您需要同时启动后端和前端服务。

**终端 1 (后端 - Port 3001):**
```bash
cd backend
npm start
```

**终端 2 (前端 - Port 3000):**
```bash
cd frontend
npm run dev
```

#### 4. 访问应用
浏览器访问 [http://localhost:3000](http://localhost:3000)

## 📖 使用指南

1.  **登录**: 在登录窗口输入您的 Linux 服务器信息（Host, Username, Password）。
2.  **终端**: 点击 Dock 栏的 Terminal 图标打开 SSH 终端。
3.  **文件管理**: 点击 Finder 图标浏览和管理文件。
4.  **监控**: 查看顶部状态栏或打开 Activity Monitor 查看系统负载。

---

<a name="english"></a>
# TermiOS (English)

## 📖 System Introduction

TermiOS is a web-based operating system interface designed for managing Linux servers. It brings the elegant, user-friendly experience of macOS to server management, allowing users to interact with their infrastructure through a familiar desktop environment. With an integrated terminal, file manager, and system monitoring tools, TermiOS simplifies complex CLI tasks into intuitive GUI interactions.

## ✨ Features

- **MacOS-inspired UI**: A complete desktop experience with Dock, window management, Glassmorphism effects, and fluid animations.
- **Full-Featured Terminal**: Integrated SSH terminal based on xterm.js with full color support.
- **Finder (File Manager)**: SFTP-enabled file manager to browse, upload, download, and edit files easily.
- **System Monitoring**: Real-time resource monitoring (CPU, RAM, Disk, Network) similar to Activity Monitor.
- **Global Auth**: Unified Single Sign-On (SSO) for seamless access to all applications.
- **i18n Support**: Native internationalization support with automatic language detection.

## 📂 Repositories

TermiOS uses a frontend/backend separation architecture. Code is distributed across the following repositories:

| Repository | Description |
|------------|-------------|
| [TermiOS](https://github.com/TermiOSSH/TermiOS) | 📚 Main repo - Documentation & deployment configs (this repo) |
| [termios-frontend](https://github.com/TermiOSSH/termios-frontend) | 🎨 Frontend - Next.js + React |
| [termios-backend](https://github.com/TermiOSSH/termios-backend) | ⚙️ Backend - Node.js + Express |

## 🛠 Tech Stack

*(Same as above)*

## 🚀 Quick Start

### Option 1: Docker Deployment (Recommended)

TermiOS provides Docker images for both combined and separate frontend/backend deployments.

#### Combined Deployment (Docker Compose)

The simplest way to run TermiOS - starts both frontend and backend:

```bash
docker compose up -d --build
```

#### Separate Frontend/Backend Deployment

If you need to deploy frontend and backend on different servers:

**Backend Deployment:**
```bash
docker run -d \
  --name termios-backend \
  -p 3001:3001 \
  -e CORS_ORIGIN="*" \
  -e SERVER_PASSWORD="your_secure_password" \
  --restart always \
  ccdecc/termios-backend:latest
```

> **Configuration Guide**:
> - **`CORS_ORIGIN`**:
>   - `*` or `true`: Allow all origins (suitable for development or intranet)
>   - Specific domains: e.g., `http://a.com,http://b.com` (comma-separated, for production)
>   - Empty: Same-origin only (most secure, for reverse proxy setups)
> - **`SERVER_PASSWORD`** (Optional):
>   - A security password for the backend WebSocket connection. If set, clients must provide this password to establish a connection before attempting SSH login. If not set, authentication is skipped.

**Frontend Deployment:**
```bash
# BACKEND_URL points to your backend server (include protocol and port)
docker run -d \
  --name termios-frontend \
  -p 80:80 \
  -e BACKEND_URL="http://your-backend-server:3001" \
  --restart always \
  ccdecc/termios-frontend:latest
```

> ⚠️ **Note**: When deploying separately, ensure the frontend can reach the backend's WebSocket port. If using Nginx reverse proxy, refer to `nginx.conf.example` in the project for WebSocket header configuration.

#### Available Images

| Image | Description | Platforms |
|-------|-------------|-----------|
| `ccdecc/termios:latest` | Combined image (frontend + backend) | amd64, arm64 |
| `ccdecc/termios-backend:latest` | Backend API service | amd64, arm64 |
| `ccdecc/termios-frontend:latest` | Frontend static files + Nginx | amd64, arm64 |

2.  **Access Application**
    Open [http://localhost:3000](http://localhost:3000) in your browser.

### Option 2: Local Development

#### 1. Clone Repositories

```bash
# Clone frontend repository
git clone https://github.com/TermiOSSH/termios-frontend.git frontend

# Clone backend repository
git clone https://github.com/TermiOSSH/termios-backend.git backend
```

#### 2. Install Dependencies

```bash
# Install Backend Dependencies
cd backend
npm install

# Install Frontend Dependencies
cd ../frontend
npm install
```

#### 3. Start Services

You need to run both the backend and frontend servers simultaneously.

**Terminal 1 (Backend - Port 3001):**
```bash
cd backend
npm start
```

**Terminal 2 (Frontend - Port 3000):**
```bash
cd frontend
npm run dev
```

#### 4. Access Application
Open [http://localhost:3000](http://localhost:3000) in your browser.

## 📖 Usage Guide

1.  **Login**: Enter your Linux server credentials (Host, Username, Password) in the login window.
2.  **Terminal**: Click the Terminal icon in the Dock to access the SSH console.
3.  **Finder**: Use the Finder app to manage files and directories.
4.  **Monitoring**: Check the top status bar or open Activity Monitor for system stats.

## 📸 Screenshots

*(Placeholders for future screenshots)*

---

This project is open source and available under the [MIT License](LICENSE).
