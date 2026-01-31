import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/event_provider.dart';

class EventsList extends ConsumerWidget {
  const EventsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsListProvider);

    return eventsAsync.when(
      data: (events) {
        if (events.isEmpty) {
          return const Center(child: Text('No events found.'));
        }
        return ListView.builder(
          itemCount: events.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final event = events[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          event.date.toString().split(
                            ' ',
                          )[0], // Simple date formatting
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (event.isRegistered)
                          const Chip(
                            label: Text(
                              'Registered',
                              style: TextStyle(fontSize: 10),
                            ),
                            visualDensity: VisualDensity.compact,
                            backgroundColor: Colors.greenAccent,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.description,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          event.timeRange,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          event.location,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ref
                              .read(eventRegisterProvider.notifier)
                              .toggleRegistration(event.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: event.isRegistered
                              ? Colors.grey
                              : Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          event.isRegistered ? 'Unregister' : 'Register Now',
                        ),
                      ),
                    ),
                  ],
                ),
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
