import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../utils/app_constants.dart';

class GasGauge extends StatelessWidget {
  final int value;
  final bool isDanger;

  const GasGauge({super.key, required this.value, required this.isDanger});

  @override
  Widget build(BuildContext context) {
    // Hitung persentase (0.0 sampai 1.0)
    // .clamp memastikan nilai tidak error jika sensor > 4095
    double percent = (value / AppConstants.maxSensorValue).clamp(0.0, 1.0);

    Color statusColor = isDanger
        ? AppConstants.dangerColor
        : AppConstants.safeColor;

    return CircularPercentIndicator(
      radius: 120.0,
      lineWidth: 15.0,
      percent: percent,
      animation: true,
      animateFromLastPercent: true,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$value",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
          const Text("ppm", style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
      progressColor: statusColor,
      backgroundColor: Colors.grey.shade200,
      circularStrokeCap: CircularStrokeCap.round,
    );
  }
}
