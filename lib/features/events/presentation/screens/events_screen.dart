import 'package:flutter/material.dart';
import '../widgets/events_list.dart';
import '../widgets/updates_list.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Every Event'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Events'),
              Tab(text: 'Updates'),
            ],
          ),
        ),
        body: const TabBarView(children: [EventsList(), UpdatesList()]),
      ),
    );
  }
}
