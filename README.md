# 🕸️ WebScraper — 通用网页爬虫工具

一个本地部署的通用网页爬虫，支持从任意网站提取文本、链接、媒体、结构化数据、元数据和业务数据。

## 功能特性

- 🔍 **多模式爬取**：静态爬取（快速）+ 动态爬取（Playwright，支持JS渲染）
- 📊 **全面数据提取**：文本、链接、媒体、结构化数据、元数据、商业数据
- 🌐 **多页面爬取**：自动发现链接，按深度和数量限制递归爬取
- 💾 **多格式导出**：JSON / CSV / Excel
- 🎨 **精美UI**：玻璃拟态设计，流畅动画

## 快速开始

### 前置要求
- Python 3.8 或更高版本
- pip（Python包管理器）

### 启动方式

**方式一：双击启动（推荐）**
```
双击 start.bat
```

**方式二：命令行启动**
```bash
cd WebScraper
pip install -r requirements.txt
python server.py
```

启动后浏览器会自动打开 http://localhost:8765

### 可选：安装 Playwright（动态爬取）
```bash
pip install playwright
python -m playwright install chromium
```

## 使用方法

1. 在输入框中输入要爬取的URL
2. 选择爬取模式（自动/静态/动态）
3. 勾选需要提取的数据类型
4. 配置高级选项（爬取深度、最大页数等）
5. 点击"🔍 爬取"按钮
6. 查看结果并导出

## API 接口

项目提供两套 API，均可从外部程序直接调用：

### 简化 API（v1）— 推荐对接使用

| 端点 | 方法 | 说明 |
|------|------|------|
| `/api/v1/health` | GET | 健康检查 |
| `/api/v1/scrape?url=&format=` | GET | 爬取网页（最简单） |
| `/api/v1/scrape` | POST | 爬取网页（完整参数） |
| `/api/v1/batch` | POST | 批量爬取多个 URL |
| `/api/v1/extract` | POST | 指定类型提取 |
| `/api/v1/export?url=&format=csv` | GET | 导出 CSV 文件 |
| `/api/v1/hotlist?platform=weibo` | GET | 热词榜 |
| `/api/v1/github/trending?since=daily` | GET | GitHub 热榜 |

### 完整 API — 支持全部高级选项

| 端点 | 方法 | 说明 |
|------|------|------|
| `/api/health` | GET | 健康检查 |
| `/api/scrape` | POST | 完整爬取（代理/交互/WS捕获等） |
| `/api/scrape/batch` | POST | 完整批量爬取 |
| `/api/scrape/cancel` | POST | 取消运行中的任务 |
| `/api/scrape/status/{task_id}` | GET | 查询任务状态 |
| `/api/hotlist` | GET | 热词榜 |
| `/api/github/trending` | GET | GitHub Trending |
| `/api/proxy` | POST | CORS 代理 |

📖 **详细对接教程请查看 [API.md](API.md)**

Swagger 交互文档：启动服务后访问 `http://localhost:8765/docs`

## 技术栈

- **前端**：纯HTML/CSS/JavaScript（无外部依赖）
- **后端**：Python FastAPI + BeautifulSoup4 + requests
- **可选**：Playwright（动态页面渲染）

## 注意事项

- 请遵守目标网站的 robots.txt 规则
- 控制爬取频率，避免对目标服务器造成压力
- 仅用于合法的数据采集和研究目的
- 部分网站可能有反爬虫机制，动态模式可能更有效

## 许可

MIT License
