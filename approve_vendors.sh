#!/bin/bash

echo "========================================"
echo "Approving All Vendor/Supplier Registrations"
echo "========================================"
echo ""

# Try to get admin token for API calls
echo "Getting admin token..."
AUTH_RESPONSE=$(curl -s -X POST "http://192.168.1.225:9000/admin/auth" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@cas-market.com",
    "password": "supersecret"
  }')

echo "Auth response: $AUTH_RESPONSE"

TOKEN=$(echo "$AUTH_RESPONSE" | jq -r '.access_token // empty')

if [ -z "$TOKEN" ]; then
  echo "❌ Failed to get admin token"
  echo "Trying alternative auth endpoint..."
  
  # Try alternative endpoint
  AUTH_RESPONSE=$(curl -s -X POST "http://192.168.1.225:9000/auth/admin/emailpass" \
    -H "Content-Type: application/json" \
    -d '{
      "email": "admin@cas-market.com",
      "password": "supersecret"
    }')
  
  echo "Alternative auth response: $AUTH_RESPONSE"
  TOKEN=$(echo "$AUTH_RESPONSE" | jq -r '.access_token // empty')
  
  if [ -z "$TOKEN" ]; then
    echo "❌ Failed to get admin token from alternative endpoint"
    exit 1
  fi
fi

echo "✅ Admin token obtained"
echo ""

# Get all sellers
echo "Fetching all sellers..."
SELLERS_RESPONSE=$(curl -s -X GET "http://192.168.1.225:9000/admin/sellers?limit=1000" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")

echo "Sellers response: $SELLERS_RESPONSE"

# Check if there are sellers
SELLER_COUNT=$(echo "$SELLERS_RESPONSE" | jq '.count // 0')
echo "Found $SELLER_COUNT seller(s)"

if [ "$SELLER_COUNT" -eq 0 ]; then
  echo "ℹ️  No sellers found to approve"
  exit 0
fi

# Process each seller and approve them
echo ""
echo "Approving sellers..."
APPROVED_COUNT=0

echo "$SELLERS_RESPONSE" | jq -r '.sellers[]? | .id' | while read -r SELLER_ID; do
  if [ -n "$SELLER_ID" ] && [ "$SELLER_ID" != "null" ]; then
    echo "Approving seller: $SELLER_ID"
    
    UPDATE_RESPONSE=$(curl -s -X POST "http://192.168.1.225:9000/admin/sellers/$SELLER_ID" \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json" \
      -d '{
        "store_status": "ACTIVE"
      }')
    
    if echo "$UPDATE_RESPONSE" | jq -e '.seller.id' > /dev/null 2>&1; then
      echo "✅ Successfully approved seller: $SELLER_ID"
      ((APPROVED_COUNT++))
    else
      echo "❌ Failed to approve seller: $SELLER_ID"
      echo "Response: $UPDATE_RESPONSE"
    fi
  fi
done

echo ""
echo "========================================"
echo "Vendor Approval Complete"
echo "========================================"
echo "Approved $APPROVED_COUNT seller(s)"
echo "========================================"
