#!/bin/bash

set -e

source config.conf
source lib/logger.sh
source lib/monitor.sh
source lib/recovery.sh

COMMAND=$1

WHITELIST=$(cat config.whitelist)

case $COMMAND in
    monitor)
		CPU_USAGE=$(get_cpu_usage)
		MEM_USAGE=$(get_memory_usage)
		DISK_USAGE=$(get_disk_usage)
	
        log "INFO" "CPU Usage: $CPU_USAGE%"
        log "INFO" "Memory Usage: $MEM_USAGE%"
        log "INFO" "Disk Usage: $DISK_USAGE%"
		
		if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
			log "WARNING" "High CPU usage detected: $CPU_USAGE%"
			kill_heavy_process
		fi

		if (( $(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc -l) )); then
			log "WARNING" "High Memory usage detected: $MEM_USAGE%"
		fi

		if (( $(echo "$DISK_USAGE > $DISK_THRESHOLD" | bc -l) )); then
			log "WARNING" "High Disk usage detected: $DISK_USAGE%"
		fi
	;;
    fix)
		log "INFO" "Recovery started"
	;;
    report)
		log "INFO" "Report requested"
	;;
    *)
        echo "Usage: $0 {monitor|fix|report}"
	exit 1
	;;
esac	
