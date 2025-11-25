import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FilesTab extends StatelessWidget {
  const FilesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return _InfoGrid(
      title: 'Files',
      description:
      'Manage office files: register, assign to shelves, fetch by QR, and view all.',
      actions: const [
        _InfoCard(
          title: 'Register File',
          subtitle: 'POST /files/',
          icon: Icons.note_add_outlined,
          routeName: '/files/register',
        ),
        _InfoCard(
          title: 'Assign File',
          subtitle: 'POST /files/assign',
          icon: Icons.swap_horiz_outlined,
          routeName: '/files/assign',
        ),
        _InfoCard(
          title: 'Get File',
          subtitle: 'GET /files/:id',
          icon: Icons.qr_code_scanner_outlined,
          routeName: '/files/get',
        ),
        _InfoCard(
          title: 'All Files',
          subtitle: 'GET /files',
          icon: Icons.list_alt_outlined,
          routeName: '/files/all',
        ),
      ],
    );
  }
}
class _InfoGrid extends StatelessWidget {
  const _InfoGrid({
    required this.title,
    required this.description,
    required this.actions,
  });

  final String title;
  final String description;
  final List<_InfoCard> actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                return actions[index];
              },

            ),
          ),
        ],
      ),
    );
  }
}
class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.routeName,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.push(routeName),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                child: Icon(icon),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
