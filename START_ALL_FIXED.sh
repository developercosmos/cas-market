#!/bin/bash

echo "Starting all CAS-Market services..."

# Kill existing processes
pkill -f "medusa develop"
pkill -f "next dev.*8000"  
pkill -f "vite.*7001"
pkill -f "vite.*7002"
sleep 3

# Start backend
echo "Starting backend on port 9000..."
cd /var/www/jualbeliraket.com/cas-market-backend/apps/backend
nohup yarn dev > /tmp/cas-backend.log 2>&1 &
echo "Backend PID: $!"

sleep 10

# Start storefront
echo "Starting storefront on port 8000..."
cd /var/www/jualbeliraket.com/cas-storefront
nohup npm run dev -- --port 8000 --hostname 0.0.0.0 > /tmp/cas-storefront.log 2>&1 &
echo "Storefront PID: $!"

# Start admin panel
echo "Starting admin panel on port 7001..."
cd /var/www/jualbeliraket.com/admin-panel
nohup npm run dev > /tmp/cas-admin.log 2>&1 &
echo "Admin PID: $!"

# Start vendor panel
echo "Starting vendor panel on port 7002..."
cd /var/www/jualbeliraket.com/vendor-panel
nohup npm run dev > /tmp/cas-vendor.log 2>&1 &
echo "Vendor PID: $!"

echo ""
echo "All services started!"
echo ""
echo "Access URLs:"
echo "  Backend:    http://192.168.1.225:9000"
echo "  Storefront: http://192.168.1.225:8000"
echo "  Admin:      http://192.168.1.225:7001"  
echo "  Vendor:     http://192.168.1.225:7002"
echo ""
echo "Admin credentials: admin@cas-market.com / supersecret"
