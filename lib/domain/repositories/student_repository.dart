import '../entities/student.dart';

abstract class StudentRepository {
  /// Fetches student details based on the scanned barcode value.
  /// Returns null if no student is found for the given barcode.
  Future<Student?> getStudentByBarcode(String barcode);
}
