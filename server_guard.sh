#!/bin/bash
set -e

source lib/*

COMMAND=$1

case $COMMAND in
    monitor)
	CPU_USAGE=$(get_cpu_usage)
        log "INFO" "CPU Usage: $CPU_USAGE%"
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
