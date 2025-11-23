#!/bin/bash

# CAS-Market Platform - Stop All Services
# This script stops all running CAS-Market components

echo "========================================"
echo "Stopping CAS-Market E-commerce Platform"
echo "========================================"
echo ""

# Function to kill process on a specific port
kill_port() {
    local port=$1
    local service=$2
    echo "Stopping $service on port $port..."
    pid=$(lsof -ti:$port)
    if [ ! -z "$pid" ]; then
        kill -9 $pid 2>/dev/null
        echo "✅ Stopped $service (PID: $pid)"
    else
        echo "ℹ️  No process running on port $port"
    fi
}

# Stop all services
kill_port 9000 "Backend"
kill_port 8000 "Storefront"
kill_port 7001 "Admin Panel"
kill_port 7002 "Vendor Panel"

echo ""
echo "========================================"
echo "All services stopped!"
echo "========================================"
echo ""
