import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/student_repository.dart';
import '../../../auth/state/auth_provider.dart';
import '../../data/repositories/firestore_student_repository.dart';
import '../../domain/entities/student_stats.dart';
import '../../domain/entities/case.dart';
import '../../../events/domain/entities/event.dart';
import '../../../events/data/repositories/firestore_event_repository.dart';

// Repository Provider
final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  final authState = ref.watch(authProvider);
  // DEBUG: Fallback to '24BFA33L12' if user is null for testing if requested
  final studentId = authState.user?.id ?? '24BFA33L12';
  print(
    'DEBUG: StudentProvider updating repository with studentId: $studentId',
  );
  return FirestoreStudentRepository(studentId: studentId);
});

// Use FutureProvider for async data fetching

final studentStatsProvider = FutureProvider<StudentStats>((ref) async {
  final repository = ref.watch(studentRepositoryProvider);
  return repository.getStudentStats();
});

final ongoingCasesProvider = FutureProvider<List<Case>>((ref) async {
  final repository = ref.watch(studentRepositoryProvider);
  return repository.getOngoingCases();
});

// Event Repository Provider
final eventRepositoryProvider = Provider<FirestoreEventRepository>((ref) {
  return FirestoreEventRepository();
});

final upcomingEventsProvider = FutureProvider<List<Event>>((ref) async {
  // Use independent Event Repository
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getAllEvents();
});
