import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/role_config.dart';
import '../../auth/state/auth_provider.dart';
import '../../auth/state/auth_state.dart';
import '../../student_home/presentation/providers/student_provider.dart';
import '../../../domain/entities/student.dart';

final currentStudentProvider = FutureProvider<Student?>((ref) async {
  final authState = ref.watch(authProvider);
  final studentRepository = ref.watch(studentRepositoryProvider);

  if (authState.status == AuthStatus.authenticated &&
      authState.user != null &&
      authState.user!.role == UserRole.student) {
    // The instructions state: "Barcode value = logged-in student’s ID"
    // and "Use this ID to fetch student data from mock_student_repository.dart"
    return await studentRepository.getStudentByBarcode(authState.user!.id);
  }

  return null;
});
