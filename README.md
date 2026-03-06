# Auto News Delivery

定时新闻自动推送技能 - 自动化获取热点新闻并通过 Telegram 定时发送。

## 功能

- 定时获取当日热点新闻（国内+国际+科技+体育）
- 按题材分类，每类 3 条
- 支持 cron 定时自动发送
- 支持手动触发

## 快速开始

### 1. 安装技能

```bash
# 方式一：从源码安装
cp -r auto-news-delivery ~/.openclaw/workspace/skills/

# 方式二：使用 OpenClaw skill install（如果支持）
openclaw skill install auto-news-delivery.skill
```

### 2. 配置

编辑 `scripts/send-news.sh` 顶部配置：

```bash
CHAT_ID="你的Telegram_ID"
TAVILY_API_KEY="你的API密钥"
```

获取 Tavily API Key: https://tavily.com

### 3. 设置定时任务

```bash
crontab -e

# 添加定时任务
0 10 * * * /path/to/auto-news-delivery/scripts/send-news.sh >> /tmp/news-cron.log 2>&1
0 16 * * * /path/to/auto-news-delivery/scripts/send-news.sh >> /tmp/news-cron.log 2>&1
```

## 手动触发

```bash
/path/to/auto-news-delivery/scripts/send-news.sh
```

## 自定义新闻分类

编辑 `scripts/send-news.sh` 中的查询关键词：

```bash
INTL=$(get_news "今日国际热点 news BBC CNN Reuters breaking")
CHINA=$(get_news "中国今日热点新闻 两会 经济 社会")
TECH=$(get_news "科技互联网AI热点 人工智能")
SPORT=$(get_news "今日体育新闻 足球 篮球")
```

## 文件说明

```
auto-news-delivery/
├── SKILL.md              # 技能说明文档
├── scripts/
│   └── send-news.sh     # 新闻发送脚本
└── auto-news-delivery.skill  # 打包好的技能文件
```

## 依赖

- OpenClaw
- Tavily API
- Bash + Python3
- curl

## License

MIT
