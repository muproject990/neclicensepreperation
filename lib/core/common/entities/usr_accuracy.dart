// services/user_accuracy_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class UserAccuracyService {
  static Future<double> loadUserAccuracy(String data, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('$data$userId') ?? 0.0;
  }

  static Future<void> saveUserAccuracy(
      double accuracy, String data, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('$data$userId', accuracy);
    print("User accuracy saved successfully: $accuracy%");
  }
}
