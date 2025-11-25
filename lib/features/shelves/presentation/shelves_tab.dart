import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShelvesTab extends StatelessWidget {
  const ShelvesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          _tile(
            title: "Register Shelf",
            subtitle: "Create a new shelf before printing QR.",
            icon: Icons.add_box_outlined,
            onTap: () => context.push('/shelves/register'),
          ),
          _tile(
            title: "List Shelves",
            subtitle: "View all shelves with current file count.",
            icon: Icons.list_outlined,
            onTap: () => context.push('/shelves/list'),
          ),
        ],
      ),
    );
  }

  Widget _tile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          child: Icon(icon),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap,
      ),
    );
  }
}
