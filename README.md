# Quizly

Quizly 是一个基于 Next.js、Bun 和 Prisma 的在线测验系统。

## 先决条件

- Bun
- Docker / Docker Compose
- PostgreSQL

## 本地开发

### 1. 安装依赖

```bash
bun install
```

### 2. 配置数据库连接

在项目根目录创建一个 `.env` 文件，并设置你的 PostgreSQL 连接：

```env
DATABASE_URL=postgresql://quizly:quizly@localhost:5432/quizly
```

### 3. 启动开发服务器

```bash
bun dev
```

浏览器访问：

- `http://localhost:3000`

## 生产构建

```bash
bun install
bun run build
bun run start
```

## Docker 部署

项目提供 Docker Compose 配置，仅构建并运行 Web 服务。请确保服务器上已有可用 PostgreSQL 实例。

### 1. 配置数据库地址

在项目根目录创建一个 `.env` 文件：

```env
DATABASE_URL=postgresql://quizly:quizly@your-postgres-host:5432/quizly
```

### 2. 构建并启动

```bash
docker compose up -d --build
```

### 3. 访问服务

- `http://localhost:628`

### 4. 日志与停止

```bash
docker compose logs -f
docker compose down
```

## 说明

- 应用在容器启动时会自动执行 Prisma 迁移，确保 PostgreSQL 数据库模式已同步。
- Docker Compose 当前不再提供 Postgres 服务；它只构建和运行 Web 应用容器。
- 如果你在本地或服务器上遇到数据库连接问题，请检查 `DATABASE_URL` 是否指向有效的 PostgreSQL 实例。
