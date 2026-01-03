import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/gas_provider.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Fungsi inisialisasi Firebase yang aman
  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => GasProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gas Detector IoT',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          fontFamily: 'Roboto', // Gunakan font bawaan yang bersih
        ),
        // Gunakan FutureBuilder untuk mencegah White Screen
        home: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            // 1. Jika Error
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            }

            // 2. Jika Selesai Loading -> Masuk ke Home
            if (snapshot.connectionState == ConnectionState.done) {
              return const HomeScreen();
            }

            // 3. Sedang Loading -> Tampilkan Spinner Cantik
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}
