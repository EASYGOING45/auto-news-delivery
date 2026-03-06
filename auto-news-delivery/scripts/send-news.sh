#!/bin/bash
# 每日时讯定时任务脚本
# 用法: 直接运行即可，定时任务会自动执行

# ============ 配置项 (根据需要修改) ============
# Telegram 聊天 ID（需要自行配置）
CHAT_ID=""

# Tavily API Key (从环境变量或文件读取)
TAVILY_API_KEY="${TAVILY_API_KEY:-}"

# OpenClaw 路径（根据实际安装位置修改）
OPENCLAW="openclaw"

# OpenClaw 配置目录
OPENCLAW_DIR="$HOME/.openclaw"

# ============ 脚本逻辑 (一般不需要修改) ============

# 修复 cron 环境下的 PATH
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.nvm/versions/node/v22.22.0/bin"

# 如果环境变量没有，从文件读取
if [ -z "$TAVILY_API_KEY" ]; then
    source "$OPENCLAW_DIR/.env" 2>/dev/null
fi

# 检查 API Key
if [ -z "$TAVILY_API_KEY" ]; then
    echo "错误: 未设置 TAVILY_API_KEY"
    exit 1
fi

# 获取日期
DATE=$(date "+%Y年%m月%d日")

# 使用 Tavily API 获取不同分类的新闻
get_news() {
    local query="$1"
    curl -s "https://api.tavily.com/search" \
      -H "Content-Type: application/json" \
      -d "{\"api_key\":\"$TAVILY_API_KEY\",\"query\":\"$query\",\"search_depth\":\"basic\",\"max_results\":3}" | \
      python3 -c "
import sys, json
data = json.load(sys.stdin)
results = data.get('results', [])
for r in results:
    title = r.get('title', '')
    url = r.get('url', '')
    short_url = url.split('://')[1].split('/')[0] if '://' in url else url
    print(f'• {title}')
    print(f'  🔗 {short_url}')
" 2>/dev/null
}

# 中文标题 + 国际媒体源
INTL=$(get_news "今日国际热点 news BBC CNN Reuters breaking")
CHINA=$(get_news "中国今日热点新闻 两会 经济 社会")
TECH=$(get_news "科技互联网AI热点 人工智能")
SPORT=$(get_news "今日体育新闻 足球 篮球")

# 合成消息（中文）
MESSAGE="📰 $DATE 时讯

🌍 国际
$INTL

🇨🇳 国内
$CHINA

💻 科技
$TECH

⚽ 体育
$SPORT"

# 直接发送到 Telegram
$OPENCLAW message send \
  --channel telegram \
  --target "$CHAT_ID" \
  --message "$MESSAGE"

echo "$(date): 时讯已发送"
