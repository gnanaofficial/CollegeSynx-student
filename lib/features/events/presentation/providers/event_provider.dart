import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/mock_event_repository.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/event_update.dart';

final eventRepositoryProvider = Provider<MockEventRepository>((ref) {
  return MockEventRepository();
});

final eventsListProvider = FutureProvider.autoDispose<List<Event>>((ref) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getAllEvents();
});

final eventUpdatesProvider = FutureProvider.autoDispose<List<EventUpdate>>((
  ref,
) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getUpdatesForRegisteredEvents();
});

// A provider to handle toggle registration side-effect and refresh lists
class EventRegisterNotifier extends StateNotifier<AsyncValue<void>> {
  final MockEventRepository _repository;
  final Ref _ref;

  EventRegisterNotifier(this._repository, this._ref)
    : super(const AsyncData(null));

  Future<void> toggleRegistration(String eventId) async {
    state = const AsyncLoading();
    try {
      await _repository.toggleRegistration(eventId);
      state = const AsyncData(null);
      // Refresh the lists to reflect changes
      _ref.invalidate(eventsListProvider);
      _ref.invalidate(eventUpdatesProvider);
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
