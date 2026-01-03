import 'package:firebase_database/firebase_database.dart';
import '../utils/app_constants.dart';

class DatabaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref(
    AppConstants.databasePath,
  );

  // Stream untuk mendengarkan perubahan data secara realtime
  Stream<int> getGasStream() {
    return _dbRef.onValue.map((event) {
      final value = event.snapshot.value;
      if (value != null) {
        // Pastikan parsing ke integer aman
        return int.tryParse(value.toString()) ?? 0;
      }
      return 0;
    });
  }
}
