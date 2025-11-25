import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class AppConstants {
  AppConstants._();

  static String get baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:8000';

    if (Platform.isAndroid) {
      // Android emulator cannot reach PC localhost directly
      return 'https://fmsbackend-production-3a7b.up.railway.app/';
    }

    return 'https://fmsbackend-production-3a7b.up.railway.app/';
  }
}

