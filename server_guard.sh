#!/bin/bash

set -e

trap 'echo "[ERROR] Script failed at line $LINENO"; exit 1' ERR

init() {
	source config.conf
	source lib/logger.sh
	source lib/monitor.sh
	source lib/recovery.sh
	source lib/validation.sh

	if [ ! -f config.whitelist ]; then
		log "ERROR" "config.whitelist not found"
		exit 1
	fi

	WHITELIST=$(cat config.whitelist)
}

COMMAND=""
FLAG=""
VERBOSE=false
DEBUG=false

parse_args() {
	local num_args=$#

	if [[ "$1" == "--help" || "$1" == "-h" || "$1" == "help" ]]; then
		print_usage
		exit 0
	fi

	if [ "$num_args" -gt 2 ]; then
		input_validation "Too many arguments provided"
	fi

	if [ "$num_args" -eq 0 ]; then
		input_validation "No command provided"
	fi
	COMMAND="$1"
	FLAG="$2"

	if [ "$num_args" -eq 2 ]; then
		case "$FLAG" in
			--verbose|-v)
				VERBOSE=true
				;;
			--debug)
				DEBUG=true
				;;
			*)
				input_validation "Invalid flag: $FLAG"
				;;
		esac
	fi

	if [ "$DEBUG" == true ]; then
		set -x
	fi
}

vlog() {
	if [ "$VERBOSE" == true ]; then
		log "INFO" "$1"
	fi
}

collect_metrics() {
	CPU_USAGE=$(get_cpu_usage)
	MEM_USAGE=$(get_memory_usage)
	DISK_USAGE=$(get_disk_usage)
}
run_monitor() {
	vlog "Fetching system metrics..."
	collect_metrics

	log "INFO" "CPU Usage: $CPU_USAGE%"
	log "INFO" "Memory Usage: $MEM_USAGE%"
	log "INFO" "Disk Usage: $DISK_USAGE%"
	
	vlog "Checking thresholds..."

	if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
		log "WARNING" "High CPU usage detected: $CPU_USAGE%"
		vlog "Triggering recovery..."
		kill_heavy_process
	fi

	if (( $(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc -l) )); then
		log "WARNING" "High Memory usage detected: $MEM_USAGE%"
	fi

	if (( $(echo "$DISK_USAGE > $DISK_THRESHOLD" | bc -l) )); then
		log "WARNING" "High Disk usage detected: $DISK_USAGE%"
	fi

}

run_fix() {
	log "INFO" "Manual recovery started"
	CPU_USAGE=$(get_cpu_usage)

	if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
		log "WARNING" "CPU still high in manual fix mode: $CPU_USAGE%"
		vlog "Triggering recovery from fix command..."
		kill_heavy_process
	else
		log "INFO" "CPU usage is normal in manual fix mode: $CPU_USAGE%"
	fi
}

run_report() {
	vlog "Generating system report..."
	TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
	FILE_DATE=$(date '+%Y-%m-%d-%H-%M-%S')

	REPORT_DIR="reports"
	mkdir -p "$REPORT_DIR"

	REPORT_FILE="$REPORT_DIR/report-$FILE_DATE.txt"

	CPU_USAGE=$(get_cpu_usage)
	MEM_USAGE=$(get_memory_usage)
	DISK_USAGE=$(get_disk_usage)
	
	{
		echo "======================================"
		echo "      SERVER GUARD SYSTEM REPORT      "
		echo "======================================"
		echo ""
		echo "Service      : Server Guard CLI Monitor"
		echo "Author       : Ibrahim Bagalwa"
		echo "Generated At : $TIMESTAMP"
		echo ""
		echo "--------------------------------------"
		echo "SYSTEM METRICS"
		echo "--------------------------------------"
		echo "CPU Usage    : $CPU_USAGE%"
		echo "Memory Usage : $MEM_USAGE%"
		echo "Disk Usage   : $DISK_USAGE%"
		echo ""
		echo "--------------------------------------"
		echo "THRESHOLDS"
		echo "--------------------------------------"
		echo "CPU Threshold : $CPU_THRESHOLD%"
		echo "Mem Threshold : $MEM_THRESHOLD%"
		echo "Disk Threshold: $DISK_THRESHOLD%"
		echo ""
		echo "======================================"
	} | tee "$REPORT_FILE"

	log "INFO" "Report requested: $REPORT_FILE"
}

main() {
	init
	parse_args "$@"

	case "$COMMAND" in
	monitor) run_monitor ;;
	fix) run_fix ;;
	report) run_report ;;
	*) input_validation "Invalid command: $COMMAND" ;;
	esac
}

main "$@"