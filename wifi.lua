-- Wi-fi settings and connection
-- SDK 2.2.1 minimum !

-- Load configuration from file
if file.exists("wifi_config.ini") then
    print("Loading Wi-Fi configuration from wifi_config.ini")
    dofile("wifi_config.ini")
else
    print("Wi-Fi configuration file not found !")
end

-- Establish Wi-Fi connection to a router (no AP)
wifi.setmode(wifi.STATION)
station_cfg={}
station_cfg.ssid=WIFI_SSID
station_cfg.pwd=WIFI_PASS
wifi.sta.config(station_cfg)
wifi.sta.sethostname(WIFI_HOSTNAME)
wifi.sta.connect()
print ("Connecting to Wi-Fi "..station_cfg.ssid.."...")

-- Check if IP address obtained every seconds until success or 10 failed checks
count=0
check_ip_timer = tmr.create()
check_ip_timer:register(1 * 1000, tmr.ALARM_AUTO, function()
    if count>10 then
        print("ERROR : could not connect to access point")
        check_ip_timer:stop()
    elseif wifi.sta.getip()== nil then
        print("IP unavailable, Waiting...")
        count = count+1
    else
        check_ip_timer:stop()
        print("Connected to Wi-Fi "..station_cfg.ssid.." !")
        print("MAC address : " .. wifi.ap.getmac())
        print("IP : "..wifi.sta.getip())
        print("Hostname : "..wifi.sta.gethostname())

        dofile("mqtt.lua")
    end
end)
check_ip_timer:start()