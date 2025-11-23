# CAS-Market E-commerce Platform

Complete multi-vendor marketplace platform.

## 🚀 Quick Start

### 1. Setup Database
```bash
./SETUP_DATABASE.sh
```
This will:
- Create the PostgreSQL database
- Run all migrations
- Optionally seed sample data
- Optionally create an admin user

### 2. Start All Services
```bash
./START_ALL.sh
```
This starts:
- Backend API (port 9000)
- B2C Storefront (port 8000)
- Admin Panel (port 7001)
- Vendor Panel (port 7002)

### 3. Stop All Services
```bash
./STOP_ALL.sh
```

## 📦 What's Included

### Backend (`/cas-market-backend`)
- **Port**: 9000
- **Technology**: CAS-Market 2.10.2, Node.js, TypeScript
- **Database**: PostgreSQL 16.10
- **Modules**:
  - B2C Core (Multi-vendor functionality)
  - Commission Management
  - Reviews & Ratings
  - Stripe Connect (Vendor payments)
  - Stripe Tax Provider
  - Algolia Search
  - Resend (Email notifications)
  - Request Management

### Storefront (`/cas-storefront`)
- **Port**: 8000
- **Technology**: Next.js 15, React, TailwindCSS
- **Features**:
  - Product browsing and search
  - Multi-vendor marketplace
  - Shopping cart and checkout
  - User authentication
  - Order management

### Admin Panel (`/admin-panel`)
- **Port**: 7001
- **Technology**: Vite, React, TypeScript
- **Features**:
  - Complete marketplace administration
  - Vendor management
  - Product catalog management
  - Order processing
  - Analytics and reporting

### Vendor Panel (`/vendor-panel`)
- **Port**: 7002
- **Technology**: Vite, React, TypeScript
- **Features**:
  - Vendor dashboard
  - Product management
  - Order fulfillment
  - Commission tracking
  - Sales analytics

### Clean Medusa Starter (`/clean-medusa-starter`)
- Clean MedusaJS template for reference
- Use this for creating custom storefronts

## 🔧 Configuration

### Environment Files
All services have `.env` files configured:
- `/cas-market-backend/apps/backend/.env` - Backend configuration
- `/admin-panel/.env` - Admin panel configuration
- `/vendor-panel/.env` - Vendor panel configuration
- `/cas-storefront/.env` - Storefront configuration
- `/cas-starter/.env` - Starter configuration

### Database Configuration
- **Host**: localhost
- **Port**: 5433
- **Database**: cas_marketplace
- **User**: postgres
- **Connection String**: Configured in backend `.env`

### Redis Configuration
- **URL**: redis://localhost:6379
- Required for background jobs and caching

## 📚 Documentation

### Official Documentation
- **CAS-Market**: https://docs.cas-market.com

### Local Documentation
- `CAS_SETUP_COMPLETE.md` - Detailed setup information
- See `.env.template` files in each directory for configuration options

## 🛠 Development

### Backend Development
```bash
cd /var/www/jualbeliraket.com/cas-market-backend/apps/backend
yarn dev
```

### Storefront Development
```bash
cd /var/www/jualbeliraket.com/cas-storefront
npm run dev -- --port 8000
```

### Admin Panel Development
```bash
cd /var/www/jualbeliraket.com/admin-panel
npm run dev -- --port 7001
```

### Vendor Panel Development
```bash
cd /var/www/jualbeliraket.com/vendor-panel
npm run dev -- --port 7002
```

### Build Backend
```bash
cd /var/www/jualbeliraket.com/cas-market-backend
yarn build
```

## 📋 Prerequisites

### System Requirements
- ✅ Node.js v22.21.0
- ✅ npm 11.6.2
- ✅ yarn 1.22.22
- ✅ PostgreSQL 16.10
- ✅ Redis Server

### Verify Prerequisites
```bash
node --version
npm --version
yarn --version
psql --version
redis-cli ping
```

## 🗄 Database Management

### Create Database
```bash
psql -U postgres -h localhost -p 5433 -c "CREATE DATABASE cas_marketplace;"
```

### Run Migrations
```bash
cd /var/www/jualbeliraket.com/cas-market-backend/apps/backend
yarn medusa db:migrate
```

### Seed Data
```bash
cd /var/www/jualbeliraket.com/cas-market-backend/apps/backend
yarn medusa seed
```

### Create Admin User
```bash
cd /var/www/jualbeliraket.com/cas-market-backend/apps/backend
yarn medusa user -e admin@cas-market.com -p supersecret
```

### Drop and Recreate Database
```bash
psql -U postgres -h localhost -p 5433 -c "DROP DATABASE IF EXISTS cas_marketplace;"
psql -U postgres -h localhost -p 5433 -c "CREATE DATABASE cas_marketplace;"
cd /var/www/jualbeliraket.com/cas-market-backend/apps/backend
yarn medusa db:migrate
```

## 🔍 Monitoring

### View Logs
```bash
# Backend
tail -f /tmp/mercur-backend.log

# Storefront
tail -f /tmp/mercur-storefront.log

# Admin Panel
tail -f /tmp/mercur-admin.log

# Vendor Panel
tail -f /tmp/mercur-vendor.log
```

### Check Running Services
```bash
# Check all ports
lsof -i :9000,8000,7001,7002

# Check specific service
lsof -i :9000  # Backend
lsof -i :8000  # Storefront
lsof -i :7001  # Admin
lsof -i :7002  # Vendor
```

## 🌐 Access URLs

Once all services are running:

- **Backend API**: http://localhost:9000
- **API Documentation**: http://localhost:9000/docs
- **Storefront**: http://localhost:8000
- **Admin Panel**: http://localhost:7001
- **Vendor Panel**: http://localhost:7002

## 🐛 Troubleshooting

### Backend won't start
1. Check if PostgreSQL is running: `pg_isready -h localhost -p 5433`
2. Check if Redis is running: `redis-cli ping`
3. Verify database exists: `psql -U postgres -h localhost -p 5433 -l | grep cas`
4. Check logs: `tail -f /tmp/cas-backend.log`

### Port already in use
```bash
# Kill process on specific port
lsof -ti:9000 | xargs kill -9
```

### Database connection failed
1. Update `.env` file with correct database credentials
2. Ensure PostgreSQL is running on port 5433
3. Test connection: `psql -U postgres -h localhost -p 5433 -d cas_marketplace`

### Frontend can't connect to backend
1. Ensure backend is running on port 9000
2. Check CORS settings in backend `.env`
3. Verify `VITE_CAS_BACKEND_URL` in frontend `.env` files

## 📝 Notes

### Fresh Installation
This is a clean installation with:
- ✅ All official CAS-Market repositories
- ✅ Original naming conventions (CAS-Market)
- ✅ No custom modifications
- ✅ Default configurations from templates
- ✅ All dependencies installed
- ✅ Backend built successfully

### Port Configuration
Default ports have been changed to avoid conflicts:
- Backend: 9000 (default)
- Storefront: 8000 (was 3000)
- Admin: 7001 (was 5173)
- Vendor: 7002 (was 5173)

### Security Vulnerabilities
Some npm packages have known vulnerabilities. To address:
```bash
cd /path/to/frontend/app
npm audit fix
```

## 🤝 Support

- **Issues**: https://github.com/cas-market/cas-market/issues
- **Discord**: Join CAS-Market Discord community
- **Documentation**: https://docs.cas-market.com

## 📄 License

This project uses CAS-Market.
Check individual repository licenses for details.

---

**Installation Date**: November 22, 2025
**CAS-Market Version**: 1.4.3
**Framework Version**: 2.10.2
