enum CaseStatus { pending, approved, rejected }

class Case {
  final String id;
  final String title;
  final String description;
  final CaseStatus status;
  final DateTime date;

  final String? category;
  final String? severity;
  final int? pointsDeducted;
  final String? reportedBy;

  Case({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.date,
    this.category,
    this.severity,
    this.pointsDeducted,
    this.reportedBy,
  });

  factory Case.fromFirestore(Map<String, dynamic> data, String id) {
    // Map 'subject' to title if present, else use default
    final title = data['subject'] as String? ?? 'Unknown Case';

    // Parse timestamp safely
    DateTime date;
    if (data['timestamp'] != null) {
      try {
        date = DateTime.parse(data['timestamp'] as String);
      } catch (e) {
        date = DateTime.now();
      }
    } else {
      date = DateTime.now();
    }

    // Determine status based on severity or other logic
    // For now defaulting to pending as status field isn't in screenshot
    // Or maybe map 'severity' to status color logic later
    return Case(
      id: id,
      title: title,
      description: data['description'] as String? ?? '',
      status: CaseStatus.pending, // Default for now
      date: date,
      category: data['category'] as String?,
      severity: data['severity'] as String?,
      pointsDeducted: data['pointsDeducted'] as int?,
      reportedBy: data['reportedBy'] as String?,
    );
  }
}
