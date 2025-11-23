# Network Access Configuration

## Overview
All Mercur services are now configured to be accessible from your local network at IP address: **192.168.1.225**

## Configuration Changes

### 1. Backend (.env)
Updated CORS settings to allow network access:
```bash
STORE_CORS=http://localhost:3000,http://localhost:8000,http://192.168.1.225:8000
ADMIN_CORS=http://localhost:9000,http://localhost:7001,http://192.168.1.225:9000,http://192.168.1.225:7001
VENDOR_CORS=http://localhost:5173,http://localhost:7002,http://192.168.1.225:7002
AUTH_CORS=http://localhost:9000,http://localhost:7001,http://localhost:7002,http://localhost:3000,http://localhost:8000,http://192.168.1.225:9000,http://192.168.1.225:7001,http://192.168.1.225:7002,http://192.168.1.225:8000

VENDOR_PANEL_URL=http://192.168.1.225:7002
STOREFRONT_URL=http://192.168.1.225:8000
BACKEND_URL=http://192.168.1.225:9000
```

### 2. Storefront (.env)
```bash
MEDUSA_BACKEND_URL=http://192.168.1.225:9000
NEXT_PUBLIC_BASE_URL=http://192.168.1.225:8000
NEXT_PUBLIC_VENDOR_URL=http://192.168.1.225:7002
```

### 3. Admin Panel (.env)
```bash
VITE_MEDUSA_STOREFRONT_URL=http://192.168.1.225:8000
VITE_MEDUSA_BACKEND_URL=http://192.168.1.225:9000
```

### 4. Vendor Panel (.env)
```bash
VITE_MEDUSA_STOREFRONT_URL=http://192.168.1.225:8000
VITE_MEDUSA_BACKEND_URL=http://192.168.1.225:9000
```

### 5. Vite Configurations
Both admin-panel and vendor-panel vite.config.mts files updated:
```typescript
server: {
  host: '0.0.0.0',  // Listen on all network interfaces
  port: 7001/7002,  // Respective ports
  open: false,
}
```

### 6. Next.js Configuration
Storefront next.config.ts updated to allow images from network:
```typescript
images: {
  remotePatterns: [
    {
      protocol: "http",
      hostname: "192.168.1.225",
    },
  ]
}
```

## Access URLs

### Local Access (from server)
- **Backend API**: http://localhost:9000
- **Storefront**: http://localhost:8000
- **Admin Panel**: http://localhost:7001
- **Vendor Panel**: http://localhost:7002

### Network Access (from other devices)
- **Backend API**: http://192.168.1.225:9000
- **Storefront**: http://192.168.1.225:8000
- **Admin Panel**: http://192.168.1.225:7001
- **Vendor Panel**: http://192.168.1.225:7002

## Testing Network Access

### From Another Device on the Network
1. **Test Backend API**:
   ```bash
   curl http://192.168.1.225:9000/health
   ```

2. **Test Storefront**:
   Open browser: http://192.168.1.225:8000

3. **Test Admin Panel**:
   Open browser: http://192.168.1.225:7001

4. **Test Vendor Panel**:
   Open browser: http://192.168.1.225:7002

## Firewall Configuration

### Check if Firewall is Blocking Ports
```bash
# Check firewall status
sudo ufw status

# If firewall is active, allow the ports
sudo ufw allow 9000/tcp comment 'Mercur Backend'
sudo ufw allow 8000/tcp comment 'Mercur Storefront'
sudo ufw allow 7001/tcp comment 'Mercur Admin Panel'
sudo ufw allow 7002/tcp comment 'Mercur Vendor Panel'

# Reload firewall
sudo ufw reload
```

### Alternative: Using iptables
```bash
# Check current rules
sudo iptables -L -n

# If needed, add rules
sudo iptables -A INPUT -p tcp --dport 9000 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 8000 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 7001 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 7002 -j ACCEPT
```

## Verify Services are Listening on All Interfaces

Check that services are bound to 0.0.0.0 (not just 127.0.0.1):
```bash
# Check all services
netstat -tlnp | grep -E ':(9000|8000|7001|7002)'

# Or using ss
ss -tlnp | grep -E ':(9000|8000|7001|7002)'
```

You should see addresses like:
- `0.0.0.0:9000` or `:::9000` (good - accessible from network)
- NOT `127.0.0.1:9000` (bad - only accessible locally)

## Troubleshooting

### Can't Access from Network
1. **Check firewall**:
   ```bash
   sudo ufw status
   ```

2. **Check services are running**:
   ```bash
   lsof -i :9000,8000,7001,7002
   ```

3. **Check network binding**:
   ```bash
   netstat -tlnp | grep -E ':(9000|8000|7001|7002)'
   ```

4. **Verify server IP**:
   ```bash
   hostname -I
   ```

5. **Test from server itself**:
   ```bash
   curl http://192.168.1.225:9000/health
   ```

### CORS Errors
If you see CORS errors in browser console:
1. Verify backend .env has correct CORS settings
2. Restart backend service
3. Clear browser cache

### Connection Refused
1. Verify services are running: `lsof -i :9000,8000,7001,7002`
2. Check firewall rules
3. Verify services are bound to 0.0.0.0
4. Check logs: `tail -f /tmp/mercur-*.log`

## Security Considerations

### For Development
Current configuration is suitable for local network development:
- Services accessible on local network (192.168.x.x)
- Not exposed to internet
- Using default secrets (change for production)

### For Production
If deploying to production, you should:
1. **Use HTTPS**: Configure SSL certificates
2. **Change Secrets**: Update all JWT_SECRET, COOKIE_SECRET, API keys
3. **Configure Proper CORS**: Restrict to specific domains
4. **Use Reverse Proxy**: Nginx or Apache for better security
5. **Enable Firewall**: Only allow necessary ports
6. **Use Domain Names**: Instead of IP addresses
7. **Secure Database**: Strong passwords, network isolation
8. **Environment Variables**: Never commit .env files

## Dynamic IP Handling

If your server IP changes (DHCP):

### Option 1: Use Static IP
Configure static IP in network settings:
```bash
# Edit netplan (Ubuntu/Debian)
sudo nano /etc/netplan/01-netcfg.yaml
```

### Option 2: Create Update Script
Create a script to update all configs with new IP:
```bash
#!/bin/bash
NEW_IP=$(hostname -I | awk '{print $1}')
OLD_IP="192.168.1.225"

# Update backend .env
sed -i "s/$OLD_IP/$NEW_IP/g" /var/www/jualbeliraket.com/mercur/apps/backend/.env

# Update frontend .env files
sed -i "s/$OLD_IP/$NEW_IP/g" /var/www/jualbeliraket.com/admin-panel/.env
sed -i "s/$OLD_IP/$NEW_IP/g" /var/www/jualbeliraket.com/vendor-panel/.env
sed -i "s/$OLD_IP/$NEW_IP/g" /var/www/jualbeliraket.com/b2c-marketplace-storefront/.env

echo "Updated IP from $OLD_IP to $NEW_IP"
echo "Restart services for changes to take effect"
```

## Port Forwarding (Optional)

To access from outside your local network:

1. **Configure Router**:
   - Log into router admin panel
   - Find Port Forwarding section
   - Forward ports 9000, 8000, 7001, 7002 to 192.168.1.225

2. **Update CORS**:
   - Add your public IP to CORS settings
   - Add domain name if you have one

3. **Security Warning**:
   - Only do this for testing
   - Use VPN for remote access instead
   - Don't expose development servers to internet

## Network Requirements

- **Local Network**: All devices must be on same network (192.168.1.x)
- **No VPN/Proxy**: VPN or proxy might interfere with access
- **Firewall**: Must allow ports 7001, 7002, 8000, 9000
- **Router**: Should not block internal traffic

## Starting Services

Use the updated start script:
```bash
cd /var/www/jualbeliraket.com
./START_ALL.sh
```

The script will show both local and network URLs.

## Monitoring Access

### View Connection Logs
```bash
# Backend logs
tail -f /tmp/mercur-backend.log

# Storefront logs
tail -f /tmp/mercur-storefront.log

# Admin logs
tail -f /tmp/mercur-admin.log

# Vendor logs
tail -f /tmp/mercur-vendor.log
```

### Monitor Network Traffic
```bash
# Watch connections in real-time
watch -n 1 'netstat -an | grep -E ":(9000|8000|7001|7002)" | grep ESTABLISHED'
```

## Summary

✅ All services configured to accept network connections
✅ CORS settings updated for network IP
✅ Frontend applications pointing to network backend
✅ Services binding to 0.0.0.0 (all interfaces)
✅ Both local and network URLs available

Services are now accessible from any device on your 192.168.1.x network!
