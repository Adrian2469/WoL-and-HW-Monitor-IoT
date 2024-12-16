#include <WiFi.h>
#include <BlynkSimpleEsp32.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include <WiFiUdp.h>
#include <WakeOnLan.h>

#define BLYNK_TEMPLATE_ID "" // Change to your Blynk template id
#define BLYNK_TEMPLATE_NAME "" // Change to your Blynk template name
#define BLYNK_PRINT Serial

char auth[] = "";  // Change to your Blynk authentication token
char ssid[] = "";  // Your WiFi SSID
char pass[] = "";  // Your WiFi password
bool looping = false;
uint8_t macAddress[] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }; // Change 00 with your computer MAC address

WiFiUDP UDP;              
WakeOnLan WOL(UDP); 

// 
void processJson(String json) {
    StaticJsonDocument<1024> doc;  // Change size if not enough space
    DeserializationError error = deserializeJson(doc, json);

     if (error) {
         Serial.print(F("deserializeJson() failed: "));
         Serial.println(error.f_str());
         return;
     }

     // Use json formatter to find the location of the hardware data value in Libre Hardware Monitor json
     const char* CpuTemp = doc["Children"][0]["Children"][0]["Children"][3]["Children"][10]["Value"];
     const char* CpuLoad = doc["Children"][0]["Children"][0]["Children"][3]["Children"][10]["Value"];
     const char* MemoryLoad = doc["Children"][0]["Children"][0]["Children"][3]["Children"][10]["Value"];
     double cpu = atof(CpuLoad);
     double mem = atof(MemoryLoad);
     int temp = atoi(CpuTemp);
     Blynk.virtualWrite(V2,cpu);
     Blynk.virtualWrite(V1,mem);
     Blynk.virtualWrite(V0,temp);
}

void setup() {
  Serial.begin(115200);
  Serial.print("Connecting to WiFi");
  WiFi.begin(ssid, pass);
  while (WiFi.status() != WL_CONNECTED) {  
    delay(1000);
    Serial.print(".");
  }
  Serial.println("\nConnected to WiFi!");
  Serial.print("ESP32 IP Address: ");
  Serial.println(WiFi.localIP());
  Blynk.begin(auth, ssid, pass);
}

// Send hardware value to Blynk
void sendData(){
    HTTPClient http;
    WiFiClient client;
    http.begin(client, "http://192.168.0.0:8085/data.json"); // Change to your IP address:8085
    int httpCode = http.GET();

    if (httpCode > 0) {
        String payload = http.getString();
        Serial.println("Receive JSON:");
        processJson(payload);
    } else {
        Serial.println("Error on HTTP request");
    }
    http.end();
}

// Wake on Lan
BLYNK_WRITE(V3) {
  int tombolStatus = param.asInt(); 
  if (tombolStatus == 1) {
    // Kirim Magic Packet untuk Wake on LAN
    WOL.sendMagicPacket(macAddress, sizeof(macAddress));
    Serial.println("Sent Magic Packet for Wake on LAN");
  }
}

// Start monitoring temperature and load hardware
BLYNK_WRITE(V4) {
  int tombolStatus = param.asInt(); 
  looping = (tombolStatus == 1);    
  if(looping==true){
    Serial.println("Start");
  } else {
    Serial.println("Stop");
  }
}

void loop() {
    Blynk.run();
    if(looping == true){
    sendData();
    delay(5000);} // Change monitoring delay 
}