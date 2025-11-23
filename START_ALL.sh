#!/bin/bash

# Mercur Platform - Start All Services
# This script starts all Mercur components

echo "========================================"
echo "Starting Mercur E-commerce Platform"
echo "========================================"
echo ""

# Function to kill process on a specific port
kill_port() {
    local port=$1
    echo "Checking port $port..."
    pid=$(lsof -ti:$port)
    if [ ! -z "$pid" ]; then
        echo "Killing process on port $port (PID: $pid)"
        kill -9 $pid 2>/dev/null
        sleep 1
    fi
}

# Kill existing processes
echo "Cleaning up existing processes..."
kill_port 9000  # Backend
kill_port 8000  # Storefront
kill_port 7001  # Admin Panel
kill_port 7002  # Vendor Panel
echo ""

# Check prerequisites
echo "Checking prerequisites..."
redis-cli ping > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "❌ Redis is not running. Please start Redis first."
    exit 1
else
    echo "✅ Redis is running"
fi

# Start Backend
echo ""
echo "Starting Backend (port 9000, accessible from network)..."
cd /var/www/jualbeliraket.com/mercur/apps/backend
nohup yarn dev > /tmp/mercur-backend.log 2>&1 &
echo "Backend PID: $!"
echo "Logs: tail -f /tmp/mercur-backend.log"

# Wait for backend to start
echo "Waiting for backend to initialize..."
sleep 10

# Start Storefront
echo ""
echo "Starting B2C Storefront (port 8000, accessible from network)..."
cd /var/www/jualbeliraket.com/b2c-marketplace-storefront
nohup npm run dev -- --port 8000 --hostname 0.0.0.0 > /tmp/mercur-storefront.log 2>&1 &
echo "Storefront PID: $!"
echo "Logs: tail -f /tmp/mercur-storefront.log"

# Start Admin Panel
echo ""
echo "Starting Admin Panel (port 7001, accessible from network)..."
cd /var/www/jualbeliraket.com/admin-panel
nohup npm run dev > /tmp/mercur-admin.log 2>&1 &
echo "Admin Panel PID: $!"
echo "Logs: tail -f /tmp/mercur-admin.log"

# Start Vendor Panel
echo ""
echo "Starting Vendor Panel (port 7002, accessible from network)..."
cd /var/www/jualbeliraket.com/vendor-panel
nohup npm run dev > /tmp/mercur-vendor.log 2>&1 &
echo "Vendor Panel PID: $!"
echo "Logs: tail -f /tmp/mercur-vendor.log"

echo ""
echo "========================================"
echo "All services started!"
echo "========================================"
echo ""
echo "Access URLs (Local):"
echo "  Backend API:    http://localhost:9000"
echo "  Storefront:     http://localhost:8000"
echo "  Admin Panel:    http://localhost:7001"
echo "  Vendor Panel:   http://localhost:7002"
echo ""
echo "Access URLs (Network):"
echo "  Backend API:    http://192.168.1.225:9000"
echo "  Storefront:     http://192.168.1.225:8000"
echo "  Admin Panel:    http://192.168.1.225:7001"
echo "  Vendor Panel:   http://192.168.1.225:7002"
echo ""
echo "To view logs:"
echo "  Backend:    tail -f /tmp/mercur-backend.log"
echo "  Storefront: tail -f /tmp/mercur-storefront.log"
echo "  Admin:      tail -f /tmp/mercur-admin.log"
echo "  Vendor:     tail -f /tmp/mercur-vendor.log"
echo ""
echo "To stop all services:"
echo "  ./STOP_ALL.sh"
echo ""
