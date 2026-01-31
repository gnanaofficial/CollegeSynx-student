import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class AcademicsScreen extends StatefulWidget {
  const AcademicsScreen({super.key});

  @override
  State<AcademicsScreen> createState() => _AcademicsScreenState();
}

class _AcademicsScreenState extends State<AcademicsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9), // Light grey bg
      appBar: AppBar(
        title: Text(
          'Academics',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Timetable'),
            Tab(text: 'Results'),
            Tab(text: 'Curriculum'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTimetableTab(),
          _buildResultsTab(),
          _buildCurriculumTab(),
        ],
      ),
    );
  }

  Widget _buildTimetableTab() {
    // Mock Timetable for "Today"
    final List<Map<String, String>> timeline = [
      {
        'time': '09:00 AM',
        'subject': 'Data Structures',
        'room': 'Lab 2',
        'status': 'Completed',
      },
      {
        'time': '10:00 AM',
        'subject': 'Mathematics III',
        'room': 'Class A-203',
        'status': 'Ongoing',
      },
      {
        'time': '11:00 AM',
        'subject': 'Computer Networks',
        'room': 'Class A-203',
        'status': 'Upcoming',
      },
      {
        'time': '01:00 PM',
        'subject': 'Lunch Break',
        'room': '-',
        'status': 'Upcoming',
      },
      {
        'time': '02:00 PM',
        'subject': 'Operating Systems',
        'room': 'Lab 1',
        'status': 'Upcoming',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: timeline.length,
      itemBuilder: (context, index) {
        final item = timeline[index];
        final isCompleted = item['status'] == 'Completed';
        final isOngoing = item['status'] == 'Ongoing';

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: isOngoing
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['time']!,
                    style: GoogleFonts.outfit(
                      color: isOngoing ? AppColors.primary : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 2,
                    height: 40,
                    color: isCompleted
                        ? Colors.green
                        : (isOngoing ? AppColors.primary : Colors.grey[300]),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['subject']!,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item['room']!,
                          style: GoogleFonts.outfit(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                const Icon(Icons.check_circle, color: Colors.green)
              else if (isOngoing)
                const Icon(Icons.play_circle_fill, color: AppColors.primary),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildResultCard('Semester 1', 'SGPA: 8.2', isExpanded: false),
        _buildResultCard('Semester 2', 'SGPA: 8.4', isExpanded: true),
        _buildResultCard('Semester 3', 'SGPA: --', isExpanded: false),
      ],
    );
  }

  Widget _buildResultCard(
    String title,
    String sgpa, {
    bool isExpanded = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: Colors.white,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          title: Text(
            title,
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          trailing: Text(
            sgpa,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          children: [
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildResultRow('Engineering Mathematics', 'A'),
                    _buildResultRow('Engineering Physics', 'A+'),
                    _buildResultRow('Programming in C', 'O'),
                  ],
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Click to view details'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String subject, String grade) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(subject, style: GoogleFonts.outfit(color: Colors.grey[700])),
          Text(
            grade,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurriculumTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.book_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Curriculum Syllabus PDF',
            style: GoogleFonts.outfit(color: Colors.grey),
          ),
          TextButton(onPressed: () {}, child: const Text('Download')),
        ],
      ),
    );
  }
}
