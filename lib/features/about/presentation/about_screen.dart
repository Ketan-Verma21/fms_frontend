import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).canPop()) return true;
        context.go('/dashboard');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('About')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Office File Management', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Version: 1.0.0'),
              SizedBox(height: 16),
              Text('This app helps manage files, shelves and staff.'),
            ],
          ),
        ),
      ),
    );
  }
}
