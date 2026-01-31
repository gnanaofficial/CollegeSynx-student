import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/student_repository.dart';
import '../../data/repositories/mock_student_repository.dart';
import '../../domain/entities/student_stats.dart';
import '../../domain/entities/case.dart';
import '../../domain/entities/event.dart';

// Repository Provider
final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return MockStudentRepository();
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

final upcomingEventsProvider = FutureProvider<List<Event>>((ref) async {
  final repository = ref.watch(studentRepositoryProvider);
  return repository.getUpcomingEvents();
});
