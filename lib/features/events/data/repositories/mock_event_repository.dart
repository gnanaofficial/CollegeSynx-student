import '../../domain/entities/event.dart';
import '../../domain/entities/event_update.dart';

class MockEventRepository {
  final List<Event> _events = [
    Event(
      id: 'e1',
      title: 'CollegeSynx Tech Summit',
      description:
          'A grand showcase of latest technologies and student projects.',
      date: DateTime.now().add(const Duration(days: 5)),
      timeRange: '09:00 AM - 04:00 PM',
      location: 'Main Auditorium',
      isRegistered: false,
    ),
    Event(
      id: 'e2',
      title: 'Cultural Fest 2026',
      description: 'Music, Dance, and Art competitions for all students.',
      date: DateTime.now().add(const Duration(days: 12)),
      timeRange: '10:00 AM - 08:00 PM',
      location: 'Open Air Theatre',
      isRegistered: true,
    ),
    Event(
      id: 'e3',
      title: 'AI Workshop',
      description: 'Hands-on workshop on Generative AI tools.',
      date: DateTime.now().add(const Duration(days: 2)),
      timeRange: '02:00 PM - 05:00 PM',
      location: 'Computer Lab 3',
      isRegistered: false,
    ),
  ];

  final List<EventUpdate> _updates = [
    EventUpdate(
      id: 'u1',
      eventId: 'e2',
      title: 'Auditions Schedule',
      description: 'Auditions for dance competitions will start at 10 AM.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    EventUpdate(
      id: 'u2',
      eventId: 'e2',
      title: 'Guest Artist Announced',
      description: 'We are thrilled to announce DJ Snake as our headliner!',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  Future<List<Event>> getAllEvents() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _events;
  }

  Future<List<EventUpdate>> getUpdatesForRegisteredEvents() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Filter updates for events where isRegistered is true
    // For mock, we assume 'e2' is registered, so we return its updates.
    // In real app, we would filter based on _events state.
    final registeredEventIds = _events
        .where((e) => e.isRegistered)
        .map((e) => e.id)
        .toSet();
    return _updates
        .where((u) => registeredEventIds.contains(u.eventId))
        .toList();
  }

  Future<void> toggleRegistration(String eventId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      final event = _events[index];
      _events[index] = event.copyWith(isRegistered: !event.isRegistered);
    }
  }
}
