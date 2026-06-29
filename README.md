# Quizly

这是一个基于 Next.js 和 Bun 开发的测验系统。

## 本地开发调试

如果你想在本地开发和调试本项目，请确保已安装 Bun。

### 1. 安装依赖

```bash
bun install
```

### 2. 启动开发服务器

```bash
bun dev
```

启动后，在浏览器中访问 [http://localhost:3000](http://localhost:3000) 即可查看效果。

---

## Docker 部署与运行

如果你有 Docker 环境，可以直接使用 Docker Compose 快速构建并启动本服务。

### 1. 快速启动

在项目根目录下执行以下命令：

```bash
# 构建镜像并后台启动容器
docker compose up -d --build
```

服务启动后，可以通过以下地址访问：
- **访问地址**: `http://localhost:628`

### 2. 常用命令

```bash
# 查看容器运行日志
docker compose logs -f

# 停止服务并移除容器
docker compose down

# 重新编译构建镜像
docker compose build --no-cache
```

### 3. 数据持久化
容器启动时会自动初始化并更新 SQLite 数据库。内置的 SQLite 数据库文件会自动挂载至 Docker 命名卷 `quiz-db-data` 中（映射到容器内的 `/app/data/quiz.db`），这能确保即使重建或重启容器，你的数据和题目也不会丢失。
