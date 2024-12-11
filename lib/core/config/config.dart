import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get apiBaseUrl => _dotEnvKey("API_BASE_URL");
  static String _dotEnvKey(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw Exception("Missing env key: $key");
    }
    return value;
  }
}
