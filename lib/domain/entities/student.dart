import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final String name;
  final String id; // Student ID / Roll Number
  final String program; // e.g., B.Tech
  final String department; // e.g., CSM
  final String batch; // e.g., 2024 – 2027
  final String college; // e.g., S.V. College of Engineering
  final String? photoUrl; // For now, we'll use asset paths or null
  final String barcodeValue;

  const Student({
    required this.name,
    required this.id,
    required this.program,
    required this.department,
    required this.batch,
    required this.college,
    this.photoUrl,
    required this.barcodeValue,
  });

  @override
  List<Object?> get props => [
    name,
    id,
    program,
    department,
    batch,
    college,
    photoUrl,
    barcodeValue,
  ];
}
