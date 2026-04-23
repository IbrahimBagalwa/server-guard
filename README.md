# Server Guard CLI

## Overview

Server Guard is a Bash-based system monitoring tool that tracks CPU, memory, and disk usage, and performs basic recovery actions when system thresholds are exceeded.

It is designed as a learning project to practice system monitoring, CLI design, and modular Bash scripting.

## Features

- Monitor CPU, memory, and disk usage
- Threshold-based alerts
- Automatic CPU recovery actions
- Manual recovery mode
- System report generation
- Structured logging
- Debug and verbose modes

## Project Structure

```bash
server-guard/
├── server_guard.sh        # Main CLI entry point
├── config.conf           # Threshold configuration
├── config.whitelist      # Whitelisted processes
│
├── lib/
│   ├── logger.sh         # Logging utilities
│   ├── monitor.sh        # System metrics collection
│   ├── recovery.sh       # Recovery actions
│   └── validation.sh     # Input validation and CLI usage
│
├── logs/
│   └── system.log        # Runtime logs
│
├── reports/
│   └── (generated files) # System reports output
│
└── plugins/              # Future extensions
```

## Usage

### Monitor system

```bash
./server_guard.sh monitor
```

### Manual fix

```bash
./server_guard.sh fix
```

### Generate report

```bash
./server_guard.sh report
```

### Help

```bash
./server_guard.sh --help
```

### Modes

#### Verbose

Shows additional runtime information.

```bash
./server_guard.sh monitor --verbose
```

#### Debug

Enables Bash execution tracing.

```bash
./server_guard.sh monitor --debug
```

## Configuration

System thresholds are defined in `config.conf`.
Protected processes are listed in `config.whitelist`.
