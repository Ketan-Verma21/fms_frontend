import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/shelf_controller.dart';
import 'package:go_router/go_router.dart';

class ShelvesListScreen extends ConsumerWidget {
  const ShelvesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shelves = ref.watch(shelvesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("All Shelves")),
      body: shelves.when(
        data: (list) => ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, i) {
            final shelf = list[i];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(shelf.shelfId),
                subtitle: Text(shelf.description),
                trailing: Text("${shelf.files.length} files"),
                onTap: () {
                  context.push('/shelves/details/${shelf.shelfId}');
                },
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}
