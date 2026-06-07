# 🕸️ WebScraper — 开源本地网页爬虫工具，一键提取任意网站数据

> **告别手动复制粘贴，用一台本地电脑，优雅地从任何网站获取你需要的数据。**

在数据驱动的时代，网页数据采集是信息分析、价格监控、舆情追踪、学术研究的基础能力。但现成的爬虫工具要么太专业（Selenium + Python 脚本门槛高），要么太局限（只能抓特定网站）。

**WebScraper** 诞生的初衷很简单：**做一个普通人也能用、开发者也觉得好用的通用网页数据提取工具。** 它完全本地运行，数据不出你的电脑，无需注册账号，打开浏览器就能用。

---

## ✨ 这个工具能做什么？

### 🔍 从任意网站提取六大数据类型

| 数据类型 | 示例场景 |
|---------|---------|
| **📝 文本内容** | 新闻正文、博客文章、论坛帖子、用户评论、商品描述、招聘职位、论文摘要 |
| **🔗 链接信息** | 页面超链接、外链关系、文档下载地址（PDF/Word） |
| **🖼️ 媒体文件** | 图片URL、视频/音频元数据、iframe内嵌内容 |
| **📊 结构化数据** | HTML表格、内联JSON、Schema.org微格式（产品/评价/事件） |
| **🏷️ 元数据** | SEO信息、Open Graph、Twitter Cards、发布日期、作者 |
| **💰 商业数据** | 价格匹配（$xx/¥xx）、评分、房型、库存状态 |

### 🌐 支持真实世界的复杂场景

- **JavaScript 渲染页面**（Vue/React/SPA）→ Playwright 动态爬取
- **无限滚动、延迟加载** → 自动滚动触发
- **需登录的页面** → Cookie/Session 维持
- **反爬虫网站** → 16种UA轮换 + 浏览器指纹模拟 + 请求延迟随机化
- **深层页面结构** → BFS/DFS 递归爬取，最深10层、最多500页

---

## 🚀 三分钟上手

### 1. 安装

```bash
# 克隆项目
git clone https://github.com/your-username/WebScraper.git
cd WebScraper

# 安装依赖
pip install -r requirements.txt
```

### 2. 启动

```bash
python server.py
# 或者双击 start.bat（Windows）
```

浏览器自动打开 `http://localhost:8765`，即可开始使用。

### 3. 可选：安装动态爬取支持

```bash
pip install playwright
python -m playwright install chromium
```

安装后，对于需要 JavaScript 渲染的页面（如 React SPA），选择「动态」模式即可。

---

## 🎯 使用示例

### 示例一：爬取新闻文章

```
URL: https://news.example.com/article/12345
提取类型: ☑ 文本内容 ☑ 链接 ☑ 元数据
```

结果面板会展示文章标题、正文段落、所有超链接、SEO 元数据（作者、发布时间、关键词），支持一键复制或导出。

### 示例二：电商价格监控

```
URL: https://shop.example.com/product/iphone-16
提取类型: ☑ 文本内容 ☑ 结构化数据 ☑ 商业数据
```

自动识别商品标题、描述、价格（支持 ¥/$/€ 等多币种）、规格参数、评分信息。结构化数据标签页展示 Schema.org JSON-LD 中的产品结构化信息。

### 示例三：批量爬取多个页面

1. 点击「批量模式」
2. 输入多个URL（每行一个）
3. 设置爬取深度和最大页数
4. 一键批量提取

### 示例四：深度递归爬取

```
爬取深度: 3
最大页数: 50
仅同域: ✅
```

从一个起始页面出发，自动发现并爬取关联页面，适用于站点分析、内容聚合等场景。

---

## 🛡️ 反爬虫对抗能力

WebScraper 内置了多层次的反检测策略：

| 策略 | 实现方式 |
|------|---------|
| **请求头伪装** | 16种真实浏览器UA自动轮换，完整模拟 Chrome/Firefox/Safari 的 `Sec-Ch-Ua`、`Accept-Language` 等现代请求头 |
| **请求节奏** | 可配置 0~5000ms 随机延迟，模拟人类访问节奏 |
| **指纹隐藏** | Playwright 模式下隐藏 `navigator.webdriver`，移除 HeadlessChrome 标识 |
| **会话维持** | 支持自定义 Cookie、自定义 Headers，可维持登录态 |
| **代理支持** | 兼容 HTTP/SOCKS5 代理，可接入住宅代理池 |
| **TLS 指纹** | 可选 `curl_cffi` 模拟 Chrome TLS 握手特征 |

---

## 📊 数据导出

爬取完成后，支持三种格式一键导出：

- **JSON** — 完整结构化数据，适合程序处理
- **CSV** — 表格数据，适合 Excel 打开分析
- **Excel (.xls)** — 带表头样式，开箱即用

---

## 🏗️ 技术架构

```
WebScraper/
├── index.html          # 前端界面（单文件，无外部CDN依赖）
├── server.py           # Python FastAPI 后端（~60KB，45+函数）
├── requirements.txt    # Python 依赖
├── start.bat           # Windows 一键启动
└── README.md           # 使用说明
```

**前端**：纯 HTML + CSS + JavaScript，Liquid Noir 设计风格，Glassmorphism 毛玻璃效果，流畅的交互动画，响应式布局。

**后端**：Python FastAPI + BeautifulSoup4 + Requests，可选 Playwright。6个 API 端点，支持任务取消和部分结果返回。

---

## 📋 完整功能清单

### 核心能力
- [x] 静态爬取（requests + BeautifulSoup）
- [x] 动态爬取（Playwright 无头浏览器）
- [x] 自动模式（先尝试静态，失败则切换动态）
- [x] 单页面爬取
- [x] 批量多URL爬取
- [x] 递归爬取（BFS/DFS，最深10层，最多500页）
- [x] 中途取消（返回已爬取的部分结果）

### 数据提取
- [x] 文本：正文、标题、段落、列表
- [x] 链接：内部/外部链接分类、全部链接计数
- [x] 媒体：图片（含缩略图预览）、视频、音频、文档链接
- [x] 结构化：HTML表格解析、内联JSON提取、JSON-LD微格式
- [x] 元数据：Title、Description、Keywords、Open Graph、Twitter Cards
- [x] 商业：价格模式匹配、评分、日期、地点
- [x] API调用：XHR/Fetch请求捕获
- [x] iframe内容提取
- [x] WebSocket数据捕获
- [x] Shadow DOM穿透

### 智能功能
- [x] Sitemap.xml 自动发现
- [x] 隐藏链接发现
- [x] URL模式识别与自动遍历
- [x] 自定义CSS选择器
- [x] 页面交互模拟（点击、滚动、输入、悬停）
- [x] 等待特定元素加载完成

### 反爬虫对抗
- [x] 16种User-Agent轮换
- [x] 完整浏览器请求头模拟（Sec-Ch-Ua等）
- [x] Playwright指纹隐藏
- [x] 请求延迟与随机化
- [x] Cookie/Session维持
- [x] 代理IP支持（HTTP/SOCKS5）
- [x] TLS指纹伪装（可选curl_cffi）

### 用户体验
- [x] Liquid Noir 暗色主题 + 毛玻璃效果
- [x] 点击涟漪动效 + 滚动渐入动画
- [x] 实时爬取日志 + 进度条
- [x] 图片网格预览
- [x] JSON数据查看器 + 一键复制
- [x] 9个结果分类标签页
- [x] JSON / CSV / Excel 一键导出
- [x] 响应式布局（移动端适配）

---

## ⚠️ 使用须知

1. **合法合规**：请遵守目标网站的 `robots.txt` 规则，仅用于合法的数据采集和研究目的
2. **控制频率**：建议设置适当的请求延迟（500ms+），避免对目标服务器造成压力
3. **隐私保护**：所有数据本地处理，不上传任何服务器
4. **动态爬取**：部分网站需要 JavaScript 渲染，未安装 Playwright 时自动降级为静态模式

---

## 📜 开源协议

MIT License — 自由使用、修改和分发。

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request。如果你觉得这个工具有用，给个 ⭐ Star 支持一下吧！