#!/bin/bash

print_usage(){
    echo "Usage:"
    echo "  $0 <command> [options]"
    echo ""
    echo "Commands:"
    echo "  monitor   Run system monitoring and automatic recovery"
    echo "  fix       Run manual recovery actions"
    echo "  report    Generate a system report"
    echo "  help      Show this help message"
    echo ""
    echo "Options:"
    echo "  -v, --verbose   Enable verbose output"
    echo "  --debug         Enable debug mode"
}

input_validation(){
    local msg="$1"
    echo  "Error:"
    echo "Error: $msg"
    echo ""
    print_usage
    exit 1
}