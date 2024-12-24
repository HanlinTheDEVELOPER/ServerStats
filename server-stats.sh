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