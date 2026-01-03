import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:intl/intl.dart';
import '../providers/gas_provider.dart';
import '../utils/app_constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Ambil Data
    final gasProvider = context.watch<GasProvider>();
    final gasData = gasProvider.currentGas;

    // 2. Tentukan Warna & Status
    final bool isDanger = gasData.isDanger;
    final Color primaryColor = isDanger
        ? Colors.redAccent
        : const Color(0xFF00BFA5);
    final Color bgColor = isDanger
        ? const Color(0xFFFFF5F5)
        : const Color(0xFFF8FDFD); // Background lebih cerah

    // Data Pendukung
    String dateNow = DateFormat('EEEE, d MMM yyyy').format(DateTime.now());
    double percent = (gasData.value / AppConstants.maxSensorValue).clamp(
      0.0,
      1.0,
    );

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER CUSTOM (KEREND) =================
            _buildCustomHeader(context, dateNow, primaryColor, isDanger),

            const SizedBox(height: 15),

            // ================= CONTENT =================
            Expanded(
              child: _buildMainGauge(
                gasData.value,
                percent,
                primaryColor,
                isDanger,
              ),
            ),

            // ================= FOOTER =================
            _buildFooter(context, primaryColor, isDanger),
          ],
        ),
      ),
    );
  }

  // WIDGET: HEADER KHUSUS "KEREND"
  Widget _buildCustomHeader(
    BuildContext context,
    String date,
    Color color,
    bool isDanger,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withValues(
              alpha: 0.1,
            ), // Bayangan mengikuti warna status
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. Avatar dengan Hiasan Ring
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
              ),
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withValues(alpha: 0.1),
                child: Icon(Icons.person_rounded, color: color, size: 28),
              ),
            ],
          ),

          const SizedBox(width: 15),

          // 2. Teks Sapaan & Tanggal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Halo, Kerend 👋",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800, // Lebih tebal agar menonjol
                    color: Colors.black87,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Monitoring Aktif • $date",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // 3. Status Chip (Live Indicator)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDanger
                  ? Colors.red.withValues(alpha: 0.1)
                  : Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  isDanger ? Icons.warning_amber_rounded : Icons.wifi_tethering,
                  size: 18,
                  color: isDanger ? Colors.red : Colors.green,
                ),
                const SizedBox(height: 2),
                Text(
                  isDanger ? "ALERT" : "ONLINE",
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: isDanger ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET: GAUGE (Tetap Compact)
  Widget _buildMainGauge(
    int value,
    double percent,
    Color color,
    bool isDanger,
  ) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            radius: 105.0,
            lineWidth: 20.0,
            animation: true,
            animateFromLastPercent: true,
            percent: percent,
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: Colors.grey.shade100,
            progressColor: color,
            arcType: ArcType.FULL,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon Status Besar
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isDanger
                        ? Icons.local_fire_department_rounded
                        : Icons.shield_rounded,
                    size: 32,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "$value",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 36.0,
                    color: color,
                  ),
                ),
                Text(
                  "PPM GAS",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.0,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          // Kartu Status Teks
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: color.withValues(alpha: 0.2)),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              isDanger ? "BAHAYA TERDETEKSI!" : "KUALITAS UDARA AMAN",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET: FOOTER
  Widget _buildFooter(BuildContext context, Color color, bool isDanger) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: _infoCardSmall(
                  "Sensor",
                  "MQ-2",
                  Icons.sensors,
                  Colors.purple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _infoCardSmall(
                  "Lokasi",
                  "Dapur",
                  Icons.kitchen,
                  Colors.orange,
                ),
              ), // Icon diganti Kitchen agar relevan
              const SizedBox(width: 12),
              Expanded(
                child: _infoCardSmall(
                  "Status",
                  "Aktif",
                  Icons.wifi_rounded,
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Tombol Aksi
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: isDanger
                    ? Colors.red
                    : const Color(0xFF00BFA5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: color.withValues(alpha: 0.4),
              ),
              child: Text(
                isDanger ? "PANGGIL BANTUAN" : "CEK KONDISI SISTEM",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCardSmall(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 10)),
        ],
      ),
    );
  }
}
