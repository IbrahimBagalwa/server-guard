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

get_memory_usage(){
    if [[ "$OSTYPE" == "darwin"* ]]; then
      used=$(vm_stat | grep "Pages active" | awk '{print $3}' | tr -d '.')
      free=$(vm_stat | grep "Pages free" | awk '{print $3}' | tr -d '.')
      total=$((used + free))

      usage=$(echo "($used / $total) * 100" | bc -l)

    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
      usage=$(free | grep Mem | awk '{print ($3/$2) * 100}')
    else
      echo "Unsupported OS"
      return 1
    fi

    echo $usage
}

get_disk_usage(){
    usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    echo $usage
}