# NodeMCU temperature sensor with MQTT/WebServer output
Lua program for NodeMCU open-source IoT platform.

The code reads temperature and humidity from a DHT11/DHT22 sensor and serves it as HTML data to every browser consulting its IP.

The data is also uploaded to ThingsBoard MQTT broker to be displayed on your web dashboard.

## Pre-requisites
* A NodeMCU 2nd generation / v1.0 / V2 board (although it may work on any other board with ESP8266 ESP-12E module)
* NodeMCU latest firmware (>= 2.2.1-master_20190405 / SDK 2.2.1(6ab97e9)) with included modules : **dht,http,mqtt,wifi**
* DHT11 / DHT22 / AM2302 sensor
* A Thingsboard server / live demo account with an existing device

## HowTo
The .ini files have to be edited with your Wi-Fi access point and Thingsboard account configurations

The DHT/AM data wire shall be plugged to D4 pin (or edit source code to use another pin)
