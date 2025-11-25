import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';

class BarcodeScanScreen extends StatefulWidget {
  const BarcodeScanScreen({super.key});

  @override
  State<BarcodeScanScreen> createState() => _BarcodeScanScreenState();
}

class _BarcodeScanScreenState extends State<BarcodeScanScreen> {
  bool _handled = false;

  @override
  Widget build(BuildContext context) {
    return AiBarcodeScanner(
      onDetect: (capture) {
        if (_handled) return;      // ← PREVENT MULTIPLE POP
        _handled = true;

        final code = capture.barcodes.first.rawValue;

         Navigator.pop(context, code);

      },
    );
  }
}
