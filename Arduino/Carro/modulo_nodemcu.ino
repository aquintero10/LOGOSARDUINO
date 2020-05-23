#include <ESP8266WiFiMulti.h>
#include <WiFiClient.h>
#include <SoftwareSerial.h>
#include <PubSubClient.h>
#include <ESP8266HTTPClient.h>
#define MQTT_SOCKET_TIMEOUT 20

int port = 10;
WiFiServer server(port);

//-------------------VARIABLES GLOBALES--------------------------
//MOTOR DERECHA
int OUTPUT4 = 16;
int OUTPUT3 = 5;
//MOTOR IZQUIERDA
int OUTPUT2 = 4;
int OUTPUT1 = 0;

//CONEXION DE RED WIFI
const char *ssid = "WIFI Andres1";
const char *password = "*********";

const char *serverHostname = "34.70.164.156";//"192.168.0.15";



const char *helloTopic = "client/connected";
const char *topic = "get/gpsdata";
const char *outTopic = "send/gpsdata";
const char *outTopicDataErr = "data/notready";

char PLACA[50];

char valueStr[15];
String strtemp = "";
char SALIDADIGITAL[50];

IPAddress ip(192,168,1,200);     
IPAddress gateway(192,168,0,1);   
IPAddress subnet(255,255,255,0);   


//-------------------------------------------------------------------------
ESP8266WiFiMulti WiFiMulti;
WiFiClient cliente;
PubSubClient pubClient(cliente);
HTTPClient http;

//------------------------CALLBACK-----------------------------
void callback(char* topic, byte* payload, unsigned int length) {

  char PAYLOAD[50] = "    ";
  
  Serial.print("Mensaje Recibido: [");
  Serial.print(topic);
  Serial.print("] ");
  for (int i = 0; i < length; i++) {
    PAYLOAD[i] = (char)payload[i];
  }
  Serial.println(PAYLOAD);
  String mensaje =  String(PAYLOAD);
  mensaje.trim();
  Serial.println("mensaje: |"+mensaje+"|FIN");
  
    if (mensaje.equals("LED"))  {
      digitalWrite(12, HIGH);
      delay(1000);
      digitalWrite(12, LOW);
    }

   if (mensaje.equals("ADELANTE")) { 
      digitalWrite(OUTPUT1, 0);
      digitalWrite(OUTPUT2, 1);
      digitalWrite(OUTPUT3, 1);
      digitalWrite(OUTPUT4, 0);
      delay(1000);
      digitalWrite(OUTPUT1, 0);
      digitalWrite(OUTPUT2, 0);
      digitalWrite(OUTPUT3, 0);
      digitalWrite(OUTPUT4, 0);
    }
    
    if (mensaje.equals("ATRAS"))  {
      digitalWrite(OUTPUT1, 1);
      digitalWrite(OUTPUT2, 0);
      digitalWrite(OUTPUT3, 0);
      digitalWrite(OUTPUT4, 1);
      delay(1000);
      digitalWrite(OUTPUT1, 0);
      digitalWrite(OUTPUT2, 0);
      digitalWrite(OUTPUT3, 0);
      digitalWrite(OUTPUT4, 0);
    }
    
    if (mensaje.equals("DERECHA"))  {
      digitalWrite(OUTPUT1, 0);
      digitalWrite(OUTPUT2, 1);
      digitalWrite(OUTPUT3, 0);
      digitalWrite(OUTPUT4, 1);
      delay(500);
      digitalWrite(OUTPUT1, 0);
      digitalWrite(OUTPUT2, 0);
      digitalWrite(OUTPUT3, 0);
      digitalWrite(OUTPUT4, 0);
     
    }
    
    if (mensaje.equals("IZQUIERDA"))  {
      digitalWrite(OUTPUT1, 1);
      digitalWrite(OUTPUT2, 0);
      digitalWrite(OUTPUT3, 1);
      digitalWrite(OUTPUT4, 0);
      delay(500);
      digitalWrite(OUTPUT1, 0);
      digitalWrite(OUTPUT2, 0);
      digitalWrite(OUTPUT3, 0);
      digitalWrite(OUTPUT4, 0);
    }

     
}

//------------------------RECONNECT-----------------------------
void connectMQTT() {
  // Wait until we're connected
  while (!pubClient.connected()) {
    // Create a random client ID
    String clientId = "ESP8266-A9001";
    Serial.printf("MQTT connecting as client %s...\n", clientId.c_str());
    // Attempt to connect
    if (pubClient.connect(clientId.c_str())) {
      Serial.println("MQTT connected");
      // Once connected, publish an announcement...
      //pubClient.publish(helloTopic, "hello from ESP8266");
      // ... and resubscribe
      pubClient.subscribe("get/prenderled"/*topic*/);
      pubClient.subscribe("get/arriba");
      pubClient.subscribe("get/abajo");
      pubClient.subscribe("get/izquierda");
      pubClient.subscribe("get/derecha");
    } else {
      Serial.printf("MQTT failed, state %s, retrying...\n", pubClient.state());
      // Wait before retrying
      delay(2500);
    }
  }
}

//------------------------SETUP-----------------------------
void setup() {

  pinMode(12, OUTPUT); // D6 salida digital
  digitalWrite(12, LOW);
  
  pinMode (OUTPUT1, OUTPUT);
  pinMode (OUTPUT2, OUTPUT);
  pinMode (OUTPUT3, OUTPUT);
  pinMode (OUTPUT4, OUTPUT);
  delay(10);

  // Inicia Serial
  Serial.begin(115200);

  Serial.println();
  Serial.println();
  Serial.println();

  for (uint8_t t = 4; t > 0; t--) {
    Serial.printf("[SETUP] WAIT %d...\n", t);
    Serial.flush();
    //delay(1000);
  }


  WiFi.mode(WIFI_STA);
  WiFi.config(ip, gateway, subnet);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) 
  {
    delay(200); 
  Serial.print('.');
  }

 
  Serial.println("Conexión establecida");  
  Serial.print("IP address:\t");
  Serial.println(WiFi.localIP());  
  Serial.print("Puerto:");
  Serial.println(port);

  Serial.print("[HTTP] begin...\n");

  pubClient.setServer(serverHostname, 1883);
  pubClient.setCallback(callback);
  Serial.print("PubSub client ready...\n");
}

//--------------------------LOOP--------------------------------
void loop() {
  if (!pubClient.connected()) {
    connectMQTT();
  }
  // this is ESSENTIAL!
  pubClient.loop();

}
