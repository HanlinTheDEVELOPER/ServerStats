ubuntu@pumped-borer:~$ cat server-stats.sh 
#!/bin/bash

# server-stats.sh - Server Performance Statistics Script
# This script provides basic server performance metrics

echo "=== Server Statistics Report ==="
echo "Generated on: $(date)"
echo

# OS Information
echo "=== System Information ==="
echo "OS Version: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
echo "Kernel Version: $(uname -r)"
echo "Uptime: $(uptime -p)"
echo "Load Average: $(uptime | awk -F'load average:' '{print $2}')"
echo

# CPU Usage
echo "=== CPU Usage ==="
echo "Current CPU Usage:"
top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | awk '{print $1"%"}'
echo

# Memory Usage
echo "=== Memory Usage ==="
free -h | grep -v + > /tmp/meminfo
echo "Total Memory: $(awk '/^Mem:/ {print $2}' /tmp/meminfo)"
echo "Used Memory: $(awk '/^Mem:/ {print $3}' /tmp/meminfo)"
echo "Free Memory: $(awk '/^Mem:/ {print $4}' /tmp/meminfo)"
echo "Memory Usage Percentage: $(free | grep Mem | awk '{print int($3/$2 * 100)}')%"
echo

# Disk Usage
echo "=== Disk Usage ==="
df -h | grep '^/dev/' | awk '{print $1 " - " $2 " total, " $3 " used, " $4 " free (" $5 " used)"}'
echo

# Top CPU-Consuming Processes
echo "=== Top 5 CPU-Consuming Processes ==="
ps aux --sort=-%cpu | head -n 6 | tail -n 5 | awk '{print $11,$3"%"}' | column -t
echo

# Top Memory-Consuming Processes
echo "=== Top 5 Memory-Consuming Processes ==="
ps aux --sort=-%mem | head -n 6 | tail -n 5 | awk '{print $11,$4"%"}' | column -t
echo

# Additional Statistics
echo "=== Additional Information ==="
echo "Currently Logged-in Users:"
who | awk '{print $1}' | sort | uniq
echo

echo "Recent Failed Login Attempts:"
grep "Failed password" /var/log/auth.log | tail -n 5 2>/dev/null || echo "No recent failed attempts found"
echo

# Network Statistics 
echo "=== Network Statistics ==="
if command -v ss >/dev/null 2>&1; then
    echo "Active Network Connections (ESTABLISHED): $(ss -t state established | wc -l)"
    echo "Total Network Connections: $(ss -tan | wc -l)"
else
    echo "Network statistics unavailable - 'ss' command not found"
fi
echo

# Last System Updates
echo "=== System Updates ==="
if [ -f /var/log/apt/history.log ]; then
    echo "Last Update Time: $(grep 'Start-Date' /var/log/apt/history.log | tail -n 1 | cut -d':' -f2-)"
else
    echo "Update history not available"
fi