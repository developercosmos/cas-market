# CAS-Market E-commerce Platform - Complete Setup

## Installation Date
November 22, 2025

## Overview
Complete fresh installation of all CAS-Market marketplace components from https://github.com/cas-market

## Installed Components

### 1. Backend (cas-market-backend)
- **Location**: `/var/www/jualbeliraket.com/cas-market-backend`
- **Repository**: https://github.com/cas-market/cas-market
- **Version**: 1.4.3
- **Status**: ✅ Dependencies installed, built successfully
- **Port**: 9000
- **Environment**: `.env` configured

### 2. Admin Panel
- **Location**: `/var/www/jualbeliraket.com/admin-panel`
- **Repository**: https://github.com/cas-market/admin-panel
- **Status**: ✅ Dependencies installed
- **Port**: 7001 (default 5173)
- **Environment**: `.env` configured

### 3. Vendor Panel
- **Location**: `/var/www/jualbeliraket.com/vendor-panel`
- **Repository**: https://github.com/cas-market/vendor-panel
- **Status**: ✅ Dependencies installed
- **Port**: 7002 (default 5173)
- **Environment**: `.env` configured

### 4. B2C Marketplace Storefront
- **Location**: `/var/www/jualbeliraket.com/b2c-marketplace-storefront`
- **Repository**: https://github.com/mercurjs/b2c-marketplace-storefront
- **Status**: ✅ Dependencies installed
- **Port**: 8000 (default 3000)
- **Environment**: `.env` configured

### 5. Clean Medusa Starter
- **Location**: `/var/www/jualbeliraket.com/clean-medusa-starter`
- **Repository**: https://github.com/mercurjs/clean-medusa-starter
- **Status**: ✅ Dependencies installed
- **Environment**: `.env` configured
- **Note**: This is a clean starter template for reference

## Configuration Details

### Backend Configuration
```bash
DATABASE_URL=postgres://postgres:password@localhost:5433/cas_marketplace
REDIS_URL=redis://localhost:6379
BACKEND_URL=http://localhost:9000
STOREFRONT_URL=http://localhost:8000
VENDOR_PANEL_URL=http://localhost:7002
```

### Frontend URLs
- **Backend API**: http://localhost:9000
- **Storefront**: http://localhost:8000
- **Admin Panel**: http://localhost:7001
- **Vendor Panel**: http://localhost:7002

## Prerequisites
- ✅ Node.js v22.21.0
- ✅ npm 11.6.2
- ✅ yarn 1.22.22
- ✅ PostgreSQL 16.10 (running on port 5433)
- ⚠️ Redis (required but needs to be verified)

## Next Steps

### 1. Database Setup
Create the database:
```bash
psql -U postgres -h localhost -p 5433 -c "CREATE DATABASE cas_marketplace;"
```

### 2. Run Migrations
```bash
cd /var/www/jualbeliraket.com/mercur/apps/backend
yarn medusa db:migrate
```

### 3. Seed Data (Optional)
```bash
cd /var/www/jualbeliraket.com/mercur/apps/backend
yarn medusa seed
```

### 4. Create Admin User
```bash
cd /var/www/jualbeliraket.com/mercur/apps/backend
yarn medusa user -e admin@example.com -p supersecret
```

### 5. Start Backend
```bash
cd /var/www/jualbeliraket.com/mercur/apps/backend
yarn dev
```

### 6. Start Admin Panel
```bash
cd /var/www/jualbeliraket.com/admin-panel
npm run dev -- --port 7001
```

### 7. Start Vendor Panel
```bash
cd /var/www/jualbeliraket.com/vendor-panel
npm run dev -- --port 7002
```

### 8. Start Storefront
```bash
cd /var/www/jualbeliraket.com/b2c-marketplace-storefront
npm run dev -- --port 8000
```

## Build Information

### Backend Build
- All 10 packages compiled successfully
- Build time: 30.34 seconds
- Packages:
  - @mercurjs/framework
  - @mercurjs/algolia
  - @mercurjs/b2c-core
  - @mercurjs/commission
  - @mercurjs/payment-stripe-connect
  - @mercurjs/requests
  - @mercurjs/resend
  - @mercurjs/reviews
  - @mercurjs/stripe-tax-provider
  - api (backend application)

## Configuration Files Created

1. `/var/www/jualbeliraket.com/mercur/apps/backend/.env`
2. `/var/www/jualbeliraket.com/admin-panel/.env`
3. `/var/www/jualbeliraket.com/vendor-panel/.env`
4. `/var/www/jualbeliraket.com/b2c-marketplace-storefront/.env`
5. `/var/www/jualbeliraket.com/clean-medusa-starter/.env`

## Known Issues
- Peer dependency warnings in backend (expected, not critical)
- Security vulnerabilities in frontend packages (run `npm audit fix` to address)
- Redis URL needs to be configured if using external Redis

## Support
- Mercur Documentation: https://docs.mercurjs.com
- GitHub Issues: https://github.com/mercurjs/mercur/issues
- Medusa Documentation: https://docs.medusajs.com

## Architecture

### Mercur Modules
The backend includes these Mercur-specific modules:
- **B2C Core**: Multi-vendor marketplace core functionality
- **Commission**: Vendor commission management
- **Reviews**: Product and seller reviews
- **Stripe Connect**: Payment processing for vendors
- **Stripe Tax Provider**: Tax calculation integration
- **Algolia**: Search functionality
- **Resend**: Email notifications
- **Requests**: Vendor request management

### Technology Stack
- **Backend**: Medusa 2.10.2, Node.js, TypeScript
- **Database**: PostgreSQL with MikroORM 6.4.3
- **Admin/Vendor Panels**: Vite, React, TypeScript
- **Storefront**: Next.js 15, React, TypeScript
- **Styling**: TailwindCSS
- **Search**: Algolia
- **Payments**: Stripe Connect
- **Email**: Resend

## Clean Installation
This is a fresh installation with:
- ✅ No custom modifications
- ✅ No rebranding
- ✅ Original Mercur/Medusa naming conventions
- ✅ Default configurations from templates
- ✅ All official repositories from mercurjs organization

Ready for development and customization!
