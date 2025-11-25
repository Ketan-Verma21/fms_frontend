import 'dart:convert';

import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/shelf_controller.dart';

class RegisterShelfScreen extends ConsumerStatefulWidget {
  const RegisterShelfScreen({super.key});

  @override
  ConsumerState<RegisterShelfScreen> createState() =>
      _RegisterShelfScreenState();
}

class _RegisterShelfScreenState extends ConsumerState<RegisterShelfScreen> {
  final TextEditingController shelfIdController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? detectedCode;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerShelfProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Shelf"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 TITLE
            Text(
              "Shelf Details",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            /// 🔹 Shelf ID TextField
            TextField(
              controller: shelfIdController,
              decoration: InputDecoration(
                labelText: "Shelf ID",
                hintText: "Scan barcode or type manually",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.qr_code_2),
              ),
            ),
            const SizedBox(height: 16),

            /// 🔹 Description TextField
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: "Description",
                hintText: "Write description (optional)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 24),

            /// 🔹 Live Scanned Data
            if (detectedCode != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Detected Barcode",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      detectedCode!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),

            const SizedBox(height: 24),

            /// 🔹 Scan Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await context.push<String>("/scan-barcode");

                  if (result != null) {
                    var gg= jsonDecode(result);
                    setState(() {
                      detectedCode = result;
                      shelfIdController.text = gg['shelf_id'];
                      descriptionController.text = gg['description'];
                    });
                  }
                },
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text("Scan Barcode"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 32),

            /// 🔹 Register Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.isLoading
                    ? null
                    : () async {
                  await ref
                      .read(registerShelfProvider.notifier)
                      .register(
                    shelfIdController.text.trim(),
                    descriptionController.text.trim(),
                  );

                  if (mounted && state.hasValue) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Shelf Registered Successfully")),
                    );
                    context.pop();
                  }
                },
                child: state.isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                  "Register Shelf",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
