-- This code is for NodeMCU with firmware > 2.X.X including dht library !
-- This code check temperature and humidity from a DHT22 (DHT11 compatible) sensor
-- and send it to Thingsboard dashboard using MQTT
-- Connexion : Data pin of DHT22 to D4 pin, - to GND, + to 3V3 or 5V
-- NOTE : Maybe you need to unplug DHT22 temporarily to connect USB via serial

local dht = require 'dht'

print ("Main.lua started")

-- Used in this file, updated by mqtt.lua
is_mqtt_connected=false

-- Establish Wi-Fi and MQTT connection
dofile('wifi.lua')

-- DHT22 Data PIN
DHT_PIN=4

-- Check temperature & humidity every 5 seconds
message="Not checked."
-- Float firmware
temp = 0.0
humi = 0.0
-- Integer firmware
--temp = 0
--humi = 0

function send_data_to_mqtt(temp, humi, temp_dec, humi_dec)
    if(is_mqtt_connected) then
        -- Float firmware
        mqtt_client:publish("v1/devices/me/telemetry",
                "[{\"temperature\":"..temp.."}, {\"humidity\":"..humi.."}]", 0, 0, function(client) print("Data sent to MQTT broker") end)
        -- Integer firmware
        --mqtt_client:publish("v1/devices/me/telemetry", string.format("[{\"temperature\":%d}, {\"humidity\":%d}]",
        --       math.floor(temp), math.floor(humi)), 0, 0, function(client) print("Data sent") end)
    else
        print("Data not sent to MQTT broker : not connected")
    end
end

-- Timer to periodically read temperature from DHT22 every minute
check_dht = tmr.create()
check_dht:register(60 * 1000, tmr.ALARM_AUTO, function()
    print("Reading data from DHT...")
    status, temp, humi, temp_dec, humi_dec = dht.read(DHT_PIN)
    if status == dht.OK then
        -- Float firmware
        message = ("DHT Temperature:"..temp..";".."Humidity:"..humi)
        -- Integer firmware
        --message = string.format("DHT Temperature:%d.%03d;Humidity:%d.%03d\r\n", math.floor(temp), temp_dec, math.floor(humi), humi_dec)
        send_data_to_mqtt(temp, humi, temp_dec, humi_dec)
    elseif status == dht.ERROR_CHECKSUM then
        message = "Checksum error."
    elseif status == dht.ERROR_TIMEOUT then
        message = "Timed out."
    end
    print("Data read from DHT : "..message)
end)
check_dht:start()

-- Serve current temperature & humidity as text on port 80
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive",function(client,payload)
        url_suffix = string.sub(payload,string.find(payload,"GET /") + 5,string.find(payload,"HTTP/")-2)
        text = ""
        if url_suffix == "temperature" then
            text = (""..temp)
        elseif url_suffix == "humidity" then
            text = (""..humi)
        else
            text = message
        end
        client:send(text)
    end)
    conn:on("sent",function(client)
        client:close()
        collectgarbage()
    end)
end)
