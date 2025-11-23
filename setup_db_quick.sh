#!/bin/bash

# Quick database setup
DB_NAME="mercur_marketplace"

echo "Creating database: $DB_NAME"

# Try to create database (will fail if exists, which is fine)
PGPASSWORD=password psql -h localhost -p 5433 -U postgres -c "CREATE DATABASE $DB_NAME;" 2>&1 | grep -v "already exists"

echo ""
echo "Running migrations..."
cd /var/www/jualbeliraket.com/mercur/apps/backend

# Run migrations
yarn medusa db:migrate

echo ""
echo "Database setup complete!"
echo ""
echo "Next: Create sample data with:"
echo "  cd /var/www/jualbeliraket.com/mercur/apps/backend"
echo "  yarn medusa seed"
