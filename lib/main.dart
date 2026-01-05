import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app_router.dart';
import 'app/theme.dart';
import 'core/constants/app_constants.dart';
import 'core/storage/auth_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  
  final prefs = await SharedPreferences.getInstance();
  final storage = AuthStorage(prefs);
  await SentryFlutter.init(
    (options) {
      options.dsn = dotenv.env['SENTRY_DSN']!;
      // Adds request headers and IP for users, for more info visit:
      // https://docs.sentry.io/platforms/dart/guides/flutter/data-management/data-collected/
      options.sendDefaultPii = true;
      options.tracesSampleRate = 1.0;
      // Enable logs to be sent to Sentry
      options.enableLogs = true;
    },
   appRunner: () => runApp(
  SentryWidget(
    child: BetterFeedback(
      localeOverride: const Locale('en'),
      child: ProviderScope(
        overrides: [
          authStorageProvider.overrideWithValue(storage),
        ],
        child: const FileManagementApp(),
      ),
    ),
  ),
)
  );
}

class FileManagementApp extends ConsumerWidget {
  const FileManagementApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Office File Management',
      theme: buildPurpleTheme(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
