import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/student_repository.dart';
import '../../domain/entities/case.dart';
import '../../domain/entities/student_stats.dart';
import '../../../events/domain/entities/event.dart';
import '../../../../domain/entities/student.dart';

class FirestoreStudentRepository implements StudentRepository {
  final FirebaseFirestore _firestore;
  final String _studentId;

  FirestoreStudentRepository({
    required String studentId,
    FirebaseFirestore? firestore,
  }) : _studentId = studentId,
       _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Case>> getOngoingCases() async {
    print('DEBUG: Fetching cases for studentId: $_studentId');
    try {
      final querySnapshot = await _firestore
          .collection('discipline_cases')
          .where('studentId', isEqualTo: _studentId)
          .get();

      print('DEBUG: Found ${querySnapshot.docs.length} cases');

      return querySnapshot.docs.map((doc) {
        return Case.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      // Return empty list or rethrow depending on error handling strategy
      // For now, return empty to avoid breaking UI
      return [];
    }
  }

  // Keeping other methods as Mock or unimplemented for now as requested task handles Cases only
  // But to satisfy interface, we might need to implement or stub them.
  // Ideally, other parts would also move to Firestore, but sticking to scope.
  // Using Mock logic or empty returns for others to prevent errors if called.

  @override
  Future<StudentStats> getStudentStats() async {
    try {
      final querySnapshot = await _firestore
          .collection('discipline_cases')
          .where('studentId', isEqualTo: _studentId)
          .get();

      int totalDeductions = 0;
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final points = data['pointsDeducted'];
        if (points is int) {
          totalDeductions += points;
        } else if (points is String) {
          totalDeductions += int.tryParse(points) ?? 0;
        }
      }

      int totalCredits = 100;
      int earnedCredits = totalCredits - totalDeductions;

      // Placeholder values for other stats as they are not yet in Firestore
      return StudentStats(
        earnedCredits: earnedCredits,
        totalCredits: totalCredits,
        degreeCompletionPercent: 0.75, // Static for now
        currentCgpa: 8.5, // Static for now
        isCgpaUp: true,
        attendancePercent: 0.90, // Static for now
        attendanceStatus: 'On Track',
      );
    } catch (e) {
      // Fallback
      return StudentStats(
        earnedCredits: 100,
        totalCredits: 100,
        degreeCompletionPercent: 0,
        currentCgpa: 0,
        isCgpaUp: false,
        attendancePercent: 0,
        attendanceStatus: 'Error',
      );
    }
  }

  @override
  Future<List<Event>> getUpcomingEvents() async {
    // Placeholder
    return [];
  }

  @override
  Future<Student?> getStudentByBarcode(String barcode) async {
    // Placeholder
    return null;
  }
}
