import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../student_home/presentation/providers/student_provider.dart';
import '../../../student_home/domain/entities/case.dart';
import 'package:intl/intl.dart';

class CasesScreen extends ConsumerWidget {
  const CasesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final casesAsync = ref.watch(ongoingCasesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        title: Text(
          'My Cases',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list_rounded, color: Colors.black),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to New Case Screen
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'New Request',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return ref.refresh(ongoingCasesProvider);
        },
        child: casesAsync.when(
          data: (cases) {
            if (cases.isEmpty) {
              return Center(
                child: Text(
                  'No cases registered',
                  style: GoogleFonts.outfit(fontSize: 18, color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cases.length,
              itemBuilder: (context, index) {
                final caseItem = cases[index];
                return _buildCaseCard(caseItem);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildCaseCard(Case caseItem) {
    Color statusColor;
    switch (caseItem.status) {
      case CaseStatus.approved:
        statusColor = Colors.green;
        break;
      case CaseStatus.rejected:
        statusColor = Colors.red;
        break;
      case CaseStatus.pending:
      default:
        statusColor = Colors.orange;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  caseItem.status.name.toUpperCase(),
                  style: GoogleFonts.outfit(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                DateFormat('MMM dd, yyyy').format(caseItem.date),
                style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            caseItem.title,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          if (caseItem.category != null) ...[
            const SizedBox(height: 4),
            Text(
              'Category: ${caseItem.category}',
              style: GoogleFonts.outfit(color: Colors.grey[600], fontSize: 14),
            ),
          ],
          if (caseItem.pointsDeducted != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.remove_circle_outline,
                  size: 16,
                  color: Colors.red[400],
                ),
                const SizedBox(width: 4),
                Text(
                  '${caseItem.pointsDeducted} Credits Deducted',
                  style: GoogleFonts.outfit(
                    color: Colors.red[400],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
