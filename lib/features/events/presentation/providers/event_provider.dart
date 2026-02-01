import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/firestore_event_repository.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/event_update.dart';
import '../../../student_home/presentation/providers/student_provider.dart'; // For repo and events
import '../../../student_profile/state/student_provider.dart'; // For currentStudentProvider
import '../../../auth/state/auth_provider.dart';

// Use the repo provider from student_provider or define here?
// Reusing from student_provider to ensure consistent studentId.

final eventsListProvider = FutureProvider.autoDispose<List<Event>>((ref) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getAllEvents();
});

// Updates not yet implemented in Firestore repo, returning empty list or simple implementation later
final eventUpdatesProvider = FutureProvider.autoDispose<List<EventUpdate>>((
  ref,
) async {
  // Placeholder
  return [];
});

class EventRegisterNotifier extends StateNotifier<AsyncValue<void>> {
  final FirestoreEventRepository _repository;
  final Ref _ref;

  EventRegisterNotifier(this._repository, this._ref)
    : super(const AsyncData(null));

  Future<void> registerForEvent(Event event) async {
    state = const AsyncLoading();
    try {
      final studentAsync = _ref.read(currentStudentProvider);
      final student = studentAsync.value;

      if (student == null) {
        throw Exception("Student not found");
      }

      await _repository.registerForEvent(event, student);
      state = const AsyncData(null);
      // Refresh the lists to reflect changes (e.g. capacity updates)
      _ref.invalidate(eventsListProvider);

      // We might want to optimistic update isRegistered locally if we tracked it
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final eventRegisterProvider =
    StateNotifierProvider<EventRegisterNotifier, AsyncValue<void>>((ref) {
      final repository = ref.watch(eventRepositoryProvider);
      return EventRegisterNotifier(repository, ref);
    });
