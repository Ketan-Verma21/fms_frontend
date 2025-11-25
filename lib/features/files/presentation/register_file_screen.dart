import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/controllers/login_controller.dart';
import '../controllers/register_file_controller.dart';
import '../controllers/file_controller.dart';

class RegisterFileScreen extends ConsumerStatefulWidget {
  const RegisterFileScreen({super.key});

  @override
  ConsumerState<RegisterFileScreen> createState() =>
      _RegisterFileScreenState();
}

class _RegisterFileScreenState extends ConsumerState<RegisterFileScreen> {
  final TextEditingController fileIdController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? detectedCode; // For showing QR result

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerFileProvider);
    final user = ref.watch(loginControllerProvider).staff!.name;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register File"),
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
              "File Details",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            /// 🔹 File ID TextField
            TextField(
              controller: fileIdController,
              decoration: InputDecoration(
                labelText: "File ID",
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
                hintText: "Add a file description",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 16),


            /// 🔹 Live Scanned Data
            if (detectedCode != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Detected QR Code",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
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
                    /// Expecting format:
                    /// {"file_id":"F01","description":"XYZ file","placed_by":"John"}
                    final data = jsonDecode(result);

                    setState(() {
                      detectedCode = result;
                      fileIdController.text = data["file_id"] ?? "";
                      descriptionController.text = data["description"] ?? "";
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
                      .read(registerFileProvider.notifier)
                      .register(
                    fileNo: fileIdController.text.trim(),
                    description: descriptionController.text.trim(),
                    placedBy: user,
                  );

                  /// Refresh ALL files list
                  ref.read(filesControllerProvider.notifier).refresh();

                  if (mounted && state.hasValue) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("File Registered Successfully")),
                    );
                    context.pop();
                  }
                },
                child: state.isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                  "Register File",
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
