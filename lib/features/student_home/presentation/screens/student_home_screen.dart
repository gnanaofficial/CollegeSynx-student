import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/student_provider.dart';
import '../widgets/student_header.dart';
import '../widgets/academic_summary_card.dart';
import '../widgets/ongoing_cases_list.dart';
import '../widgets/upcoming_events_list.dart';

class StudentHomeScreen extends ConsumerWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(studentStatsProvider);
    final caseAsync = ref.watch(ongoingCasesProvider);
    final eventAsync = ref.watch(upcomingEventsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE), // Light background
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Refresh all providers and wait for them
            await Future.wait([
              ref.refresh(studentStatsProvider.future),
              ref.refresh(ongoingCasesProvider.future),
              ref.refresh(upcomingEventsProvider.future),
            ]);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StudentHeader(),
                const SizedBox(height: 10),
                statsAsync.when(
                  data: (stats) => AcademicSummaryCard(stats: stats),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),
                const SizedBox(height: 24),
                caseAsync.when(
                  data: (cases) => OngoingCasesList(cases: cases),
                  loading: () => const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, stack) => Text('Error cases: $err'),
                ),
                const SizedBox(height: 24),
                eventAsync.when(
                  data: (events) => UpcomingEventsList(events: events),
                  loading: () => const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, stack) => Text('Error events: $err'),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
