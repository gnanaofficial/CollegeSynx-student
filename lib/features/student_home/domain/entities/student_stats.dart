class StudentStats {
  final int earnedCredits;
  final int totalCredits;
  final double degreeCompletionPercent;
  final double currentCgpa;
  final bool isCgpaUp;
  final double attendancePercent;
  final String attendanceStatus;

  StudentStats({
    required this.earnedCredits,
    required this.totalCredits,
    required this.degreeCompletionPercent,
    required this.currentCgpa,
    required this.isCgpaUp,
    required this.attendancePercent,
    required this.attendanceStatus,
  });
}
