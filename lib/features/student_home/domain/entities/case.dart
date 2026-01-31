enum CaseStatus { pending, approved, rejected }

class Case {
  final String id;
  final String title;
  final String description;
  final CaseStatus status;
  final DateTime date;

  Case({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.date,
  });
}
