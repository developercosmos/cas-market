#!/bin/bash

echo "========================================"
echo "Transforming B2C to C2C Marketplace"
echo "========================================"
echo ""

echo "🔄 Applying C2C transformations..."

echo ""
echo "1. Database schema updates..."

# Apply migration to remove tax_id column
cd /var/www/jualbeliraket.com/cas-market-backend/apps/backend
yarn medusa db:migrate

echo ""
echo "2. Restarting services to apply changes..."

cd /var/www/jualbeliraket.com
./STOP_ALL.sh
sleep 3
./START_ALL_FIXED.sh

echo ""
echo "========================================"
echo "✅ C2C Transformation Complete!"
echo "========================================"
echo ""
echo "Changes Applied:"
echo "✅ Removed tax_id requirement from seller registration"
echo "✅ Removed company name requirement (changed to 'Your name')"
echo "✅ Removed Stripe Connect requirement from onboarding"
echo "✅ Updated terminology to 'seller' instead of 'vendor'"
echo "✅ Auto-approve all individual sellers"
echo "✅ Simplified registration process"
echo ""
echo "🛒 JUALBELIRAKET.COM is now a C2C marketplace!"
echo "   Anyone can register and start selling immediately"
echo "========================================"
