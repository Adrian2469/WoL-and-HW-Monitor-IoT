# WoL-and-HW-Monitor-IoT
This repository showcases a project that integrates IoT functionalities using ESP32 or ESP8266, enabling remote Wake-on-LAN (WoL) control and real-time hardware monitoring through the Blynk platform and Libre Hardware Monitor.

Features 
1. Wake on LAN, wake your computer from shutdown state but still connected to power source via ethernet network.
2. Hardware Monitoring, fetch hardware data such as CPU temperature, memory load, etc from Libre Hardware Monitor remote web server

Requirements
1. Hardware
    - ESP32 (recommended) or ESP8266 (cheaper but unstable)
    - Computer with Wake on Lan supported
    - Ethernet with LAN cable or built-in WiFi adapter
2. Software
    - Arduino IDE, to program your ESP device
    - Blynk android, to make IoT platform
    - Libre Hardware Monitor, to fetch data.json which contain hardware data from remote web server
  
How it works
1. Wake-on-LAN:
    When a button in the Blynk app is pressed, the ESP32 sends a magic packet to the target PC through MAC address on the same network, waking it up from sleep, hibernate, and shutdown state.
2. Hardware Monitoring:
    The ESP32 retrieves data.json from the Libre Hardware Monitor web server, parses the JSON, and sends the data to the Blynk app at the time intervals that we have programmed.

Future Enhancements
1. Add encryption for secure data transmission between ESP32 and IoT platform.
2. Implement alerts for abnormal hardware stats (e.g., high CPU temperature).
3. Make own IoT platform on Android with Flutter.

Feel free to fork this repository, report issues, or contribute enhancements! 
