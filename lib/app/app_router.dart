import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/files/presentation/all_files_screen.dart';
import 'package:frontend/features/shelves/presentation/register_shelf_screen.dart';
import 'package:frontend/features/shelves/presentation/shelf_details_screen.dart';
import 'package:frontend/features/shelves/presentation/shelves_list_screen.dart';
import 'package:go_router/go_router.dart';

import '../features/Barcode/presentation/barcode_screen.dart';
import '../features/auth/controllers/login_controller.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/files/presentation/assign_file_screen.dart';
import '../features/files/presentation/register_file_screen.dart';
import '../features/profile/presentation/me_screen.dart';
import '../features/about/presentation/about_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(loginControllerProvider);

  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/me',
        builder: (context, state) => const MeScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/shelves/register',
        builder: (_, __) => const RegisterShelfScreen(),
      ),
      GoRoute(
        path: '/shelves/list',
        builder: (_, __) => const ShelvesListScreen(),
      ),

      GoRoute(
        path: '/shelves/details/:id',
        builder: (context, state) => ShelfDetailsScreen(
          shelfId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: "/scan-barcode",
        builder: (context, state) => const BarcodeScanScreen(),
      ),
      GoRoute(
        path: '/files/register',
        builder: (_, __) => const RegisterFileScreen(),
      ),
      GoRoute(
        path: '/files/assign',
        builder: (_, __) => const AssignFileScreen(),
      ),
      GoRoute(
        path: '/files/all',
        builder: (context, state) => const AllFilesScreen(), // list screen
      ),


    ],
    redirect: (context, state) {
      final loggedIn = authState.isAuthenticated;
      final loggingIn = state.matchedLocation == '/login';

      if (!loggedIn && !loggingIn) return '/login';
      if (loggedIn && loggingIn) return '/dashboard';
      return null;
    },
  );
});

