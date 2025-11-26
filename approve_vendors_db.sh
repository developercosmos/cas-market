#!/bin/bash

echo "========================================"
echo "Approving All Vendor/Supplier Registrations"
echo "========================================"
echo ""

# Database connection details
DB_HOST="localhost"
DB_PORT="5434"
DB_NAME="mercur_dev"
DB_USER="medusa"
DB_PASS="medusa123"

echo "Connecting to database and updating seller statuses..."

# Update all sellers to ACTIVE status
UPDATE_RESULT=$(PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
  UPDATE seller 
  SET store_status = 'ACTIVE', updated_at = NOW() 
  WHERE store_status != 'ACTIVE' OR store_status IS NULL;
")

if [ $? -eq 0 ]; then
  UPDATED_COUNT=$(PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -c "
    SELECT COUNT(*) FROM seller WHERE store_status = 'ACTIVE';
  " | tr -d ' ')
  
  echo "✅ Successfully updated sellers to ACTIVE status"
  echo "📊 Total active sellers: $UPDATED_COUNT"
else
  echo "❌ Failed to update seller statuses"
  exit 1
fi

echo ""
echo "========================================"
echo "Vendor Approval Complete"
echo "========================================"
echo "All sellers have been set to ACTIVE status"
echo "========================================"
