import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/event_provider.dart';

class UpdatesList extends ConsumerWidget {
  const UpdatesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updatesAsync = ref.watch(eventUpdatesProvider);

    return updatesAsync.when(
      data: (updates) {
        if (updates.isEmpty) {
          return const Center(child: Text('No updates for registered events.'));
        }
        return ListView.separated(
          itemCount: updates.length,
          padding: const EdgeInsets.all(16),
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final update = updates[index];
            return ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.orangeAccent,
                child: Icon(Icons.notifications, color: Colors.white),
              ),
              title: Text(
                update.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(update.description),
                  const SizedBox(height: 4),
                  Text(
                    'Posted on: ${update.timestamp.toString().split('.')[0]}',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
