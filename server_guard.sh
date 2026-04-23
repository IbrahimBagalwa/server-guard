#!/bin/bash
set -e

source lib/monitor.sh
source lib/logger.sh

COMMAND=$1
case $COMMAND in
    monitor)
		CPU_USAGE=$(get_cpu_usage)
		MEM_USAGE=$(get_memory_usage)
		DISK_USAGE=$(get_disk_usage)
	
        log "INFO" "CPU Usage: $CPU_USAGE%"
        log "INFO" "Memory Usage: $MEM_USAGE%"
        log "INFO" "Disk Usage: $DISK_USAGE%"
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
