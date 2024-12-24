#include <WiFi.h>
#include <WiFiUdp.h>
#include <WakeOnLan.h>
#include <Firebase_ESP_Client.h>
#include <addons/TokenHelper.h>
#include <ArduinoJson.h>
#include <HTTPClient.h>

#define WIFI_SSID ""
#define WIFI_PASSWORD ""
#define FIREBASE_PROJECT_ID ""
#define API_KEY ""
#define USER_EMAIL ""
#define USER_PASSWORD ""

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

WiFiUDP UDP;  
WakeOnLan WOL(UDP);
uint8_t macAddress[] = { 0x08, 0x8F, 0xC3, 0x70, 0xD1, 0x57 };
bool monitoring = false;

void setup() {
  Serial.begin(115200);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {  
    delay(1000);
    Serial.print(".");
  }
  Serial.println("\nConnected to WiFi!");
  config.api_key = API_KEY;
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;
  config.token_status_callback = tokenStatusCallback;
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
  Serial.println(WiFi.localIP());
}

void processJson(String hwjson) {
  StaticJsonDocument<1024> doc;  // Change size if not enough space
  DeserializationError error = deserializeJson(doc, hwjson);
  if (error) {
    Serial.print(F("deserializeJson() failed: "));
    Serial.println(error.f_str());
    return;
  }
  const char* CpuTemp = doc["Children"][0]["Children"][0]["Children"][3]["Children"][10]["Value"];
  const char* CpuLoad = doc["Children"][0]["Children"][0]["Children"][4]["Children"][0]["Value"];
  const char* MemLoad = doc["Children"][0]["Children"][1]["Children"][0]["Children"][0]["Value"];
  const char* DiskTemp = doc["Children"][0]["Children"][2]["Children"][0]["Children"][0]["Value"];
  String one = String(CpuTemp);
  one.remove(one.length() -6);
  String two = String(CpuLoad);
  two.remove(two.length() -4);
  String three = String(MemLoad);
  three.remove(three.length() -4);
  String five = String(DiskTemp);
  five.remove(five.length() -6);
  FirebaseJson json;
  json.set("fields/one/stringValue", one);
  json.set("fields/two/stringValue", two);
  json.set("fields/three/stringValue", three);
  json.set("fields/five/stringValue", five);
  if (Firebase.Firestore.patchDocument(&fbdo, FIREBASE_PROJECT_ID, "", "/hw/hwmonitor1", json.raw(),"one")&&
      Firebase.Firestore.patchDocument(&fbdo, FIREBASE_PROJECT_ID, "", "/hw/hwmonitor1", json.raw(),"two")&&
      Firebase.Firestore.patchDocument(&fbdo, FIREBASE_PROJECT_ID, "", "/hw/hwmonitor1", json.raw(),"three")&&
      Firebase.Firestore.patchDocument(&fbdo, FIREBASE_PROJECT_ID, "", "/hw/hwmonitor1", json.raw(),"five")) {
    Serial.println("send");
  } else {
    Serial.println("Error sending data ");
  }
}

void get(){
    HTTPClient http;
    WiFiClient client;
    http.begin(client, "http://192.168.0.108:8085/data.json"); // Change to your IP address:8085
    int httpCode = http.GET();
    if (httpCode > 0) {
        String payload = http.getString();
        processJson(payload);
    } else {
        Serial.println("Error on HTTP request");
    }
    http.end();
}

void check() {
  String path = "cmd/button1";
  if (Firebase.Firestore.getDocument(&fbdo, FIREBASE_PROJECT_ID, "", path.c_str(),""))
  {
    Serial.println("ok");
    StaticJsonDocument<64> doc;
    DeserializationError error = deserializeJson(doc, fbdo.payload().c_str());
    if (!error) {
    bool wol = doc["fields"]["wol"]["booleanValue"];
    bool start = doc["fields"]["start"]["booleanValue"];
    bool reboot = doc["fields"]["reboot"]["booleanValue"];
    if (wol) {
      WOL.sendMagicPacket(macAddress, sizeof(macAddress));
      Serial.println("Magic Packet dikirim untuk WoL");
    }
    if (reboot) {
      Serial.println("ESP akan reboot...");
      delay(1000);
      ESP.restart();  
    }
    if (start){
      monitoring = true;
      Serial.println("Start monitoring");
    } else {
      monitoring = false;
    }
  } else {
    Serial.println("raiso parsing");
  }
  } else {
    Serial.println("raono data");
  }
}

void status(){
  String devicePath = "devices/esp32"; // Collection: devices, Document: esp32
  FirebaseJson json;
  json.set("fields/status/booleanValue", true);
  if(Firebase.Firestore.patchDocument(&fbdo, FIREBASE_PROJECT_ID, "", devicePath.c_str(), json.raw(), "status")){
    Serial.println("online");
  } else{
    Serial.println("offline");
  }
}

void loop() {
  check();
  status();
  if(monitoring == true){
    get();
  }
  delay(5000);
}


