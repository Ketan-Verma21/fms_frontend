import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/auth/controllers/login_controller.dart';
import 'package:go_router/go_router.dart';


class MeScreen extends ConsumerWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(loginControllerProvider);
    final staff = authState.staff;

    // Safe extraction of common fields with fallbacks
    String name = 'Guest User';
    String email = 'Not available';
    String role = 'Not available';
    String org = 'Not available';

    final dynamic s = staff;
    try {
      if (s != null) {
        final n = s.name;
        if (n != null) name = n.toString();

        final e = s.email ;
        if (e != null) email = e.toString();

        final r = s.role ;
        if (r != null) role = r.toString();

        final o = s.org ;
        if (o != null) org = o.toString();
      }
    } catch (_) {
      // ignore parsing errors and rely on fallbacks
    }

    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        // If there's a route to pop, allow normal pop; otherwise navigate to dashboard
        if (Navigator.of(context).canPop()) return true;
        context.go('/dashboard');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // placeholder for edit action
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                        child: const Icon(Icons.person, size: 36),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name,
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(role, style: theme.textTheme.bodySmall),
                            const SizedBox(height: 4),
                            Text(org, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Details
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Name'),
                      subtitle: Text(name),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.email_outlined),
                      title: const Text('Email'),
                      subtitle: Text(email),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.badge_outlined),
                      title: const Text('Role / Designation'),
                      subtitle: Text(role),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.business_outlined),
                      title: const Text('Organization'),
                      subtitle: Text(org),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // Raw debug/state (optional)
              ExpansionTile(
                title: const Text('Account details'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SelectableText(staff?.toString() ?? 'No user data', style: theme.textTheme.bodySmall),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
