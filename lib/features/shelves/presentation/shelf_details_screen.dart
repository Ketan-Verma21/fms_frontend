import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/shelf_controller.dart';

class ShelfDetailsScreen extends ConsumerWidget {
  final String shelfId;

  const ShelfDetailsScreen({required this.shelfId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shelfData = ref.watch(shelfDetailsProvider(shelfId));

    return Scaffold(
      appBar: AppBar(title: Text("Shelf: $shelfId")),
      body: shelfData.when(
        data: (shelf) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              shelf.shelfId,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(shelf.description),
            const Divider(height: 40),
            Text("Files", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ...shelf.files.map(
                  (file) => Card(
                child: ListTile(
                  title: Text(file.fileId),
                  subtitle: Text(file.description),
                ),
              ),
            )
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}
