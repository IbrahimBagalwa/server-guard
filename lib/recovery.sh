#!/bin/bash

COOLDOWN_SECONDS=60

kill_heavy_process(){

    if ! check_cooldown; then
        return 0
    fi

    log "WARNING" "Attempting to kill to CPU process"

    PID_INFO=$(ps aux --sort=-%cpu | awk 'NR==2 {print $2, $11}')
    PID=$(echo $PID_INFO | awk '{print $1}')
    PROCESS=$(echo $PID_INFO | awk '{print $2}')
    
    if echo "$WHITELIST" | grep -q "$PROCESS"; then
        log "INFO" "Skipping whitelisted process: $PROCESS"
        return 0
    fi

    if [ "$DRY_RUN" == true ]; then
        log "INFO" "[DRY_RUN] Would kill process: $PROCESS with PID: $PID, not actually killing"
        return 0
    fi

    kill -9 "$PID"
    log "INFO" "Killed process: $PROCESS with PID: $PID"

}

check_cooldown(){
    if [ -f .cooldown ]; then
        LAST=$(cat .cooldown)
        NOW=$(date +%s)

        DIFF=$((NOW - LAST))

        if [ "$DIFF" -lt "$COOLDOWN_SECONDS" ]; then
            log "INFO" "Cooldown active (${DIFF}s elapsed), skipping recovery"
            return 1
        fi
    fi
    date +%s > .cooldown
    return 0
}