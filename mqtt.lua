-- MQTT broker connection
-- SDK 2.2.1 minimum !

-- Load configuration from file
if file.exists("mqtt_config.ini") then
    print("Loading MQTT configuration from mqtt_config.ini")
    dofile("mqtt_config.ini")
else
    print("MQTT configuration file not found !")
end

-- Connect to Thingsboard.io MQTT broker
mqtt_client = mqtt.Client(MQTT_CLIENTID, 120, MQTT_USERNAME, MQTT_PASSWORD)

-- Callbacks for MQTT connection
function mqtt_connected(client)
    is_mqtt_connected = true
    print("Connected to MQTT broker")
end
function mqtt_connection_error(client, reason)
    is_mqtt_connected = false
    print("Could not connect, failed reason: " .. reason)
    print("Auto-reconnection in 5 seconds...")
    tmr.create():alarm(5 * 1000, tmr.ALARM_SINGLE, do_mqtt_connect)
end
function mqtt_offline(client)
    is_mqtt_connected = false
    print("MQTT broker offline !")
    print("Auto-reconnection in 5 seconds...")
    tmr.create():alarm(5 * 1000, tmr.ALARM_SINGLE, do_mqtt_connect)
end
function do_mqtt_connect()
    print("Connecting to MQTT broker...")
    mqtt_client:connect(MQTT_IP, MQTT_PORT, 0, mqtt_connected, mqtt_connection_error)
end

mqtt_client:on("offline", mqtt_offline)
do_mqtt_connect()