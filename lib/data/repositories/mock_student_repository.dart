import '../../domain/entities/student.dart';
import '../../domain/repositories/student_repository.dart';

class MockStudentRepository implements StudentRepository {
  // Simulate network delay
  final Duration _delay = const Duration(seconds: 1);

  final List<Student> _mockStudents = [
    const Student(
      name: 'Kalapati Gnana Sekhar',
      id: '24BFA33L12',
      program: 'B.Tech',
      department: 'CSM',
      batch: '2024 – 2027',
      college: 'S.V. College of Engineering',
      barcodeValue: '24BFA33L12',
      // In a real app, this would be a URL or local asset path
      photoUrl: 'assets/images/student_placeholder.png',
    ),
    const Student(
      name: 'Anangi Vignesh Kumar',
      id: '24BFA33L04',
      program: 'B.Tech',
      department: 'CSM',
      batch: '2024 – 2027',
      college: 'S.V. College of Engineering',
      barcodeValue: '24BFA33L04',
      // In a real app, this would be a URL or local asset path
      photoUrl: 'assets/images/student_placeholder.png',
    ),
  ];

  @override
  Future<Student?> getStudentByBarcode(String barcode) async {
    await Future.delayed(_delay);
    try {
      return _mockStudents.firstWhere(
        (student) => student.barcodeValue == barcode,
      );
    } catch (e) {
      return null;
    }
  }
}
