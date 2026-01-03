import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/gas_model.dart';

class GasProvider with ChangeNotifier {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  GasModel _currentGas = GasModel(value: 0, isDanger: false);
  GasModel get currentGas => _currentGas;

  GasProvider() {
    _listenToGasData();
  }

  void _listenToGasData() {
    // --- BAGIAN PENTING YANG DISESUAIKAN ---
    // Pastikan path ini SAMA PERSIS dengan kode ESP32 Anda
    // ESP32: "/MQ5/GasValue" -> Flutter: child('MQ5/GasValue')

    _dbRef
        .child('MQ5/GasValue')
        .onValue
        .listen(
          (event) {
            final data = event.snapshot.value;

            if (data != null) {
              // Konversi data dari Firebase ke Integer
              int gasValue = int.tryParse(data.toString()) ?? 0;

              // Tentukan batas bahaya (Threshold)
              // Sesuaikan angka 2000 ini dengan sensitivitas sensor MQ-5 Anda
              bool isDanger = gasValue > 2000;

              _currentGas = GasModel(value: gasValue, isDanger: isDanger);
              notifyListeners(); // Kabari UI (Home Screen) untuk update tampilan
            }
          },
          onError: (error) {
            debugPrint("Error membaca data Firebase: $error");
          },
        );
  }
}
