import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String timeRange; // e.g. "09:00 AM - 12:00 PM"
  final String location;
  final bool isRegistered;
  final int capacity;
  final int registeredCount;
  final String status; // "published"
  final double fee;
  final List<String> allowedDepartments;
  final List<String> allowedYears;
  final DateTime? registrationEndDate;
  final String type;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.timeRange,
    required this.location,
    this.isRegistered = false,
    this.capacity = 0,
    this.registeredCount = 0,
    this.status = 'published',
    this.fee = 0.0,
    this.allowedDepartments = const [],
    this.allowedYears = const [],
    this.registrationEndDate,
    this.type = 'general',
  });

  factory Event.fromFirestore(Map<String, dynamic> data, String id) {
    // Parsing date: 'startDate' (String) or 'date' or timestamps
    // Screenshot shows 'startDate': "2026-02-02", 'startTime': "09:00"
    DateTime eventDate = DateTime.now();
    if (data['startDate'] != null) {
      eventDate = DateTime.tryParse(data['startDate']) ?? DateTime.now();
    }

    final startTime = data['startTime'] ?? '';
    final endTime = data['endTime'] ?? '';
    final timeRange = '$startTime - $endTime';

    return Event(
      id: id,
      title: data['name'] ?? data['title'] ?? 'Untitled Event',
      description: data['description'] ?? '',
      date: eventDate,
      timeRange: timeRange,
      location: data['venue'] ?? '',
      capacity: (data['capacity'] ?? 0) as int,
      registeredCount: (data['registeredCount'] ?? 0) as int,
      status: data['status'] ?? 'published',
      fee: (data['fee'] ?? 0).toDouble(),
      allowedDepartments: List<String>.from(data['allowedDepartments'] ?? []),
      allowedYears: List<String>.from(data['allowedYears'] ?? []),
      registrationEndDate: data['registrationEndDate'] != null
          ? DateTime.tryParse(data['registrationEndDate'])
          : null,
      type: data['type'] ?? 'general',
    );
  }

  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? timeRange,
    String? location,
    bool? isRegistered,
    int? capacity,
    int? registeredCount,
    String? status,
    double? fee,
    List<String>? allowedDepartments,
    List<String>? allowedYears,
    DateTime? registrationEndDate,
    String? type,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      timeRange: timeRange ?? this.timeRange,
      location: location ?? this.location,
      isRegistered: isRegistered ?? this.isRegistered,
      capacity: capacity ?? this.capacity,
      registeredCount: registeredCount ?? this.registeredCount,
      status: status ?? this.status,
      fee: fee ?? this.fee,
      allowedDepartments: allowedDepartments ?? this.allowedDepartments,
      allowedYears: allowedYears ?? this.allowedYears,
      registrationEndDate: registrationEndDate ?? this.registrationEndDate,
      type: type ?? this.type,
    );
  }
}
