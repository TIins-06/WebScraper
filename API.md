# 🕸️ WebScraper API 对接教程

> 服务地址：`http://localhost:8765`  
> 所有接口返回 JSON，无需认证，支持 CORS 跨域调用。

---

## 目录

1. [快速验证](#1-快速验证)
2. [网页爬取](#2-网页爬取)
3. [批量爬取](#3-批量爬取)
4. [指定类型提取](#4-指定类型提取)
5. [导出文件](#5-导出文件)
6. [热词榜](#6-热词榜)
7. [GitHub 热榜](#7-github-热榜)
8. [代理请求](#8-代理请求)
9. [前端集成示例](#9-前端集成示例)
10. [Python 集成示例](#10-python-集成示例)
11. [Node.js 集成示例](#11-nodejs-集成示例)

---

## 1. 快速验证

```bash
curl http://localhost:8765/api/v1/health
```

返回：
```json
{
  "ok": true,
  "version": "2.0.0",
  "playwright": true,
  "endpoints": ["..."]
}
```

---

## 2. 网页爬取

### GET 方式（最简单）

```bash
# 获取完整 JSON 结果
curl "http://localhost:8765/api/v1/scrape?url=https://example.com"

# 只要文本内容
curl "http://localhost:8765/api/v1/scrape?url=https://example.com&format=text"

# 只要链接
curl "http://localhost:8765/api/v1/scrape?url=https://example.com&format=links"
```

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `url` | string | **必填** | 目标网址 |
| `format` | string | `json` | 返回格式：`json` / `text` / `links` |
| `extract_types` | string | `text,links,metadata` | 逗号分隔的提取类型 |
| `timeout` | int | `30` | 超时秒数（5-120） |
| `depth` | int | `0` | 爬取深度（0-5） |
| `max_pages` | int | `1` | 最大页数（1-50） |

### POST 方式（完整参数）

```bash
curl -X POST http://localhost:8765/api/v1/scrape \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com",
    "extract_types": ["text", "links", "metadata"],
    "timeout": 30,
    "depth": 0,
    "max_pages": 1,
    "proxy": null
  }'
```

### 响应格式

```json
{
  "success": true,
  "url": "https://example.com",
  "title": "Example Domain",
  "status_code": 200,
  "extracted": {
    "text": { "main_content": "...", "headings": [...], "paragraphs": [...] },
    "links": { "internal": [...], "external": [...], "all_count": 42 },
    "metadata": { "title": "...", "description": "...", "keywords": "..." }
  }
}
```

---

## 3. 批量爬取

一次提交多个 URL，最多 20 个。

```bash
curl -X POST http://localhost:8765/api/v1/batch \
  -H "Content-Type: application/json" \
  -d '{
    "urls": [
      "https://example.com",
      "https://httpbin.org/html",
      "https://quotes.toscrape.com"
    ],
    "extract_types": ["text", "metadata"],
    "timeout": 20
  }'
```

### 响应格式

```json
{
  "success": true,
  "count": 3,
  "pages": [ ... ],
  "errors": []
}
```

---

## 4. 指定类型提取

只提取一种特定类型的数据，减少响应体积。

```bash
curl -X POST http://localhost:8765/api/v1/extract \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com", "extract_type": "text"}'
```

可选 `extract_type`：

| 值 | 说明 |
|----|------|
| `text` | 正文、标题、段落、列表 |
| `links` | 内部/外部链接 |
| `media` | 图片、视频、音频、文档 |
| `structured` | 表格、JSON-LD、微数据 |
| `metadata` | OG 标签、Twitter Cards、SEO 信息 |
| `business` | 价格、评分、日期、地址 |

### 响应格式

```json
{
  "success": true,
  "url": "https://example.com",
  "title": "Example Domain",
  "type": "text",
  "data": {
    "main_content": "...",
    "headings": [...],
    "paragraphs": [...]
  }
}
```

---

## 5. 导出文件

直接导出为 CSV 文件下载。

```bash
curl -o export.csv "http://localhost:8765/api/v1/export?url=https://example.com&format=csv"
```

| 参数 | 类型 | 说明 |
|------|------|------|
| `url` | string | 目标网址 |
| `format` | string | `json`（默认）或 `csv` |
| `extract_types` | string | 逗号分隔的提取类型 |

---

## 6. 热词榜

获取各大平台热搜/热榜数据。

```bash
# 微博热搜
curl "http://localhost:8765/api/v1/hotlist?platform=weibo"

# 知乎热榜
curl "http://localhost:8765/api/v1/hotlist?platform=zhihu"
```

| 平台 | platform 值 |
|------|-------------|
| 微博热搜 | `weibo` |
| 知乎热榜 | `zhihu` |
| 百度热搜 | `baidu` |
| 抖音热点 | `douyin` |
| 头条热榜 | `toutiao` |
| B站热门 | `bilibili` |

### 响应格式

```json
{
  "success": true,
  "platform": "weibo",
  "name": "微博热搜",
  "items": [
    { "rank": 1, "title": "...", "heat": 1234567, "url": "..." }
  ],
  "count": 50,
  "updated_at": "2026-06-08T12:00:00"
}
```

---

## 7. GitHub 热榜

获取 GitHub Trending 项目列表（英文描述自动翻译为中文）。

```bash
# 今日热榜
curl "http://localhost:8765/api/v1/github/trending?since=daily"

# 本周热榜
curl "http://localhost:8765/api/v1/github/trending?since=weekly"
```

### 响应格式

```json
{
  "success": true,
  "since": "daily",
  "repos": [
    {
      "rank": 1,
      "owner": "user",
      "name": "repo",
      "full_name": "user/repo",
      "url": "https://github.com/user/repo",
      "description": "项目描述（已翻译为中文）",
      "language": "Python",
      "stars": 12345,
      "forks": 678,
      "stars_period": 500
    }
  ],
  "count": 25
}
```

---

## 8. 代理请求

通过后端代理访问任意 URL，用于绕过 CORS 限制。

```bash
curl -X POST http://localhost:8765/api/proxy \
  -H "Content-Type: application/json" \
  -d '{"url": "https://api.example.com/data", "method": "GET"}'
```

---

## 9. 前端集成示例

### HTML + JavaScript

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head><meta charset="UTF-8"><title>爬虫调用示例</title></head>
<body>
  <input id="urlInput" type="text" placeholder="输入网址" value="https://example.com" style="width:400px;padding:8px">
  <button onclick="scrape()">爬取</button>
  <pre id="result" style="background:#1e1e2e;color:#cdd6f4;padding:16px;border-radius:8px;overflow:auto;max-height:500px"></pre>

  <script>
  async function scrape() {
    const url = document.getElementById('urlInput').value;
    const resultEl = document.getElementById('result');
    resultEl.textContent = '爬取中...';

    try {
      const res = await fetch('http://localhost:8765/api/v1/scrape?url=' + encodeURIComponent(url) + '&format=json');
      const data = await res.json();
      resultEl.textContent = JSON.stringify(data, null, 2);
    } catch (e) {
      resultEl.textContent = '错误: ' + e.message;
    }
  }
  </script>
</body>
</html>
```

---

## 10. Python 集成示例

```python
import requests

BASE = "http://localhost:8765"

# --- 简单爬取 ---
resp = requests.get(f"{BASE}/api/v1/scrape", params={
    "url": "https://quotes.toscrape.com",
    "format": "text"
})
data = resp.json()
print("标题:", data["title"])
print("内容:", data["text"][:200])

# --- 批量爬取 ---
resp = requests.post(f"{BASE}/api/v1/batch", json={
    "urls": ["https://example.com", "https://httpbin.org/html"],
    "extract_types": ["text", "metadata"],
    "timeout": 20
})
result = resp.json()
print(f"成功爬取 {result['count']} 个页面")

# --- 提取特定类型 ---
resp = requests.post(f"{BASE}/api/v1/extract", json={
    "url": "https://quotes.toscrape.com",
    "extract_type": "links"
})
links = resp.json()["data"]
print(f"内部链接: {len(links.get('internal', []))} 个")

# --- 热词榜 ---
resp = requests.get(f"{BASE}/api/v1/hotlist", params={"platform": "weibo"})
for item in resp.json()["items"][:5]:
    print(f"{item['rank']}. {item['title']} ({item['heat']})")

# --- GitHub 热榜 ---
resp = requests.get(f"{BASE}/api/v1/github/trending", params={"since": "daily"})
for repo in resp.json()["repos"][:5]:
    print(f"⭐ {repo['stars']:>6}  {repo['full_name']}")
    print(f"   {repo['description']}")
```

---

## 11. Node.js 集成示例

```javascript
const BASE = 'http://localhost:8765';

// --- 简单爬取 ---
async function scrape(url) {
  const res = await fetch(`${BASE}/api/v1/scrape?url=${encodeURIComponent(url)}&format=json`);
  return await res.json();
}

// --- 批量爬取 ---
async function batchScrape(urls) {
  const res = await fetch(`${BASE}/api/v1/batch`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ urls, extract_types: ['text', 'metadata'], timeout: 20 })
  });
  return await res.json();
}

// --- 热词榜 ---
async function getHotlist(platform = 'weibo') {
  const res = await fetch(`${BASE}/api/v1/hotlist?platform=${platform}`);
  return await res.json();
}

// --- 使用示例 ---
(async () => {
  const result = await scrape('https://example.com');
  console.log('标题:', result.title);
  console.log('内容:', result.extracted?.text?.main_content?.slice(0, 200));
})();
```

---

## 错误处理

所有接口在出错时返回：

```json
{
  "detail": "错误描述"
}
```

常见错误码：

| 状态码 | 说明 |
|--------|------|
| `200` | 成功 |
| `400` | 参数错误（缺少必填参数或格式不对） |
| `404` | 资源不存在 |
| `500` | 服务器内部错误（爬取失败等） |
| `502` | 代理请求失败 |

---

## 提取类型一览

| 类型 | 说明 | 返回内容 |
|------|------|----------|
| `text` | 文本内容 | 正文、标题、段落、列表 |
| `links` | 链接 | 内部/外部链接、站点地图链接 |
| `media` | 媒体文件 | 图片、视频、音频、文档 |
| `structured` | 结构化数据 | 表格、JSON-LD、内联 JSON |
| `metadata` | 元数据 | SEO 标签、OG、Twitter Cards |
| `business` | 商业数据 | 价格、评分、日期、地址 |

---

## 高级配置（完整 API）

如需更精细的控制（自定义请求头、Cookies、交互操作等），请使用完整 API：

| 端点 | 方法 | 说明 |
|------|------|------|
| `/api/scrape` | POST | 完整爬取（支持所有选项） |
| `/api/scrape/batch` | POST | 完整批量爬取 |
| `/api/scrape/cancel` | POST | 取消正在运行的任务 |
| `/api/scrape/status/{task_id}` | GET | 查询任务状态 |
| `/api/hotlist` | GET | 获取热词榜 |
| `/api/hotlist/refresh` | POST | 刷新热词榜 |
| `/api/github/trending` | GET | GitHub Trending |
| `/api/proxy` | POST | CORS 代理 |

完整 API 文档请访问：`http://localhost:8765/docs`（Swagger UI）
