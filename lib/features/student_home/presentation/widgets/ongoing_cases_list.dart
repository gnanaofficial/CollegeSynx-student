import 'package:flutter/material.dart';
import '../../domain/entities/case.dart';
import 'package:intl/intl.dart';

class OngoingCasesList extends StatelessWidget {
  final List<Case> cases;

  const OngoingCasesList({super.key, required this.cases});

  @override
  Widget build(BuildContext context) {
    if (cases.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ongoing Cases',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View All',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
        ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: cases.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final caseItem = cases[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getIconBackgroundColor(caseItem.status),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIcon(caseItem.status),
                      color: _getStatusColor(caseItem.status),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              caseItem.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  caseItem.status,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                caseItem.status.name.toUpperCase(),
                                style: TextStyle(
                                  color: _getStatusColor(caseItem.status),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              caseItem.description,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              _formatDate(caseItem.date),
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Color _getStatusColor(CaseStatus status) {
    switch (status) {
      case CaseStatus.pending:
        return Colors.orange;
      case CaseStatus.approved:
        return Colors.green;
      case CaseStatus.rejected:
        return Colors.red;
    }
  }

  Color _getIconBackgroundColor(CaseStatus status) {
    switch (status) {
      case CaseStatus.pending:
        return Colors.yellow.shade50;
      case CaseStatus.approved:
        return Colors.green.shade50;
      case CaseStatus.rejected:
        return Colors.red.shade50;
    }
  }

  IconData _getIcon(CaseStatus status) {
    switch (status) {
      case CaseStatus.pending:
        return Icons.access_time_filled;
      case CaseStatus.approved:
        return Icons.check_circle;
      case CaseStatus.rejected:
        return Icons.cancel;
    }
  }

  String _formatDate(DateTime date) {
    // Basic date formatting logic instead of full package if needed, but using logic similar to "Today" or "Oct 20"
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    }
    return DateFormat('MMM d').format(date);
  }
}
