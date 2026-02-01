import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../../../auth/state/auth_provider.dart';
import '../../state/student_provider.dart';
import '../../../student_home/presentation/providers/student_provider.dart';
import '../../../student_home/domain/entities/student_stats.dart'; // Import this // From student_home
import '../widgets/profile_header.dart';
// import '../widgets/profile_settings_module.dart'; // Inline or separate

class StudentProfileScreen extends ConsumerStatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  ConsumerState<StudentProfileScreen> createState() =>
      _StudentProfileScreenState();
}

class _StudentProfileScreenState extends ConsumerState<StudentProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // Separate animations for sequential entrance
  final List<Animation<Offset>> _slideAnimations = [];
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    // Create a sequence of slide animations
    // Items: 0:Stats, 1:Barcode, 2:Actions
    for (int i = 0; i < 4; i++) {
      double start = 0.1 + (i * 0.1);
      double end = start + 0.5;
      if (end > 1.0) end = 1.0;

      _slideAnimations.add(
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(start, end, curve: Curves.easeOutCubic),
          ),
        ),
      );
    }

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentAsync = ref.watch(currentStudentProvider);
    final statsAsync = ref.watch(
      studentStatsProvider,
    ); // Fetch stats for credits

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9), // Slight tint
      body: studentAsync.when(
        data: (student) {
          if (student == null) {
            return const Center(child: Text('Student Not Found'));
          }
          return Column(
            children: [
              // Sticky-ish Header
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    // Update main student data and stats
                    await Future.wait([
                      ref.refresh(currentStudentProvider.future),
                      ref.refresh(studentStatsProvider.future),
                    ]);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // Header
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: ProfileHeader(student: student),
                        ),

                        const SizedBox(height: 24),

                        // Stats / Info Section
                        SlideTransition(
                          position: _slideAnimations[0],
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: _buildInfoSection(context, statsAsync),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Barcode Section
                        SlideTransition(
                          position: _slideAnimations[1],
                          child: FadeTransition(
                            // Ensuring content fades in too
                            opacity: _fadeAnimation,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 32,
                                horizontal: 24,
                              ),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.05),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  BarcodeWidget(
                                    barcode: Barcode.code128(),
                                    data: student.barcodeValue,
                                    width: 220,
                                    height: 80,
                                    drawText: false,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Student ID: ${student.id}',
                                    style: GoogleFonts.sourceCodePro(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Settings / Actions
                        SlideTransition(
                          position: _slideAnimations[2],
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: _buildSettingsSection(context),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Sign Out Button
                        SlideTransition(
                          position: _slideAnimations[3],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            child: TextButton(
                              onPressed: () =>
                                  _showLogoutConfirmation(context, ref),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: Colors.red.withValues(alpha: 0.1),
                                  ),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.logout_rounded,
                                    color: Colors.redAccent,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Sign Out from App',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    AsyncValue<StudentStats> statsAsync,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: statsAsync.when(
        data: (stats) {
          final deducted = stats.totalCredits - stats.earnedCredits;
          return Column(
            children: [
              _buildListItem(
                icon: Icons.school_outlined,
                title: 'Credits Earned',
                value: '${stats.earnedCredits} / ${stats.totalCredits}',
                isFirst: true,
              ),
              const Divider(height: 1, indent: 60, endIndent: 20),
              _buildListItem(
                icon: Icons.remove_circle_outline,
                title: 'Points Deducted',
                value: '$deducted',
                valueColor: deducted > 0 ? Colors.red : Colors.green,
              ),
              const Divider(height: 1, indent: 60, endIndent: 20),
              _buildListItem(
                icon: Icons.access_time_rounded,
                title: 'Attendance',
                value: '${(stats.attendancePercent * 100).toInt()}%',
                valueColor: Colors.green,
              ),
              const Divider(height: 1, indent: 60, endIndent: 20),
              _buildListItem(
                icon: Icons.group_outlined,
                title: 'Memberships',
                value: 'GDG, SAC',
                hasArrow: true,
                onTap: () {},
                isLast: true,
              ),
            ],
          );
        },
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (e, s) => Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text('Error loading stats'),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
            child: Text(
              'Settings',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          _buildListItem(
            icon: Icons.wifi, // Placeholder icon
            title: 'App Settings',
            onTap: () {},
            hasArrow: true,
            isFirst:
                false, // Don't round top corners individually if we have a header
            customPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    String? value,
    Color? valueColor,
    bool hasArrow = false,
    VoidCallback? onTap,
    bool isFirst = false,
    bool isLast = false,
    EdgeInsets? customPadding,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(24) : Radius.zero,
          bottom: isLast ? const Radius.circular(24) : Radius.zero,
        ),
        child: Padding(
          padding:
              customPadding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.blue[700], size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              if (value != null)
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: valueColor ?? Colors.black87,
                  ),
                ),
              if (hasArrow)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).logout();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
