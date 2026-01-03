#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include <addons/TokenHelper.h>
#include <addons/RTDBHelper.h>

// ==========================================
// 1. KREDENSIAL WIFI RUMAH ANDA
// ==========================================
#define WIFI_SSID "Kerend_Jo"
#define WIFI_PASSWORD "812345678."

// ==========================================
// 2. KREDENSIAL FIREBASE
// ==========================================
#define API_KEY "FIREBASE API KEY"
#define DATABASE_URL "https://RTDB ANDA.asia-southeast1.firebasedatabase.app/"

// ==========================================
// 3. DEFINISI PIN (MQ-5)
// ==========================================
// Gunakan Pin AO (Analog Output) dari MQ-5 ke GPIO 34 ESP32
#define MQ5PIN 34  

// Object Firebase
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;
bool signupOK = false;

void setup() {
  Serial.begin(115200);
  
  // Konfigurasi Pin Sensor
  pinMode(MQ5PIN, INPUT);

  // Mulai Koneksi WiFi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Menghubungkan ke WiFi: ");
  Serial.println(WIFI_SSID);

  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  
  Serial.println();
  Serial.println("Terhubung ke WiFi!");
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());

  // Konfigurasi Firebase
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;

  // Sign up Anonim
  if (Firebase.signUp(&config, &auth, "", "")) {
    Serial.println("Firebase Auth Berhasil!");
    signupOK = true;
  } else {
    Serial.printf("Error Auth: %s\n", config.signer.signupError.message.c_str());
  }

  config.token_status_callback = tokenStatusCallback;
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

void loop() {
  // Kirim data setiap 3 detik
  if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 3000 || sendDataPrevMillis == 0)) {
    sendDataPrevMillis = millis();
    
    // Baca nilai sensor MQ-5
    int rawValue = analogRead(MQ5PIN);
    
    Serial.printf("Nilai Gas LPG (MQ-5): %d\n", rawValue);

    // --- PERUBAHAN PENTING ---
    // Saya ubah path database-nya jadi "MQ5" agar sesuai hardware
    if (Firebase.RTDB.setInt(&fbdo, "/MQ5/GasValue", rawValue)) {
      Serial.println(">> Terkirim ke folder /MQ5 di Firebase!");
    } else {
      Serial.println(">> Gagal Kirim: " + fbdo.errorReason());
    }
  }
}