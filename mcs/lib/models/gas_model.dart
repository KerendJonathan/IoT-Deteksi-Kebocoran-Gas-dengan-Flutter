import '../utils/app_constants.dart';

class GasModel {
  final int value;
  final bool isDanger;

  GasModel({required this.value, required this.isDanger});

  // Factory untuk membuat object dari data mentah (integer)
  factory GasModel.fromValue(int rawValue) {
    return GasModel(
      value: rawValue,
      isDanger: rawValue > AppConstants.dangerThreshold,
    );
  }
}
