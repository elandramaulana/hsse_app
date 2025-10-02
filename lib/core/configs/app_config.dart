// lib/config/app_config.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment { development, production }

class AppConfig {
  // Static App Configuration
  static const String appName = 'MyFlutterApp';
  static const String appVersion = '1.0.0';
  static const String userAgentPrefix = 'MyFlutterApp';

  // Network Configuration
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds
  static const int maxRetries = 3;

  // File Upload Configuration
  static const int maxUploadSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentFormats = [
    'pdf',
    'doc',
    'docx',
    'txt',
  ];

  // Current Environment
  static Environment _currentEnvironment = Environment.development;
  static Environment get currentEnvironment => _currentEnvironment;

  // Initialize configuration
  static Future<void> initialize({required Environment environment}) async {
    _currentEnvironment = environment;

    final envFile = environment == Environment.development
        ? '.env.development'
        : '.env.production';

    await dotenv.load(fileName: envFile);
  }

  // Dynamic Configuration from .env
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String? get apiKey => dotenv.env['API_KEY'];
  static bool get isDebugMode =>
      dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true';
  static bool get isLoggingEnabled =>
      dotenv.env['ENABLE_LOGGING']?.toLowerCase() == 'true';

  // Computed Configuration
  static String get userAgent => '$userAgentPrefix/$appVersion';
  static bool get isProduction => _currentEnvironment == Environment.production;
  static bool get isDevelopment =>
      _currentEnvironment == Environment.development;

  // SSL Pinning Configuration (for future implementation)
  static List<String> get certificatePins => [
    // Add your certificate pins here
    // 'sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=',
  ];

  // Validation
  static bool get isConfigValid {
    return apiBaseUrl.isNotEmpty && Uri.tryParse(apiBaseUrl) != null;
  }

  // Debug information
  static Map<String, dynamic> get debugInfo => {
    'environment': _currentEnvironment.name,
    'apiBaseUrl': apiBaseUrl,
    'hasApiKey': apiKey?.isNotEmpty ?? false,
    'isDebugMode': isDebugMode,
    'isLoggingEnabled': isLoggingEnabled,
    'userAgent': userAgent,
  };
}
