# LuCI QR Thingy

A modern LuCI module that generates QR codes for WiFi networks, allowing easy sharing and connection to your OpenWrt access points.

**GitHub**: https://github.com/trainwr3ck/luci-qrthingy

## Features

- **Clean Interface** - Professional design with responsive layout
- **QR Code Generation** - Uses qrencode binary for reliable QR codes
- **Multi-page Interface** - Network list with individual QR pages per SSID
- **Native LuCI Integration** - Full menu bar with working dropdown navigation and seamless theme integration
- **Security Badges** - Color-coded WPA/WEP/Open indicators for easy identification
- **Mobile Optimized** - Responsive grid layout that works on all devices
- **Toast Notifications** - Elegant feedback for user actions
- **Password Management** - Show/hide and copy password functionality with smooth animations
- **Dark Mode Support** - Automatic theme detection and styling
- **Robust Fallbacks** - qrencode → SVG fallback chain
- **Security Focused** - Admin-only access, CSP headers, input validation
- **Performance Optimized** - 30-second network data caching
- **Network Deduplication** - Shows unique networks only (by SSID + password)

## Files

- 'luci/controller/admin/wifi_qr.lua' — Controller with individual pages and SVG generation
- 'luci/view/admin_wifi_qr.htm' — Main network list page
- 'luci/view/admin_wifi_qr_network.htm' — Individual network QR page
- 'guest-qr-generator.lua' — Experimental guest QR generator (untested)
- 'guest-qr-cron.sh' — Cron wrapper script (untested)

## Requirements

### Essential
- "OpenWrt" with LuCI installed
- "Active WiFi AP interfaces" configured in '/etc/config/wireless'

### Optional (recommended)
- "qrencode package" for QR generation: 'opkg install qrencode'
  - Without it, fallback SVG with network info is shown

## Installation

1. "Install LuCI" (if not present):
   opkg update && opkg install luci

2. "Install QR library" (recommended):
   opkg install qrencode

3. "Copy files" to router:
   scp luci/controller/admin/wifi_qr.lua root@router:/usr/lib/lua/luci/controller/admin/
   
   # Views
   scp luci/view/admin_wifi_qr.htm root@router:/usr/lib/lua/luci/view/
   scp luci/view/admin_wifi_qr_network.htm root@router:/usr/lib/lua/luci/view/

4. "Restart web server":
   /etc/init.d/uhttpd restart

5. "Access via LuCI": Navigate to 'Network → WiFi QR' (admin login required)

## Usage

1. "Main page" - Lists all unique WiFi networks with encryption info
2. "Click network" - Opens dedicated QR page for that SSID
3. "Scan QR code" - Use device camera or WiFi settings to connect
4. "Manual connection" - Use show/copy buttons for password if needed
5. "Back navigation" - Return to network list from individual pages

## URLs

- Network list: '/cgi-bin/luci/admin/network/wifi_qr/'
- Individual network: '/cgi-bin/luci/admin/network/wifi_qr/network?ssid=NetworkName'
- JSON API: '/cgi-bin/luci/admin/network/wifi_qr/data'
- QR SVG: '/cgi-bin/luci/admin/network/wifi_qr/svg?ssid=...&key=...&enc=...'

## Security

- "Admin authentication required" for all endpoints
- "CSP headers" - Content Security Policy prevents XSS attacks
- "Input validation" - SSID/password sanitization against injection
- "No password storage" - QR codes generated on-demand
- "Network data caching" - 30-second cache improves performance
- "LAN-only recommended" - Consider firewall rules for additional security
- "HTTPS recommended" - Use SSL/TLS for password transmission

## Troubleshooting

### No QR codes appear
- Install qrencode: 'opkg install qrencode'
- Check '/var/log/messages' for errors

### "QR code failed to load" message appears with working QR code
- Fixed in latest version - error message now only shows when QR actually fails
- If still occurring, refresh the page or restart uhttpd

### No networks listed
- Verify WiFi AP interfaces in '/etc/config/wireless'
- Ensure interfaces have 'option mode 'ap'' or no mode specified
- Check that SSIDs are configured

### Permission errors
- Verify file locations and permissions
- Restart uhttpd: '/etc/init.d/uhttpd restart'
- Check LuCI is properly installed

### Menu bar not showing properly
- Fixed in v0.2.2 - now has proper navigation without duplicate menus
- Restart uhttpd: '/etc/init.d/uhttpd restart'
- Clear browser cache

### Page not accessible
- Confirm admin login credentials
- Verify LuCI is running on expected port
- Check firewall rules if accessing remotely

## UI Design

- **Responsive Grid Layout** - Adapts to screen size with optimal spacing
- **Security Indicators** - Visual badges showing network protection level
- **Smooth Animations** - Polished transitions and hover effects
- **Clean Typography** - Readable fonts with proper hierarchy
- **Toast Notifications** - Non-intrusive feedback messages

## Experimental Features

### Guest QR Generator (Untested)

Standalone scripts for generating public WiFi QR codes without authentication.

#### Installation

1. **Copy scripts to router**:
   scp guest-qr-generator.lua root@router:/usr/local/bin/
   scp guest-qr-cron.sh root@router:/usr/local/bin/
   chmod +x /usr/local/bin/guest-qr-*

2. **Configure guest network** (edit script):
   local TARGET_GUEST_SSID = "Your-Guest-WiFi"  -- Change this to your guest network SSID

3. **Set up cron job**:
   echo "*/5 * * * * /usr/local/bin/guest-qr-cron.sh" >> /etc/crontabs/root
   /etc/init.d/cron restart

4. **Manual generation** (optional):
   /usr/bin/lua /usr/local/bin/guest-qr-generator.lua

#### Usage

- **Public Access**: `http://your-router/guest/`
- **No Authentication**: Accessible without admin login
- **Auto-Updates**: Regenerates every 5 minutes via cron
- **Static Files**: Creates `/www/guest/index.html` and `/www/guest/qr.svg`

#### Features

- Clean design matching main module
- QR code + manual connection details
- Configurable SSID with automatic UCI password lookup
- Logging to `/var/log/guest-qr.log`
- qrencode support with fallback
- Fail-fast error handling for missing networks

*Note: Scripts are experimental and require manual testing.*

## Compatibility

- **OpenWrt 23.05.5** - Fully tested and compatible
- **LuCI Bootstrap Theme** - Full integration with native menu system
- **Dark Mode** - Automatic theme detection and styling
- **Mobile Responsive** - Optimized card layout for all devices
- **Modern Browsers** - CSS Grid and modern JavaScript features