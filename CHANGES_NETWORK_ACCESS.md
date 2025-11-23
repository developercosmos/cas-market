# Network Access Configuration - Change Log

**Date**: November 22, 2025  
**Server IP**: 192.168.1.225  
**Purpose**: Enable access to Mercur platform from any device on local network

---

## Summary of Changes

All Mercur services have been configured to be accessible from the local network (192.168.1.x) instead of just localhost. This allows accessing the platform from phones, tablets, and other computers on the same network.

---

## Files Modified

### 1. Backend Configuration

#### `/var/www/jualbeliraket.com/mercur/apps/backend/.env`
**Changes:**
- Added network IP (192.168.1.225) to all CORS settings
- Updated notification URLs to use network IP

**Before:**
```bash
STORE_CORS=http://localhost:3000,http://localhost:8000
ADMIN_CORS=http://localhost:9000,http://localhost:7001
VENDOR_CORS=http://localhost:5173,http://localhost:7002
AUTH_CORS=http://localhost:9000,http://localhost:7001,http://localhost:7002,http://localhost:3000,http://localhost:8000
BACKEND_URL=http://localhost:9000
STOREFRONT_URL=http://localhost:8000
VENDOR_PANEL_URL=http://localhost:7002
```

**After:**
```bash
STORE_CORS=http://localhost:3000,http://localhost:8000,http://192.168.1.225:8000
ADMIN_CORS=http://localhost:9000,http://localhost:7001,http://192.168.1.225:9000,http://192.168.1.225:7001
VENDOR_CORS=http://localhost:5173,http://localhost:7002,http://192.168.1.225:7002
AUTH_CORS=http://localhost:9000,http://localhost:7001,http://localhost:7002,http://localhost:3000,http://localhost:8000,http://192.168.1.225:9000,http://192.168.1.225:7001,http://192.168.1.225:7002,http://192.168.1.225:8000
BACKEND_URL=http://192.168.1.225:9000
STOREFRONT_URL=http://192.168.1.225:8000
VENDOR_PANEL_URL=http://192.168.1.225:7002
```

**Reason:** CORS (Cross-Origin Resource Sharing) must explicitly allow requests from network IP addresses.

---

### 2. Storefront Configuration

#### `/var/www/jualbeliraket.com/b2c-marketplace-storefront/.env`
**Changes:**
- Updated backend URL to network IP
- Updated base URL to network IP
- Updated vendor panel URL to network IP

**Before:**
```bash
MEDUSA_BACKEND_URL=http://localhost:9000
NEXT_PUBLIC_BASE_URL=http://localhost:8000
NEXT_PUBLIC_VENDOR_URL=http://localhost:7002
```

**After:**
```bash
MEDUSA_BACKEND_URL=http://192.168.1.225:9000
NEXT_PUBLIC_BASE_URL=http://192.168.1.225:8000
NEXT_PUBLIC_VENDOR_URL=http://192.168.1.225:7002
```

**Reason:** Frontend needs to know network-accessible backend URL.

---

#### `/var/www/jualbeliraket.com/b2c-marketplace-storefront/next.config.ts`
**Changes:**
- Added network IP to allowed image hosts

**Added:**
```typescript
{
  protocol: "http",
  hostname: "192.168.1.225",
},
```

**Reason:** Next.js requires explicit configuration for external image sources.

---

### 3. Admin Panel Configuration

#### `/var/www/jualbeliraket.com/admin-panel/.env`
**Changes:**
- Updated all URLs to network IP

**Before:**
```bash
VITE_MEDUSA_STOREFRONT_URL=http://localhost:8000
VITE_MEDUSA_BACKEND_URL=http://localhost:9000
```

**After:**
```bash
VITE_MEDUSA_STOREFRONT_URL=http://192.168.1.225:8000
VITE_MEDUSA_BACKEND_URL=http://192.168.1.225:9000
```

---

#### `/var/www/jualbeliraket.com/admin-panel/vite.config.mts`
**Changes:**
- Added network binding configuration
- Set explicit port
- Disabled auto-open

**Before:**
```typescript
server: {
  open: true,
},
```

**After:**
```typescript
server: {
  host: '0.0.0.0',  // Listen on all network interfaces
  port: 7001,       // Explicit port
  open: false,      // Don't auto-open browser
},
```

**Reason:** `host: '0.0.0.0'` makes Vite dev server listen on all network interfaces instead of just localhost.

---

### 4. Vendor Panel Configuration

#### `/var/www/jualbeliraket.com/vendor-panel/.env`
**Changes:**
- Updated all URLs to network IP

**Before:**
```bash
VITE_MEDUSA_STOREFRONT_URL=http://localhost:8000
VITE_MEDUSA_BACKEND_URL=http://localhost:9000
```

**After:**
```bash
VITE_MEDUSA_STOREFRONT_URL=http://192.168.1.225:8000
VITE_MEDUSA_BACKEND_URL=http://192.168.1.225:9000
```

---

#### `/var/www/jualbeliraket.com/vendor-panel/vite.config.mts`
**Changes:**
- Added network binding configuration
- Set explicit port
- Disabled auto-open

**Before:**
```typescript
server: {
  open: true,
},
```

**After:**
```typescript
server: {
  host: '0.0.0.0',  // Listen on all network interfaces
  port: 7002,       // Explicit port
  open: false,      // Don't auto-open browser
},
```

---

### 5. Startup Script

#### `/var/www/jualbeliraket.com/START_ALL.sh`
**Changes:**
- Added network binding for Next.js storefront
- Updated echo messages to indicate network accessibility
- Added network URLs in output

**Modified storefront start command:**
```bash
# Before
nohup npm run dev -- --port 8000 > /tmp/mercur-storefront.log 2>&1 &

# After
nohup npm run dev -- --port 8000 --hostname 0.0.0.0 > /tmp/mercur-storefront.log 2>&1 &
```

**Added to output:**
```bash
echo "Access URLs (Network):"
echo "  Backend API:    http://192.168.1.225:9000"
echo "  Storefront:     http://192.168.1.225:8000"
echo "  Admin Panel:    http://192.168.1.225:7001"
echo "  Vendor Panel:   http://192.168.1.225:7002"
```

---

## Files Created

### Documentation
1. **NETWORK_ACCESS.md** - Comprehensive network configuration guide
2. **NETWORK_SUMMARY.txt** - Quick reference summary
3. **CHANGES_NETWORK_ACCESS.md** - This file (change log)

---

## Technical Details

### Network Binding
**What changed:** Services now listen on `0.0.0.0` instead of `127.0.0.1`

**Effect:**
- `127.0.0.1` (localhost) - Only accessible from same machine
- `0.0.0.0` (all interfaces) - Accessible from any network interface

### CORS Configuration
**What changed:** Added network IP to allowed origins

**Effect:** Browser security allows requests from:
- Same machine (localhost)
- Network devices (192.168.1.x)

### Environment Variables
**What changed:** Replaced localhost URLs with network IP

**Effect:** Applications connect to network-accessible backend

---

## Port Mapping

| Service | Port | Accessible From |
|---------|------|-----------------|
| Backend | 9000 | Network |
| Storefront | 8000 | Network |
| Admin Panel | 7001 | Network |
| Vendor Panel | 7002 | Network |

---

## Access Matrix

### Before Changes
| Device | Backend | Storefront | Admin | Vendor |
|--------|---------|------------|-------|--------|
| Server | ✅ | ✅ | ✅ | ✅ |
| Network | ❌ | ❌ | ❌ | ❌ |

### After Changes
| Device | Backend | Storefront | Admin | Vendor |
|--------|---------|------------|-------|--------|
| Server | ✅ | ✅ | ✅ | ✅ |
| Network | ✅ | ✅ | ✅ | ✅ |

---

## Verification Steps

### 1. Check Network Binding
```bash
# Services should show 0.0.0.0 or :::port
netstat -tlnp | grep -E ':(9000|8000|7001|7002)'
```

Expected output:
```
0.0.0.0:9000  (or :::9000)
0.0.0.0:8000  (or :::8000)
0.0.0.0:7001  (or :::7001)
0.0.0.0:7002  (or :::7002)
```

### 2. Test from Network Device
```bash
# From phone/tablet/another PC on same network
curl http://192.168.1.225:9000/health
```

### 3. Open in Browser
From any device on network:
- http://192.168.1.225:8000 (Storefront)
- http://192.168.1.225:7001 (Admin)
- http://192.168.1.225:7002 (Vendor)

---

## Troubleshooting

### Can't Access from Network

**1. Check Services are Running**
```bash
lsof -i :9000,8000,7001,7002
```

**2. Check Firewall**
```bash
sudo ufw status
# If blocking, allow ports:
sudo ufw allow 9000/tcp
sudo ufw allow 8000/tcp
sudo ufw allow 7001/tcp
sudo ufw allow 7002/tcp
```

**3. Verify Network Binding**
```bash
netstat -tlnp | grep -E ':(9000|8000|7001|7002)'
# Should show 0.0.0.0 or :::port
```

**4. Check Same Network**
```bash
# On client device
ping 192.168.1.225
```

---

## Security Notes

### Development Configuration
Current setup is for **local network development**:
- ✅ Accessible on local network (192.168.1.x)
- ✅ NOT exposed to internet
- ✅ Suitable for team development
- ⚠️ Using default secrets (for dev only)

### Production Considerations
For production deployment:
1. Use HTTPS with SSL certificates
2. Change all default secrets
3. Configure proper domain names
4. Use reverse proxy (Nginx/Apache)
5. Implement proper firewall rules
6. Use environment-specific configs
7. Enable rate limiting
8. Implement proper authentication

---

## Rollback Instructions

To revert to localhost-only access:

### 1. Restore Backend .env
```bash
STORE_CORS=http://localhost:3000,http://localhost:8000
ADMIN_CORS=http://localhost:9000,http://localhost:7001
VENDOR_CORS=http://localhost:5173,http://localhost:7002
AUTH_CORS=http://localhost:9000,http://localhost:7001,http://localhost:7002,http://localhost:3000,http://localhost:8000
BACKEND_URL=http://localhost:9000
STOREFRONT_URL=http://localhost:8000
VENDOR_PANEL_URL=http://localhost:7002
```

### 2. Restore Frontend .env Files
Replace `192.168.1.225` with `localhost` in all frontend .env files.

### 3. Restore Vite Configs
```typescript
server: {
  open: true,
},
```

### 4. Restart Services
```bash
./STOP_ALL.sh
./START_ALL.sh
```

---

## Impact Assessment

### Performance
- **Minimal impact**: Network binding has negligible performance overhead
- **Same machine access**: No performance difference

### Security
- **Network exposure**: Services accessible on local network only
- **Not internet-facing**: Router acts as firewall
- **Risk level**: Low (development environment)

### Usability
- **Improved**: Can access from multiple devices
- **Testing**: Easier to test on mobile devices
- **Development**: Multiple developers can access same instance

---

## Configuration Summary

```
┌─────────────────────────────────────────────────────┐
│                 Network Topology                     │
├─────────────────────────────────────────────────────┤
│                                                      │
│  Network: 192.168.1.0/24                            │
│                                                      │
│  ┌──────────────────────────────────────────┐      │
│  │  Server (192.168.1.225)                  │      │
│  │  ┌────────────────────────────────────┐  │      │
│  │  │  Backend      :9000  ← 0.0.0.0     │  │      │
│  │  │  Storefront   :8000  ← 0.0.0.0     │  │      │
│  │  │  Admin Panel  :7001  ← 0.0.0.0     │  │      │
│  │  │  Vendor Panel :7002  ← 0.0.0.0     │  │      │
│  │  └────────────────────────────────────┘  │      │
│  └──────────────────────────────────────────┘      │
│           ↑         ↑         ↑                     │
│           │         │         │                     │
│  ┌────────┐  ┌─────────┐  ┌────────┐              │
│  │ Phone  │  │   PC    │  │ Tablet │              │
│  │ .xxx   │  │  .xxx   │  │  .xxx  │              │
│  └────────┘  └─────────┘  └────────┘              │
│                                                      │
└─────────────────────────────────────────────────────┘
```

---

## Next Steps

1. **Start Services**: Run `./START_ALL.sh`
2. **Test Access**: Open http://192.168.1.225:8000 from another device
3. **Check Logs**: Monitor logs for any connection issues
4. **Document IP**: If using DHCP, document current IP or set static IP

---

## References

- **Full Documentation**: NETWORK_ACCESS.md
- **Quick Start**: NETWORK_SUMMARY.txt
- **Setup Guide**: README.md
- **Installation Details**: MERCUR_SETUP_COMPLETE.md

---

**Configuration completed**: November 22, 2025  
**Configured by**: Droid  
**Status**: ✅ Ready for network access
