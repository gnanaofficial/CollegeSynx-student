class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String timeRange; // e.g. "09:00 AM - 12:00 PM"
  final String location;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.timeRange,
    required this.location,
  });
}
