import 'package:flutter/material.dart';

class AppConstants {
  // Ambang batas bahaya
  static const int dangerThreshold = 2000;

  // Nilai Maksimum Sensor (ADC ESP32 biasanya 4095)
  static const int maxSensorValue = 4095;

  // Path Firebase
  static const String databasePath = "MQ2/GasValue";

  // Warna
  static const Color safeColor = Colors.green;
  static const Color dangerColor = Colors.red;
  static const Color neutralColor = Colors.grey;
}
