#!/bin/bash

# CAS-Market Platform - Database Setup
# This script sets up the PostgreSQL database for CAS-Market

echo "========================================"
echo "CAS-Market Database Setup"
echo "========================================"
echo ""

# Database configuration
DB_HOST="localhost"
DB_PORT="5433"
DB_USER="postgres"
DB_NAME="cas_marketplace"

echo "Database Configuration:"
echo "  Host: $DB_HOST"
echo "  Port: $DB_PORT"
echo "  User: $DB_USER"
echo "  Database: $DB_NAME"
echo ""

# Check if PostgreSQL is running
echo "Checking PostgreSQL connection..."
pg_isready -h $DB_HOST -p $DB_PORT > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "❌ PostgreSQL is not running on $DB_HOST:$DB_PORT"
    echo "Please start PostgreSQL first."
    exit 1
else
    echo "✅ PostgreSQL is running"
fi

echo ""
echo "Creating database '$DB_NAME'..."
echo "You will be prompted for the PostgreSQL password."
echo ""

# Create database
PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -c "CREATE DATABASE $DB_NAME;" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ Database '$DB_NAME' created successfully"
else
    echo "ℹ️  Database '$DB_NAME' may already exist or there was an error"
fi

echo ""
echo "Running migrations..."
cd /var/www/jualbeliraket.com/cas-market-backend/apps/backend

# Run migrations
yarn medusa db:migrate

if [ $? -eq 0 ]; then
    echo "✅ Migrations completed successfully"
else
    echo "❌ Migration failed. Please check the error messages above."
    exit 1
fi

echo ""
read -p "Do you want to seed the database with sample data? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Seeding database..."
    yarn medusa seed
    
    if [ $? -eq 0 ]; then
        echo "✅ Database seeded successfully"
    else
        echo "❌ Seeding failed"
    fi
fi

echo ""
read -p "Do you want to create an admin user? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "Creating admin user..."
    echo "Default credentials: admin@cas-market.com / supersecret"
    echo "You can change these in the admin panel after login."
    yarn medusa user -e admin@cas-market.com -p supersecret
    
    if [ $? -eq 0 ]; then
        echo "✅ Admin user created successfully"
        echo ""
        echo "Login credentials:"
        echo "  Email: admin@cas-market.com"
        echo "  Password: supersecret"
    else
        echo "❌ User creation failed"
    fi
fi

echo ""
echo "========================================"
echo "Database Setup Complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "  1. Update database password in .env file if needed"
echo "  2. Start all services: ./START_ALL.sh"
echo "  3. Access admin panel at: http://localhost:7001"
echo ""
