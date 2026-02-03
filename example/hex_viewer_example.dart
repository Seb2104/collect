import 'dart:typed_data';

import 'package:collect/collect.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const HexViewerExampleApp());
}

class HexViewerExampleApp extends StatelessWidget {
  const HexViewerExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hex Viewer Example',
      theme: ThemeData.dark(useMaterial3: true),
      home: const HexViewerExamplePage(),
    );
  }
}

class HexViewerExamplePage extends StatelessWidget {
  const HexViewerExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example binary data - "Hello, World!" followed by some binary values
    final sampleData = Uint8List.fromList([
      0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x2C, 0x20, 0x57, // Hello, W
      0x6F, 0x72, 0x6C, 0x64, 0x21, 0x00, 0xFF, 0xFE, // orld!...
      0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, // ........
      0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x10, // ........
      0xDE, 0xAD, 0xBE, 0xEF, 0xCA, 0xFE, 0xBA, 0xBE, // ........
    ]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hex Viewer Examples'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Basic Hex Viewer',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade700),
              ),
              child: HexViewer(
                data: sampleData,
                bytesPerRow: 16,
                groupSize: 8,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Scrollable Hex Viewer with Header',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade700),
              ),
              child: ScrollableHexViewer(
                data: _generateLargeData(),
                bytesPerRow: 16,
                groupSize: 8,
                height: 400,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Custom Styling',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade700),
              ),
              child: HexViewer(
                data: sampleData,
                bytesPerRow: 8,
                groupSize: 4,
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  color: Colors.greenAccent,
                ),
                offsetStyle: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
                asciiStyle: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  color: Colors.cyanAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Generate larger sample data for the scrollable viewer
  Uint8List _generateLargeData() {
    final data = <int>[];
    for (int i = 0; i < 512; i++) {
      data.add(i % 256);
    }
    return Uint8List.fromList(data);
  }
}
