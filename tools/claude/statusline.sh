#!/usr/bin/env bash

input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

CYAN='\033[36m'; GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; RESET='\033[0m'

# Pick bar color based on context usage
if [ "$PCT" -ge 90 ]; then BAR_COLOR="$RED"
elif [ "$PCT" -ge 70 ]; then BAR_COLOR="$YELLOW"
else BAR_COLOR="$GREEN"; fi

FILLED=$((PCT / 10)); EMPTY=$((10 - FILLED))
printf -v FILL "%${FILLED}s"; printf -v PAD "%${EMPTY}s"
BAR="${FILL// /█}${PAD// /░}"

BRANCH=""
git rev-parse --git-dir > /dev/null 2>&1 && BRANCH=" | 🌿 $(git branch --show-current 2>/dev/null)"

FIVE_H=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
WEEK=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
SESSION_ID=$(echo "$input" | jq -r '.session_id // empty' | cut -d- -f1)
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')

LIMITS=""
[ -n "$FIVE_H" ] && LIMITS="5h: $(printf '%.0f' "$FIVE_H")%"
[ -n "$WEEK" ] && LIMITS="${LIMITS:+$LIMITS }7d: $(printf '%.0f' "$WEEK")%"

echo -e "📁 ${DIR##*/}$BRANCH"
STATUS=""
if [ -n "$LIMITS" ]; then
  # Subscription billing — show rate limits
  STATUS="🚦 ${LIMITS}"
else
  # API billing — show cost
  COST_FMT=$(printf '$%.2f' "$COST")
  STATUS="💰 ${COST_FMT}"
fi
[ -n "$SESSION_ID" ] && STATUS="${STATUS} | 🏷️ ${SESSION_ID}"
echo -e "$STATUS"
echo -e "${CYAN}[$MODEL]${RESET} ${BAR_COLOR}${BAR}${RESET} ${PCT}%"