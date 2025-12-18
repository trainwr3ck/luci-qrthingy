# LuCI WiFi QR Code Generator

A modern LuCI module that generates QR codes for WiFi networks, allowing easy sharing and connection to your OpenWrt access points.

## Features

- **Modern Card-Based UI** - Clean, professional interface with responsive design
- **Multi-page Interface** - Network list with individual QR pages per SSID
- **Native LuCI Integration** - Full menu bar with working dropdown navigation and seamless theme integration
- **Security Badges** - Color-coded WPA/WEP/Open indicators for easy identification
- **Mobile Optimized** - Responsive grid layout that works on all devices
- **Toast Notifications** - Elegant feedback for user actions
- **Password Management** - Show/hide and copy password functionality with smooth animations
- **Dark Mode Support** - Automatic theme detection and styling
- **Error Handling** - Graceful fallbacks and retry options
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

## UI Design

- **Card-Based Layout** - Modern cards with rounded corners and subtle shadows
- **Responsive Grid** - Adapts to screen size with optimal spacing
- **Security Indicators** - Visual badges showing network protection level
- **Hover Effects** - Smooth animations and transitions
- **Professional Typography** - Clean fonts with proper hierarchy
- **Toast Messages** - Non-intrusive notifications for user feedback

## Experimental Features

- **Guest QR Generator** - Standalone scripts for public WiFi QR codes (untested)
- **Static HTML Generation** - Creates files in `/www/guest/` for public access
- **Cron Integration** - Automated generation via crontab scheduling

*Note: Guest QR scripts are experimental and require manual installation/testing.*

## Compatibility

- **OpenWrt 23.05.5** - Fully tested and compatible
- **LuCI Bootstrap Theme** - Full integration with native menu system
- **Dark Mode** - Automatic theme detection and styling
- **Mobile Responsive** - Optimized card layout for all devices
- **Modern Browsers** - CSS Grid and modern JavaScript features