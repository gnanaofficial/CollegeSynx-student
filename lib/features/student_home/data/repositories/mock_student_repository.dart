import '../../domain/entities/case.dart';
import '../../../events/domain/entities/event.dart';
import '../../domain/entities/student_stats.dart';
import '../../domain/repositories/student_repository.dart';
import '../../../../domain/entities/student.dart';

class MockStudentRepository implements StudentRepository {
  @override
  Future<StudentStats> getStudentStats() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return StudentStats(
      earnedCredits: 85,
      totalCredits: 160,
      degreeCompletionPercent: 0.53,
      currentCgpa: 8.4,
      isCgpaUp: true,
      attendancePercent: 0.92,
      attendanceStatus: 'Good',
    );
  }

  @override
  Future<List<Case>> getOngoingCases() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Case(
        id: '1',
        title: 'On-Duty Request',
        description: 'Symposium - CollegeSynx Tech Day',
        status: CaseStatus.pending,
        date: DateTime.now(), // Today
      ),
      Case(
        id: '2',
        title: 'Hostel Out-Pass',
        description: 'Weekend Home Visit',
        status: CaseStatus.approved,
        date: DateTime(2023, 10, 20),
      ),
      Case(
        id: '3',
        title: 'Extra Credit Claim',
        description: 'Insufficient documentation',
        status: CaseStatus.rejected,
        date: DateTime(2023, 10, 15),
      ),
    ];
  }

  @override
  Future<List<Event>> getUpcomingEvents() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Event(
        id: '1',
        title: 'Mid-Semester Exams',
        description:
            'Mathematics III, Computer Networks, and 3 other subjects scheduled.',
        date: DateTime(2023, 10, 24),
        timeRange: '09:00 AM - 12:00 PM',
        location: 'Exam Hall B',
        isRegistered: true,
      ),
      Event(
        id: '2',
        title: 'Guest Lecture: AI in Fintech',
        description:
            'Speaker: Dr. S. Rao from Standard Chartered. Mandatory for Year 3.',
        date: DateTime(2023, 11, 02),
        timeRange: '02:00 PM - 04:00 PM',
        location: 'Auditorium',
        isRegistered: false,
      ),
    ];
  }

  @override
  Future<Student?> getStudentByBarcode(String barcode) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data borrowed from global mock repository
    final List<Student> mockStudents = [
      const Student(
        name: 'Kalapati Gnana Sekhar',
        id: '24BFA33L12',
        program: 'B.Tech',
        department: 'CSM',
        batch: '2024 – 2027',
        college: 'S.V. College of Engineering',
        barcodeValue: '24BFA33L12',
        photoUrl: 'assets/images/studentavatar.png',
      ),
      const Student(
        name: 'Anangi Vignesh Kumar',
        id: '24BFA33L04',
        program: 'B.Tech',
        department: 'CSM',
        batch: '2024 – 2027',
        college: 'S.V. College of Engineering',
        barcodeValue: '24BFA33L04',
        photoUrl: 'assets/images/studentavatar.png',
      ),
    ];

    try {
      return mockStudents.firstWhere(
        (student) => student.barcodeValue == barcode,
      );
    } catch (e) {
      return null;
    }
  }
}
