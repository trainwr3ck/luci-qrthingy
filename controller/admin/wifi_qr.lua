module("luci.controller.admin.wifi_qr", package.seeall)

function index()
  entry({"admin", "network", "wifi_qr"}, template("admin_wifi_qr"), _("WiFi QR"), 60).dependent = false
  entry({"admin", "network", "wifi_qr", "network"}, template("admin_wifi_qr_network"))
  entry({"admin", "network", "wifi_qr", "data"}, call("action_data"))
  entry({"admin", "network", "wifi_qr", "svg"}, call("action_svg"))
end

local cache = {data = nil, time = 0}

function action_data()
  local http = require "luci.http"
  local now = os.time()
  
  http.header("Content-Security-Policy", "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'")
  
  if cache.data and (now - cache.time) < 30 then
    http.prepare_content("application/json")
    http.write_json(cache.data)
    return
  end
  
  local uci = require "luci.model.uci".cursor()
  local networks = {}
  uci:foreach("wireless", "wifi-iface", function(s)
    if s.ssid and (s.mode == "ap" or s.mode == nil) then
      local enc = s.encryption or "none"
      local key = s.key or ""
      table.insert(networks, {ssid = s.ssid, encryption = enc, key = key})
    end
  end)
  
  cache.data = networks
  cache.time = now
  
  http.prepare_content("application/json")
  http.write_json(networks)
end

function action_svg()
  local http = require "luci.http"

  local sid = http.formvalue("ssid")
  local key = http.formvalue("key") or ""
  local enc = http.formvalue("enc") or "none"
  
  http.header("Content-Security-Policy", "default-src 'self'")
  
  if not sid or sid:match("[<>&\"']") or key:match("[<>&\"']") then
    http.status(400, "Bad Request")
    http.write("Invalid parameters")
    return
  end
  
  local auth = "nopass"
  if enc and (enc:match("psk") or enc:match("sae")) then
    auth = "WPA"
  elseif enc and enc:match("wep") then
    auth = "WEP"
  end
  
  local wifi_data = string.format("WIFI:T:%s;S:%s;P:%s;;", auth, sid, key or "")
  
  -- Try luci-lib-uqr first (pure Lua)
  local ok, uqr = pcall(require, "luci.lib.uqr")
  if ok and uqr then
    local success, qr_matrix = pcall(uqr.encode, wifi_data)
    if success and qr_matrix then
      local svg_data = uqr.svg(qr_matrix, 4)
      if svg_data then
        http.prepare_content("image/svg+xml")
        http.write(svg_data)
        return
      end
    end
  end
  
  -- Fallback to qrencode binary
  local qrencode_cmd = io.popen('echo "' .. wifi_data .. '" | qrencode -t SVG -m 0 -s 8 -o - 2>/dev/null')
  if qrencode_cmd then
    local svg_data = qrencode_cmd:read("*a")
    qrencode_cmd:close()
    
    if svg_data and svg_data ~= "" then
      http.prepare_content("image/svg+xml")
      http.write(svg_data)
      return
    end
  end
  
  -- Final fallback: simple SVG
  local fallback_svg = [[
<svg xmlns="http://www.w3.org/2000/svg" width="320" height="320" viewBox="0 0 320 320">
  <rect width="320" height="320" fill="white"/>
  <text x="160" y="160" text-anchor="middle" font-family="Arial" font-size="14" fill="black">
    QR Code for: ]] .. sid .. [[
  </text>
  <text x="160" y="180" text-anchor="middle" font-family="Arial" font-size="12" fill="gray">
    (Install luci-lib-uqr or qrencode)
  </text>
</svg>
]]
  
  http.prepare_content("image/svg+xml")
  http.write(fallback_svg)
end