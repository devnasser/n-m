#!/usr/bin/env bash
# Real-time monitoring dashboard for Super Professional Mode

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Clear screen and move cursor to top
clear_screen() {
    printf '\033[2J\033[H'
}

# Get system stats
get_stats() {
    # CPU usage
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    
    # Memory
    MEM_INFO=$(free -h | grep Mem)
    MEM_TOTAL=$(echo $MEM_INFO | awk '{print $2}')
    MEM_USED=$(echo $MEM_INFO | awk '{print $3}')
    MEM_FREE=$(echo $MEM_INFO | awk '{print $4}')
    MEM_PERCENT=$(free | grep Mem | awk '{printf "%.1f", $3/$2 * 100.0}')
    
    # Disk
    DISK_INFO=$(df -h /workspace | tail -1)
    DISK_TOTAL=$(echo $DISK_INFO | awk '{print $2}')
    DISK_USED=$(echo $DISK_INFO | awk '{print $3}')
    DISK_FREE=$(echo $DISK_INFO | awk '{print $4}')
    DISK_PERCENT=$(echo $DISK_INFO | awk '{print $5}')
    
    # Load average
    LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}')
    
    # Process count
    PROC_COUNT=$(ps aux | wc -l)
    
    # CPU cores
    CPU_CORES=$(nproc)
    
    # Running services
    KNOWLEDGE_SYNC="❌"
    KNOWLEDGE_WATCH="❌"
    if [[ -f /workspace/me/.knowledge_sync.pid ]]; then
        if ps -p $(cat /workspace/me/.knowledge_sync.pid) > /dev/null 2>&1; then
            KNOWLEDGE_SYNC="✅"
        fi
    fi
    if [[ -f /workspace/me/.knowledge_watch.pid ]]; then
        if ps -p $(cat /workspace/me/.knowledge_watch.pid) > /dev/null 2>&1; then
            KNOWLEDGE_WATCH="✅"
        fi
    fi
    
    # Workspace files
    FILE_COUNT=$(find /workspace -type f 2>/dev/null | wc -l)
    
    # Git status
    if [[ -d /workspace/.git ]]; then
        GIT_BRANCH=$(git branch --show-current 2>/dev/null || echo "N/A")
        GIT_STATUS=$(git status --porcelain 2>/dev/null | wc -l)
    else
        GIT_BRANCH="N/A"
        GIT_STATUS="0"
    fi
}

# Display dashboard
display_dashboard() {
    clear_screen
    
    echo -e "${BOLD}${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${CYAN}                    SUPER PROFESSIONAL MODE - MONITORING DASHBOARD${NC}"
    echo -e "${BOLD}${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Time: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo ""
    
    # System Resources
    echo -e "${BOLD}${GREEN}📊 SYSTEM RESOURCES${NC}"
    echo -e "├─ ${CYAN}CPU Usage:${NC} ${CPU_USAGE}% (${CPU_CORES} cores)"
    echo -e "├─ ${CYAN}Memory:${NC} ${MEM_USED}/${MEM_TOTAL} (${MEM_PERCENT}%)"
    echo -e "├─ ${CYAN}Disk:${NC} ${DISK_USED}/${DISK_TOTAL} (${DISK_PERCENT})"
    echo -e "└─ ${CYAN}Load Average:${NC} ${LOAD_AVG}"
    echo ""
    
    # Performance Indicators
    echo -e "${BOLD}${GREEN}⚡ PERFORMANCE INDICATORS${NC}"
    echo -e "├─ ${CYAN}Process Count:${NC} ${PROC_COUNT}"
    echo -e "├─ ${CYAN}Workspace Files:${NC} ${FILE_COUNT}"
    echo -e "├─ ${CYAN}Git Branch:${NC} ${GIT_BRANCH}"
    echo -e "└─ ${CYAN}Uncommitted Changes:${NC} ${GIT_STATUS}"
    echo ""
    
    # Service Status
    echo -e "${BOLD}${GREEN}🔧 SERVICE STATUS${NC}"
    echo -e "├─ ${CYAN}Knowledge Sync:${NC} ${KNOWLEDGE_SYNC}"
    echo -e "├─ ${CYAN}Knowledge Watch:${NC} ${KNOWLEDGE_WATCH}"
    echo -e "└─ ${CYAN}Monitoring:${NC} ✅"
    echo ""
    
    # Performance Bar Charts
    echo -e "${BOLD}${GREEN}📈 RESOURCE UTILIZATION${NC}"
    
    # CPU bar
    echo -n "CPU:  ["
    CPU_BAR_LENGTH=$((${CPU_USAGE%.*} / 2))
    for i in $(seq 1 50); do
        if [[ $i -le $CPU_BAR_LENGTH ]]; then
            echo -n "█"
        else
            echo -n "░"
        fi
    done
    echo "] ${CPU_USAGE}%"
    
    # Memory bar
    echo -n "MEM:  ["
    MEM_BAR_LENGTH=$((${MEM_PERCENT%.*} / 2))
    for i in $(seq 1 50); do
        if [[ $i -le $MEM_BAR_LENGTH ]]; then
            echo -n "█"
        else
            echo -n "░"
        fi
    done
    echo "] ${MEM_PERCENT}%"
    
    # Disk bar
    echo -n "DISK: ["
    DISK_BAR_LENGTH=$((${DISK_PERCENT%\%} / 2))
    for i in $(seq 1 50); do
        if [[ $i -le $DISK_BAR_LENGTH ]]; then
            echo -n "█"
        else
            echo -n "░"
        fi
    done
    echo "] ${DISK_PERCENT}"
    
    echo ""
    echo -e "${BOLD}${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Press Ctrl+C to exit${NC}"
}

# Main loop
main() {
    # Trap Ctrl+C
    trap 'echo -e "\n${GREEN}Monitoring stopped${NC}"; exit 0' INT TERM
    
    while true; do
        get_stats
        display_dashboard
        sleep 2
    done
}

# Run if not sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi