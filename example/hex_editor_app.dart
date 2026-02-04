import 'dart:io';
import 'dart:typed_data';

import 'package:collect/collect.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const HexEditorApp());
}

class HexEditorApp extends StatelessWidget {
  const HexEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hex Editor',
      theme: ThemeData.dark(useMaterial3: true),
      home: const HexEditorPage(),
    );
  }
}

class HexEditorPage extends StatefulWidget {
  const HexEditorPage({super.key});

  @override
  State<HexEditorPage> createState() => _HexEditorPageState();
}

class _HexEditorPageState extends State<HexEditorPage> {
  Uint8List? _data;
  String? _fileName;
  String? _filePath;
  int? _fileSize;
  bool _isLoading = false;

  Future<void> _openFile() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final file = File(filePath);
        final bytes = await file.readAsBytes();

        setState(() {
          _data = bytes;
          _fileName = result.files.single.name;
          _filePath = filePath;
          _fileSize = bytes.length;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _closeFile() {
    setState(() {
      _data = null;
      _fileName = null;
      _filePath = null;
      _fileSize = null;
    });
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_fileName ?? 'Hex Editor'),
        actions: [
          if (_data != null)
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'File Info',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('File Information'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: $_fileName'),
                        const SizedBox(height: 8),
                        Text('Path: $_filePath'),
                        const SizedBox(height: 8),
                        Text('Size: ${_formatFileSize(_fileSize!)}'),
                        const SizedBox(height: 8),
                        Text('Bytes: $_fileSize'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            ),
          if (_data != null)
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Close File',
              onPressed: _closeFile,
            ),
          IconButton(
            icon: const Icon(Icons.folder_open),
            tooltip: 'Open File',
            onPressed: _isLoading ? null : _openFile,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading file...'),
          ],
        ),
      );
    }

    if (_data == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.file_open,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'No file opened',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Click the folder icon to open a file',
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _openFile,
              icon: const Icon(Icons.folder_open),
              label: const Text('Open File'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(
                    Icons.insert_drive_file,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _fileName!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_formatFileSize(_fileSize!)} • $_fileSize bytes',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: InteractiveHexViewer(
              data: _data!,
              bytesPerRow: 16,
              groupSize: 8,
              showInspector: true,
              inspectorWidth: 320,
            ),
          ),
        ],
      ),
    );
  }
}
