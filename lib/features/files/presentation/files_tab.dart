import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FilesTab extends StatelessWidget {
  const FilesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F7FA),
      child: Column(
        children: [
          
          Container(
            color: Colors.grey.shade200,
            height: 1,
          ),
          
          // Actions Grid
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: const [
                _InfoCard(
                  title: 'Register File',
                  description: 'Create and register new office files',
                  icon: Icons.note_add_rounded,
                  routeName: '/files/register',
                  color: Color(0xFF4F46E5),
                ),
                SizedBox(height: 12),
                _InfoCard(
                  title: 'Assign File',
                  description: 'Assign files to shelves via QR',
                  icon: Icons.qr_code_2_rounded,
                  routeName: '/files/assign',
                  color: Color(0xFF10B981),
                ),
                SizedBox(height: 12),
                // _InfoCard(
                //   title: 'Get File',
                //   description: 'Fetch file details by scanning',
                //   icon: Icons.qr_code_scanner_rounded,
                //   routeName: '/files/get',
                //   color: Color(0xFF7C3AED),
                // ),
               
                _InfoCard(
                  title: 'All Files',
                  description: 'View and search all registered files',
                  icon: Icons.list_alt_rounded,
                  routeName: '/files/all',
                  color: Color(0xFFF59E0B),
                ),
              ],
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
    required this.description,
    required this.icon,
    required this.routeName,
    required this.color,
  });

  final String title;
  final String description;
  final IconData icon;
  final String routeName;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push(routeName),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}