#!/bin/bash

get_cpu_usage(){
    if [[ "$OSTYPE" == "darwin"* ]]; then
    	idle=$(top -l 1 | grep "CPU usage" | awk '{print $7}' | sed 's/%//')
    	cpu=$(echo "100 - $idle" | bc)
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    	cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
    else
	    echo "Unsupported OS"
	return 1
    fi
   echo $cpu
}
