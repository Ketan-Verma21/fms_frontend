import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  AppConstants._();

  static String get baseUrl {
    if (kIsWeb) return 'https://fmsbackend-production-3a7b.up.railway.app/';

    if (Platform.isAndroid) {
      // Android emulator cannot reach PC localhost directly
      return 'https://fmsbackend-production-3a7b.up.railway.app/';
    }

    return 'https://fmsbackend-production-3a7b.up.railway.app/';
  }

  // Supabase credentials loaded from .env file
  // Get these from: Supabase Dashboard → Settings → API
  static String get supabaseUrl => dotenv.env['SUPABASE_URL']!;
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY']!;
}

