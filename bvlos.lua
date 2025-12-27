-- BVLOS Telemetry
-- EdgeTX 2.11
-- Updated: Distance enlarged, Battery % removed, HDOP always visible

local config = {
  cells = 4,
  capacity = 5000,
  warn_volt = 14.8,
  crit_volt = 14.0,
  min_sats = 10,
  tqly_warn = 50,
  rssi_warn = -80,
  cruise = 55
}

local sensor_ids = {}
local blink = false
local blink_time = 0

local function get_id(name)
  if sensor_ids[name] then
    return sensor_ids[name]
  end
  
  local field = getFieldInfo(name)
  if field and field.id then
    sensor_ids[name] = field.id
    return field.id
  end
  
  return nil
end

local function get(name, default)
  local id = get_id(name)
  if not id then return default end
  local v = getValue(id)
  if v == nil then return default end
  return v
end

local function tick_blink()
  local now = getTime()
  if now - blink_time > 50 then
    blink = not blink
    blink_time = now
  end
  return blink
end

local function init()
end

local function run(event)
  if event == EVT_EXIT_BREAK then
    return 1
  end
  
  lcd.clear()
  
  local fm = get("FM", nil)
  local mode = "---"
  
  if fm ~= nil then
    if type(fm) == "string" then
      mode = string.sub(fm, 1, 3)
    elseif type(fm) == "number" then
      mode = "M" .. fm
    end
  end
  
  local sat = get("Sats", 0)
  if sat == 0 or type(sat) ~= "number" then 
    sat = get("GPS", 0) 
  end
  if type(sat) ~= "number" then sat = 0 end
  
  local hdop = get("HDOP", 99.9)
  if hdop == 99.9 or type(hdop) ~= "number" then 
    hdop = get("GpsH", 99.9) 
  end
  if type(hdop) ~= "number" then hdop = 99.9 end
  
  local volt = get("VFAS", 0)
  if volt == 0 or type(volt) ~= "number" then 
    volt = get("RxBt", 0) 
  end
  if type(volt) ~= "number" then volt = 0 end
  
  local curr = get("Curr", 0)
  if type(curr) ~= "number" then curr = 0 end
  
  local used = get("Capa", 0)
  if type(used) ~= "number" then used = 0 end
  
  local alt = get("Alt", 0)
  if alt == 0 or type(alt) ~= "number" then 
    alt = get("GAlt", 0) 
  end
  if type(alt) ~= "number" then alt = 0 end
  
  local dist = get("Dist", 0)
  if type(dist) ~= "number" then dist = 0 end
  
  local hdg = get("Hdg", 0)
  if type(hdg) ~= "number" then hdg = 0 end
  
  local spd = get("GSpd", 0)
  if spd == 0 or type(spd) ~= "number" then 
    spd = get("ASpd", 0) 
  end
  if type(spd) ~= "number" then spd = 0 end
  
  local tqly = get("TQLY", -1)
  if type(tqly) ~= "number" then tqly = -1 end
  
  local rssi = get("1RSS", -999)
  if rssi == -999 or type(rssi) ~= "number" then 
    rssi = get("RSSI", -999) 
  end
  if type(rssi) ~= "number" then rssi = -999 end
  
  local w_gps  = sat < config.min_sats
  local w_batt = volt > 0 and volt < config.warn_volt
  local w_crit = volt > 0 and volt < config.crit_volt
  
  local w_sig = false
  if tqly >= 0 and tqly < config.tqly_warn then
    w_sig = true
  elseif rssi > -999 and rssi < config.rssi_warn then
    w_sig = true
  end
  
  local w_rtl  = (mode == "RTL")
  local b = tick_blink()
  
  -- Row 1: Mode + GPS + HDOP + TQLY + RSSI
  lcd.drawText(0, 0, mode, SMLSIZE)
  
  lcd.drawText(25, 0, string.format("S%d", sat),
    (w_gps and not b) and SMLSIZE + BLINK or SMLSIZE)
  
  -- HDOP always visible
  lcd.drawText(45, 0, string.format("H%.1f", hdop), SMLSIZE)
  
  -- Show TQLY (link quality %) - moved left for space
  if tqly >= 0 then
    lcd.drawText(77, 0, string.format("Q%d", tqly),
      (w_sig and not b and tqly < config.tqly_warn) and SMLSIZE + BLINK or SMLSIZE)
  end
  
  -- Show RSSI (dBm)
  if rssi > -999 then
    lcd.drawText(72, 0, string.format("%d", rssi),
      (w_sig and not b and rssi < config.rssi_warn) and SMLSIZE + BLINK or SMLSIZE)
  end
  
  lcd.drawLine(0, 9, 128, 9, SOLID, FORCE)
  
  -- Row 2-3: Battery (percentage removed, only voltage and current)
  lcd.drawText(0, 11, string.format("%.1fV", volt),
    (w_crit and not b) and MIDSIZE + BLINK or MIDSIZE)
  lcd.drawText(60, 11, string.format("%.1fA", curr), SMLSIZE)
  lcd.drawText(60, 20, string.format("%.2fAh", used/1000), SMLSIZE)
  
  lcd.drawLine(0, 29, 128, 29, SOLID, FORCE)
  
  -- Row 4-5: Position (Distance now in MIDSIZE like speed)
  lcd.drawText(0, 31, string.format("%.1fkm", dist/1000), SMLSIZE)
  lcd.drawText(70, 31, alt.."m", SMLSIZE)
  lcd.drawText(0, 40, string.format("%dkph", spd * 3.6), SMLSIZE)
  lcd.drawText(70, 40, string.format("@%03d", hdg), SMLSIZE)
  
  if dist > 0 then
    local eta = (dist / 1000) / config.cruise * 60
    lcd.drawText(100, 40, string.format("%d:%02d", 
      math.floor(eta/60), eta%60), SMLSIZE)
  end
  
  lcd.drawLine(0, 49, 128, 49, SOLID, FORCE)
  
  -- Row 6: Status
  if w_rtl and b then
    lcd.drawText(24, 52, "** RTL **", MIDSIZE + INVERS)
  elseif w_crit then
    lcd.drawText(12, 52, "BATTERY CRIT", SMLSIZE + INVERS)
  elseif w_gps then
    lcd.drawText(24, 52, "LOW GPS", MIDSIZE + INVERS)
  elseif w_batt then
    lcd.drawText(16, 52, "BATTERY LOW", SMLSIZE + INVERS)
  elseif w_sig then
    lcd.drawText(12, 52, "WEAK SIGNAL", SMLSIZE + INVERS)
  else
    lcd.drawText(40, 54, "ALL OK", SMLSIZE)
  end
  
  return 0
end

return {init=init, run=run}