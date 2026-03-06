---
name: auto-news-delivery
description: 定时新闻自动推送。自动化获取热点新闻并通过 Telegram 定时发送，支持手动触发和 cron 定时任务。触发条件：(1) 用户请求"时讯"、"新闻"、"今日热点"，(2) 定时任务触发，(3) 任何需要新闻简报的场景。
---

# 自动新闻推送技能

自动化获取热点新闻并通过 Telegram 定时发送。

## 功能

- 定时获取当日热点新闻（国内+国际+科技+体育）
- 按题材分类，每类 3 条
- 支持 cron 定时自动发送
- 支持手动触发

## 依赖

1. **Tavily API Key**: 从 https://tavily.com 获取
2. **OpenClaw**: 已配置 Telegram 频道

## 快速开始

### 1. 配置 API Key

```bash
# 方式一：设置环境变量
export TAVILY_API_KEY="你的API密钥"

# 方式二：写入配置文件
echo "TAVILY_API_KEY=你的API密钥" > /root/.openclaw/.env
```

### 2. 配置定时任务

```bash
# 编辑 crontab
crontab -e

# 添加定时任务（每天 10:00 和 16:00）
0 10 * * * /path/to/auto-news-delivery/scripts/send-news.sh >> /tmp/news-cron.log 2>&1
0 16 * * * /path/to/auto-news-delivery/scripts/send-news.sh >> /tmp/news-cron.log 2>&1
```

### 3. 手动触发

```bash
# 直接运行脚本
/path/to/auto-news-delivery/scripts/send-news.sh
```

## 脚本位置

```
{skill}/scripts/send-news.sh
```

## 配置项

编辑脚本顶部的配置变量：

| 变量 | 默认值 | 说明 |
|------|--------|------|
| CHAT_ID | （必填） | Telegram 接收者 ID |
| TAVILY_API_KEY | 环境变量/.env | Tavily API 密钥 |
| OPENCLAW | openclaw | OpenClaw 命令路径 |
| OPENCLAW_DIR | ~/.openclaw | OpenClaw 配置目录 |

**注意**：首次使用必须配置 `CHAT_ID` 和 `TAVILY_API_KEY`

## 自定义新闻分类

编辑 `get_news` 函数中的查询关键词：

```bash
INTL=$(get_news "今日国际热点 news BBC CNN Reuters breaking")
CHINA=$(get_news "中国今日热点新闻 两会 经济 社会")
TECH=$(get_news "科技互联网AI热点 人工智能")
SPORT=$(get_news "今日体育新闻 足球 篮球")
```

## 常见问题

**Q: cron 任务没有执行？**
A: 确保脚本有执行权限 `chmod +x send-news.sh`，并检查日志 `/tmp/news-cron.log`

**Q: 新闻内容为空？**
A: 检查 TAVILY_API_KEY 是否正确配置，脚本会自动从 `/root/.openclaw/.env` 读取

**Q: 消息发送失败？**
A: 检查 OpenClaw 是否运行中，Telegram 频道是否正确配置
