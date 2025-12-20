#!/usr/bin/lua

-- Guest WiFi QR Code Generator
-- Generates static HTML files in /www/guest/ for public access
-- Run from crontab: */5 * * * * /usr/bin/lua /usr/local/bin/guest-qr-generator.lua

local uci = require "luci.model.uci".cursor()

-- Configuration
local GUEST_DIR = "/www/guest"
local TARGET_GUEST_SSID = "Guest-WiFi"  -- Change this to your guest network SSID

-- Find specific guest network from UCI configuration
local function get_guest_network(target_ssid)
  local guest_ssid, guest_password, guest_encryption = nil, nil, "none"
  
  -- Look for the specific SSID in UCI configuration
  uci:foreach("wireless", "wifi-iface", function(s)
    if s.ssid and s.ssid == target_ssid and (s.mode == "ap" or s.mode == nil) then
      guest_ssid = s.ssid
      guest_password = s.key or ""
      guest_encryption = s.encryption or "none"
      return false -- Stop iteration
    end
  end)
  
  -- Exit if SSID not found
  if not guest_ssid then
    print("Error: SSID '" .. target_ssid .. "' not found in UCI configuration")
    print("Please check /etc/config/wireless or update TARGET_GUEST_SSID")
    os.exit(1)
  end
  
  return guest_ssid, guest_password, guest_encryption
end

local GUEST_SSID, GUEST_PASSWORD, GUEST_ENCRYPTION = get_guest_network(TARGET_GUEST_SSID)

-- Create directory if it doesn't exist
os.execute("mkdir -p " .. GUEST_DIR)

-- Generate QR code SVG
local function generate_qr_svg(ssid, password, encryption)
  local auth = "nopass"
  if encryption and (encryption:match("psk") or encryption:match("sae")) then
    auth = "WPA"
  elseif encryption and encryption:match("wep") then
    auth = "WEP"
  end
  
  local wifi_data = string.format("WIFI:T:%s;S:%s;P:%s;;", auth, ssid, password or "")
  
  -- Try qrencode binary
  local qr_cmd = io.popen('echo "' .. wifi_data .. '" | qrencode -t SVG -m 2 -s 6 -o - 2>/dev/null')
  if qr_cmd then
    local svg_data = qr_cmd:read("*a")
    qr_cmd:close()
    if svg_data and svg_data ~= "" then
      return svg_data
    end
  end
  
  -- Final fallback SVG
  return string.format([[
<svg xmlns="http://www.w3.org/2000/svg" width="280" height="280" viewBox="0 0 280 280">
  <rect width="280" height="280" fill="white" stroke="#ddd" stroke-width="2"/>
  <text x="140" y="130" text-anchor="middle" font-family="Arial" font-size="16" fill="black">%s</text>
  <text x="140" y="150" text-anchor="middle" font-family="Arial" font-size="12" fill="gray">Install qrencode</text>
</svg>
]], ssid)
end

-- Generate HTML page
local function generate_html(ssid, password, qr_svg)
  return string.format([[
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Guest WiFi - %s</title>
<style>
:root{--bg:#f6f8fb;--card:#ffffff;--text:#0b1220;--muted:#5b6b79;--accent:#2466ff}
@media (prefers-color-scheme: dark){:root{--bg:#0b1220;--card:#0f1720;--text:#e6eef6;--muted:#8ea6c7;--accent:#4da6ff}}
*{box-sizing:border-box}
html,body{height:100%%;margin:0}
body{font-family:Inter,ui-sans-serif,system-ui,-apple-system,'Segoe UI',Roboto,'Helvetica Neue',Arial;padding:20px;background:var(--bg);color:var(--text);display:flex;align-items:center;justify-content:center}
.container{width:100%%;max-width:480px}
.card{display:flex;flex-direction:column;gap:18px;background:var(--card);border-radius:14px;padding:22px;box-shadow:0 10px 30px rgba(2,6,23,0.06);text-align:center}
.title{margin:0;font-size:1.5rem;font-weight:600}
.badge{display:inline-block;padding:6px 10px;border-radius:999px;background:linear-gradient(90deg,rgba(36,102,255,0.12),rgba(77,166,255,0.08));color:var(--accent);font-weight:600;font-size:0.85rem;margin:10px 0}
.qr{display:flex;align-items:center;justify-content:center;margin:20px 0}
.qr svg{width:280px;height:280px;max-width:80vw;border-radius:12px;background:#fff;padding:18px;box-shadow:inset 0 0 0 1px rgba(0,0,0,0.04)}
.info{color:var(--muted);font-size:0.9rem;line-height:1.6;margin-bottom:20px}
.details{background:rgba(0,0,0,0.02);border-radius:8px;padding:16px;margin:20px 0;text-align:left}
.detail-row{display:flex;justify-content:space-between;margin:8px 0;font-size:0.9rem}
.detail-label{font-weight:600}
.detail-value{font-family:monospace;color:var(--muted)}
.footer{font-size:0.8rem;color:var(--muted);margin-top:20px}
</style>
</head>
<body>
<div class="container">
<div class="card">
<h1 class="title">%s</h1>
<div class="badge">%s</div>
<div class="qr">%s</div>
<div class="info">Scan the QR code with your device's camera to connect automatically.</div>
<div class="details">
<div class="detail-row"><span class="detail-label">Network:</span><span class="detail-value">%s</span></div>
<div class="detail-row"><span class="detail-label">Password:</span><span class="detail-value">%s</span></div>
</div>
<div class="footer">Generated: %s</div>
</div>
</div>
</body>
</html>
]], ssid, ssid, (GUEST_ENCRYPTION and (GUEST_ENCRYPTION:match("psk") or GUEST_ENCRYPTION:match("sae")) and "WPA Protected" or GUEST_ENCRYPTION and GUEST_ENCRYPTION:match("wep") and "WEP Protected" or "Open Network"), qr_svg, ssid, password, os.date("%%Y-%%m-%%d %%H:%%M"))
end

-- Main execution
local qr_svg = generate_qr_svg(GUEST_SSID, GUEST_PASSWORD, GUEST_ENCRYPTION)
local html_content = generate_html(GUEST_SSID, GUEST_PASSWORD, qr_svg)

print("Using guest network: " .. GUEST_SSID .. " (" .. (GUEST_ENCRYPTION or "none") .. ")")

-- Write HTML file
local html_file = io.open(GUEST_DIR .. "/index.html", "w")
if html_file then
  html_file:write(html_content)
  html_file:close()
  print("Guest QR page generated: " .. GUEST_DIR .. "/index.html")
else
  print("Error: Could not write to " .. GUEST_DIR .. "/index.html")
end

-- Write QR SVG file separately
local svg_file = io.open(GUEST_DIR .. "/qr.svg", "w")
if svg_file then
  svg_file:write(qr_svg)
  svg_file:close()
  print("QR SVG generated: " .. GUEST_DIR .. "/qr.svg")
end