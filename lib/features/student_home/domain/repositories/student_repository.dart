import '../entities/student_stats.dart';
import '../entities/case.dart';
import '../../../events/domain/entities/event.dart';

import '../../../../domain/entities/student.dart';

abstract class StudentRepository {
  Future<StudentStats> getStudentStats();
  Future<List<Case>> getOngoingCases();
  Future<List<Event>> getUpcomingEvents();
  Future<Student?> getStudentByBarcode(String barcode);
}
