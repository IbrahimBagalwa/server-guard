#!/bin/bash

LOG_FILE="logs/system.log"

log(){
    LEVEL=$1
    MESSAGE=$2
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

    echo "[$TIMESTAMP] [$LEVEL] $MESSAGE" | tee -a $LOG_FILE
}
