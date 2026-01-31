class EventUpdate {
  final String id;
  final String eventId;
  final String title;
  final String description;
  final DateTime timestamp;

  EventUpdate({
    required this.id,
    required this.eventId,
    required this.title,
    required this.description,
    required this.timestamp,
  });
}
