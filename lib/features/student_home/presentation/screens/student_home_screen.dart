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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StudentHeader(),
              const SizedBox(height: 10),
              statsAsync.when(
                data: (stats) => AcademicSummaryCard(stats: stats),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
              const SizedBox(height: 24),

              // Quick Actions Row (New Case, Timetable, Results) - Explicitly requested NOT to include "New Case" etc adjacent shortcuts in "STUDENT ROLE CONTEXT" section 1,
              // but the image shows them.
              // "⚠️ Do NOT include “New Case” or adjacent shortcut modules shown in the image" - OK, SKITTING per USER INSTRUCTION 1.
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
    );
  }
}
