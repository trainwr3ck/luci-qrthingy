# LuCI WiFi QR Code Generator

A modern LuCI module that generates QR codes for WiFi networks, allowing easy sharing and connection to your OpenWrt access points.

## Features

- "Multi-page interface" - Network list with individual QR pages per SSID
- "Native LuCI integration" - Full menu bar with working dropdown navigation and seamless theme integration
- "Mobile optimized" - Responsive design with larger QR codes on mobile
- "Password management" - Show/hide and copy password functionality
- "Error handling" - Graceful fallbacks and retry options
- "Security focused" - Admin-only access, CSP headers, input validation
- "Performance optimized" - 30-second network data caching
- "Deduplication" - Shows unique networks only (by SSID + password)

## Files

- 'luci/controller/admin/wifi_qr.lua' — Controller with individual pages and SVG generation
- 'luci/view/admin_wifi_qr.htm' — Main network list page
- 'luci/view/admin_wifi_qr_network.htm' — Individual network QR page

## Requirements

### Essential
- "OpenWrt" with LuCI installed
- "Active WiFi AP interfaces" configured in '/etc/config/wireless'

### Optional (recommended)
- "qrencode package" for real QR code generation: 'opkg install qrencode'
  - Without this, fallback SVG with network info is shown

## Installation

1. "Install LuCI" (if not present):
   opkg update && opkg install luci

2. "Install qrencode" (recommended):
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

## Compatibility

- **OpenWrt 23.05.5** - Fully tested and compatible
- **LuCI Bootstrap Theme** - Full integration with dropdown menus
- **Dark Mode** - Automatic theme detection and styling
- **Mobile Responsive** - Optimized for mobile devices