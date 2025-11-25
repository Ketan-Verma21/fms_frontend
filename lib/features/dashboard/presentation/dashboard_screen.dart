import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/controllers/login_controller.dart';
import '../../files/presentation/files_tab.dart';
import '../../shelves/presentation/shelves_tab.dart';
import '../../staff/presentation/staff_tab.dart';
import '../../staff/models/staff.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staff = ref.watch(loginControllerProvider).staff;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: _DashboardDrawer(staff: staff),
        appBar: AppBar(
          title: const Text('Office File Management'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Files', icon: Icon(Icons.folder_copy_outlined)),
              Tab(text: 'Shelves', icon: Icon(Icons.inventory_2_outlined)),
              Tab(text: 'Staff', icon: Icon(Icons.group_outlined)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [FilesTab(), ShelvesTab(), StaffTab()],
        ),
      ),
    );
  }
}

class _DashboardDrawer extends ConsumerWidget {
  const _DashboardDrawer({required this.staff});

  final Staff? staff;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: theme.colorScheme.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: theme.colorScheme.onPrimary.withOpacity(0.2),
                    child: Image.asset('assets/bpcl_logo.png'),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.folder_copy_outlined),
              title: const Text('FMS'),
              subtitle: const Text('File Management System'),
              onTap: () {
                Navigator.pop(context);
                final controller = DefaultTabController.of(context);
                controller.animateTo(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_2_outlined),
              title: const Text('Me'),
              subtitle: const Text('User profile'),
              onTap: () {
                Navigator.pop(context);
                // Push the Me screen so back returns to dashboard instead of exiting app
                context.push('/me');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: const Text('About'),
              subtitle: const Text('Learn about the app'),
              onTap: () {
                Navigator.pop(context);
                // Push the About screen so back returns to dashboard instead of exiting app
                context.push('/about');
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Sign out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ref.read(loginControllerProvider.notifier).signOut();
                  context.go('/login');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
