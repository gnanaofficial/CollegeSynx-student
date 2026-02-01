import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/role_config.dart';
import '../../auth/state/auth_provider.dart';
import '../../auth/state/auth_state.dart';
import '../../student_home/presentation/providers/student_provider.dart';
import '../../../domain/entities/student.dart';

final currentStudentProvider = FutureProvider<Student?>((ref) async {
  final authState = ref.watch(authProvider);
  final studentRepository = ref.watch(studentRepositoryProvider);

  /* 
  // STRICT AUTH CHECK - Commented out to allow fallback ID for testing as requested
  if (authState.status == AuthStatus.authenticated &&
      authState.user != null &&
      authState.user!.role == UserRole.student) {
    return await studentRepository.getStudentByBarcode(authState.user!.id);
  }
  return null;
  */

  // FALLBACK LOGIC MATCHING REPOSITORY
  final studentId = authState.user?.id ?? '24BFA33L12';
  return await studentRepository.getStudentByBarcode(studentId);
});
