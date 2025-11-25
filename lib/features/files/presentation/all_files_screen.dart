import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/file_controller.dart';
import '../models/file_model.dart';

class AllFilesScreen extends ConsumerStatefulWidget {
  const AllFilesScreen({super.key});

  @override
  ConsumerState<AllFilesScreen> createState() => _AllFilesScreenState();
}

class _AllFilesScreenState extends ConsumerState<AllFilesScreen> {
  List<FileModel> allFiles = [];
  List<FileModel> filteredFiles = [];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(filesControllerProvider);

    state.whenData((files) {
      // Load files once
      if (allFiles.isEmpty) {
        allFiles = files;
        filteredFiles = files;
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("All Files")),
      body: Column(
        children: [
          _SearchBar(onSearch: _filterFiles),
          Expanded(
            child: state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error: $e")),
              data: (_) => filteredFiles.isEmpty
                  ? const Center(child: Text("No files found"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredFiles.length,
                      itemBuilder: (_, i) => _FileTile(file: filteredFiles[i]),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _filterFiles(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredFiles = allFiles;
      } else {
        filteredFiles = allFiles.where((file) {
          final q = query.toLowerCase();
          return file.fileNo.toLowerCase().contains(q) ||
              file.description.toLowerCase().contains(q) ||
              file.placedBy.toLowerCase().contains(q);
        }).toList();
      }
    });
  }
}

class _FileTile extends StatelessWidget {
  final FileModel file;
  const _FileTile({required this.file});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.fileNo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    file.description,
                    style: const TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Shelf: ${file.shelfId ?? 'Not assigned'}",
                    style: const TextStyle(color: Colors.black54),
                  ),
                  Text(
                    "Placed by: ${file.placedBy ?? 'N/A'}",
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const _SearchBar({required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: "Search by file no, description, placed by...",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onChanged: onSearch,
      ),
    );
  }
}
