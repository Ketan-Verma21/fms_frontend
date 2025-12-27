import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/auth/controllers/login_controller.dart';
import 'package:go_router/go_router.dart';
import '../controllers/assign_file_controller.dart';

class AssignFileScreen extends ConsumerStatefulWidget {
  const AssignFileScreen({super.key});

  @override
  ConsumerState<AssignFileScreen> createState() => _AssignFileScreenState();
}

class _AssignFileScreenState extends ConsumerState<AssignFileScreen> {
  String? shelfId;
  String? fileId;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(assignFileProvider);
    var name= ref.watch(loginControllerProvider).staff!.name;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assign File to Shelf"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// ---------- SHELF STATUS BOX ----------
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Shelf QR", style: Theme.of(context).textTheme.titleMedium),
            ),
            const SizedBox(height: 8),
            _infoBox(label: "Shelf ID", value: shelfId ?? "Not scanned"),

            const SizedBox(height: 20),

            /// ---------- FILE STATUS BOX ----------
            Align(
              alignment: Alignment.centerLeft,
              child: Text("File QR", style: Theme.of(context).textTheme.titleMedium),
            ),
            const SizedBox(height: 8),
            _infoBox(label: "File ID", value: fileId ?? "Not scanned"),

            const Spacer(),

            /// ---------- BUTTONS ----------
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await context.push<String>("/scan-barcode");

                      if (result != null) {
                        final jsonMap = jsonDecode(result);
                        setState(() {
                          shelfId = jsonMap["shelf_id"];
                        });
                        ref.read(assignFileProvider.notifier).setShelf(shelfId!);
                      }
                    },
                    child: const Text("Scan Shelf"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await context.push<String>("/scan-barcode");

                      if (result != null) {
                        final jsonMap = jsonDecode(result);
                        setState(() {
                          fileId = jsonMap["file_id"];
                        });
                        ref.read(assignFileProvider.notifier).setFile(fileId!);
                      }
                    },
                    child: const Text("Scan File"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// ---------- ASSIGN BUTTON ----------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.isLoading
                    ? null
                    : () async {
                  await ref
                      .read(assignFileProvider.notifier)
                      .assignFile(name);

                  final latest = ref.read(assignFileProvider);
                  if (mounted && latest.hasValue && !latest.isLoading) {
                    _showSuccessPopup(context);

                    /// clear FILE only
                    setState(() {
                      fileId = null;
                    });

                    // reset success flag so subsequent assigns can show again
                    ref.read(assignFileProvider.notifier).resetStatus();
                  }
                },
                child: state.isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Assign File"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// SUCCESS POPUP
  void _showSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("Success"),
        content: const Text("File has been successfully assigned to the shelf."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  /// INFO BOX WIDGET
  Widget _infoBox({required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black38),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(value),
        ],
      ),
    );
  }
}
