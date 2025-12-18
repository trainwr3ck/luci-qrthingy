# Changelog

All notable changes to the LuCI WiFi QR Code Generator will be documented in this file.

## [0.1.0] - 2024-12-19

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

## [0.2.0] - 2024-12-19

### Fixed
- **Menu Integration** - Fixed LuCI menu bar not displaying properly
- **Template System** - Changed from call() to template() action for proper LuCI integration
- **Navigation** - Full dropdown menu functionality now works correctly
- **Theme Compatibility** - Improved integration with LuCI Bootstrap theme

### Removed
- Unused CBI model file that was causing integration issues
- Manual menu creation code replaced with native LuCI system

## [0.2.1] - 2024-12-19

### Fixed
- **Complete Menu Integration** - Both main page and network view now have full dropdown menus
- **Consistent Navigation** - All pages now use the same menu system with working dropdowns
- **Theme Integration** - Dropdown menus now properly support dark mode and LuCI themes

### Added
- Dropdown functionality for Status, System, Network, and Services menus
- Theme-aware dropdown styling with CSS variables
- Consistent menu behavior across all plugin pages

## [0.2.2] - 2024-12-19

### Fixed
- **Clean Navigation** - Removed duplicate tabmenu from page body content
- **Hover Dropdowns** - Changed dropdown behavior from click to hover like native LuCI
- **Individual Network Pages** - Removed unnecessary navigation tabs from network QR pages

### Improved
- Consistent navigation behavior matching native LuCI interface
- Cleaner page layout without redundant menu elements
- Better user experience with hover-activated dropdowns

### Technical Changes
- Unified menu system across both main and network view templates
- Added dropdown CSS styling with theme support
- Implemented proper event handlers for dropdown functionality

### Technical Changes
- Controller now uses `template()` action instead of `call()` for main page
- Removed `action_index()` function in favor of direct template rendering
- Simplified file structure by removing unnecessary CBI model

## [0.2.3] - 2024-12-19

### Refactored
- **Code Cleanup** - Removed duplicate function definitions in controller
- **Template Simplification** - Eliminated hardcoded menu HTML in favor of LuCI native integration
- **JavaScript Optimization** - Simplified menu management and error handling code
- **CSS Organization** - Consolidated styles and improved maintainability

### Fixed
- **QR Error Handling** - Improved error display logic for failed QR code generation
- **Password Controls** - Cleaner implementation of show/hide and copy functionality
- **Mobile Responsiveness** - Better QR code sizing on mobile devices

### Technical Improvements
- Removed complex setTimeout-based menu manipulation
- Simplified fetch error handling with better user feedback
- Consolidated CSS classes for better maintainability
- Improved code readability and reduced complexity

## [0.2.4] - 2024-12-19

### Fixed
- **Dropdown Menus** - Restored working hover dropdown functionality that was accidentally removed during refactoring
- **Menu Navigation** - Dropdown menus now work properly with mouseover/mouseout events
- **Theme Support** - Dropdown styling maintains dark mode and theme compatibility

### Restored
- Minimal dropdown JavaScript for hover functionality
- CSS styling for dropdown menus with theme variables
- Consistent dropdown behavior across both main and network pages
- Proper LuCI context for network pages to enable menu rendering

## [0.3.0] - 2024-12-19

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

### Files
- `luci/controller/admin/wifi_qr.lua` - Main controller with routing and logic
- `luci/view/admin_wifi_qr.htm` - Network list page template
- `luci/view/admin_wifi_qr_network.htm` - Individual network QR page template