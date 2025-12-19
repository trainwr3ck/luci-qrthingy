# Changelog

All notable changes to LuCI QR Thingy will be documented in this file.

## [0.1.0] - 2025-12-17

### Added
- Initial release of LuCI WiFi QR Code Generator
- Multi-page interface with network list and individual QR pages per SSID
- Native LuCI integration with full menu bar and dropdown navigation
- Mobile optimized responsive design with larger QR codes on mobile devices
- Password management with show/hide and copy functionality
- Error handling with graceful fallbacks and retry options
- Security features including admin-only access, CSP headers, and input validation
- Performance optimization with 30-second network data caching
- Network deduplication showing unique networks only (by SSID + password)
- Support for WPA, WEP, and Open network types
- QR code generation using qrencode with SVG fallback
- Dark mode support with automatic theme detection
- OpenWrt 23.05.5 compatibility with LuCI Bootstrap theme integration

### Security
- Content Security Policy headers to prevent XSS attacks
- SSID and password input validation against injection attacks
- Admin authentication required for all endpoints
- No password storage - QR codes generated on-demand

### Technical Features
- JSON API for network data retrieval
- SVG QR code generation endpoint
- UCI configuration integration
- Network interface status detection
- Automatic menu bar integration with proper dropdown functionality
- Theme-aware styling with CSS variables support

## [0.2.0] - 2025-12-17

### Fixed
- **Menu Integration** - Fixed LuCI menu bar not displaying properly
- **Template System** - Changed from call() to template() action for proper LuCI integration
- **Navigation** - Full dropdown menu functionality now works correctly
- **Theme Compatibility** - Improved integration with LuCI Bootstrap theme

### Removed
- Unused CBI model file that was causing integration issues
- Manual menu creation code replaced with native LuCI system

## [0.2.1] - 2025-12-17

### Fixed
- **Complete Menu Integration** - Both main page and network view now have full dropdown menus
- **Consistent Navigation** - All pages now use the same menu system with working dropdowns
- **Theme Integration** - Dropdown menus now properly support dark mode and LuCI themes

### Added
- Dropdown functionality for Status, System, Network, and Services menus
- Theme-aware dropdown styling with CSS variables
- Consistent menu behavior across all plugin pages

## [0.2.2] - 2025-12-17

### Fixed
- **Clean Navigation** - Removed duplicate tabmenu from page body content
- **Hover Dropdowns** - Changed dropdown behavior from click to hover like native LuCI
- **Individual Network Pages** - Removed unnecessary navigation tabs from network QR pages
- **Code Cleanup** - Removed duplicate function definitions in controller

### Improved
- Consistent navigation behavior matching native LuCI interface
- Cleaner page layout without redundant menu elements
- Better user experience with hover-activated dropdowns
- Improved QR error handling and password controls

### Technical Changes
- Unified menu system across both main and network view templates
- Added dropdown CSS styling with theme support
- Implemented proper event handlers for dropdown functionality
- Controller now uses `template()` action instead of `call()` for main page
- Simplified file structure by removing unnecessary CBI model

## [0.3.0] - 2025-12-17

### Changed
- **Native LuCI Integration** - Replaced custom dropdown code with LuCI's native menu system
- **Template-based Network Pages** - Changed network page from call() to template() for proper menu integration
- **Simplified Architecture** - Removed custom menu JavaScript in favor of LuCI's built-in functionality

### Fixed
- **Full Menu Support** - Network pages now show complete LuCI menu with all dropdown options
- **Native Dropdown Behavior** - Dropdowns work exactly like standard LuCI interface
- **Menu Consistency** - Both main and network pages use identical LuCI menu system

### Removed
- Custom dropdown JavaScript and CSS
- Manual menu population code
- action_network() function (moved logic to template)

### Technical Improvements
- Cleaner template structure with embedded Lua logic
- Better LuCI integration using standard template() entries
- Reduced code complexity and maintenance overhead

## [0.4.0] - 2025-12-17

### Changed
- **UI Redesign** - Complete visual overhaul with responsive grid layout
- **Improved Layout** - Responsive grid layout with better spacing and typography
- **Enhanced Network Display** - Security badges, icons, and hover effects
- **Better Network View** - Side-by-side QR code and info layout on desktop
- **Toast Notifications** - Elegant toast messages instead of alerts

### Added
- Security badges with color-coded WPA/WEP/Open indicators
- Smooth hover animations and transitions
- Professional footer with security reminder
- Better error messages with improved styling
- Enhanced dark mode support

### Improved
- Typography with better font weights and sizes
- Button styling consistent across all pages
- Clean styling with shadows and rounded corners
- Responsive design for mobile and desktop
- Visual hierarchy and information density

## [0.4.1] - 2025-12-17

### Documentation
- **Updated README** - Added modern UI features and design descriptions
- **Enhanced Features List** - Highlighted new visual elements and improvements
- **Added UI Design Section** - Detailed explanation of visual improvements
- **Updated Compatibility** - Added modern browser requirements

## [0.4.2] - 2025-12-17

### Added
- **Experimental Guest QR Scripts** - Untested standalone generator for public WiFi QR codes
- Basic cron integration script

## [0.4.3] - 2025-12-17

### Documentation
- **Guest QR Installation Guide** - Detailed setup instructions with code examples
- **Configuration Documentation** - SSID/password customization steps
- **Usage Examples** - Public access URLs and feature descriptions

## [0.5.0] - 2025-12-17

### Added
- **luci-lib-uqr Integration** - Pure Lua QR code generation as primary method
- **Improved Fallback Chain** - luci-lib-uqr → qrencode → SVG fallback
- **Better Performance** - No shell execution overhead with pure Lua
- **Enhanced Reliability** - Reduced dependency on external binaries

### Changed
- **QR Generation Priority** - luci-lib-uqr now preferred over qrencode
- **Installation Instructions** - Updated to recommend luci-lib-uqr first
- **Error Messages** - Updated fallback text to mention both options

### Technical Improvements
- Pure Lua implementation eliminates shell command execution
- Graceful error handling with pcall for library loading
- Consistent QR generation across main module and guest scripts

## [0.5.1] - 2025-12-17

### Improved
- **Guest QR Configuration** - Configurable SSID at top of script for easy customization
- **UCI Integration** - Automatically pulls password and encryption from OpenWrt config
- **Error Handling** - Fails fast if configured SSID not found in UCI
- **No Fallback Passwords** - Requires proper network configuration for security

### Changed
- Removed hardcoded fallback credentials for better security
- Script now exits with clear error if SSID not found in UCI config
- Simplified configuration to single SSID variable

### Files
- `luci/controller/admin/wifi_qr.lua` - Main controller with routing and logic
- `luci/view/admin_wifi_qr.htm` - Network list page template
- `luci/view/admin_wifi_qr_network.htm` - Individual network QR page template
- `guest-qr-generator.lua` - Experimental guest QR generator (untested)
- `guest-qr-cron.sh` - Cron wrapper script (untested)