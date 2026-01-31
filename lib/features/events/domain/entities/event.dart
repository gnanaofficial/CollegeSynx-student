class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String timeRange; // e.g. "09:00 AM - 12:00 PM"
  final String location;
  final bool isRegistered;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.timeRange,
    required this.location,
    this.isRegistered = false,
  });

  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? timeRange,
    String? location,
    bool? isRegistered,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      timeRange: timeRange ?? this.timeRange,
      location: location ?? this.location,
      isRegistered: isRegistered ?? this.isRegistered,
    );
  }
}
