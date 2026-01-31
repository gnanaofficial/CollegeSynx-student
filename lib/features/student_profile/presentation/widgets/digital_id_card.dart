import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/student.dart';
import 'package:google_fonts/google_fonts.dart';

class DigitalIDCard extends StatelessWidget {
  final Student student;

  const DigitalIDCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 360),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Section
            _buildHeader(context),

            // Profile Image & content
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                // Spacer to push content down below the floating avatar
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                  child: Column(
                    children: [
                      _buildStudentDetails(context),
                      const SizedBox(height: 24),
                      Divider(color: Colors.grey.withValues(alpha: 0.2)),
                      const SizedBox(height: 16),
                      _buildInfoGrid(context),
                    ],
                  ),
                ),
                // Floating Avatar
                Positioned(top: -50, child: _buildAvatar()),
              ],
            ),

            // Footer / Barcode Section
            _buildBarcodeFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120, // Enough height for the red background behind avatar
      decoration: const BoxDecoration(
        color: AppColors.primary,
        // Optional: Add a pattern or gradient if desired
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            Color(0xFF8F74C2), // Lighter purple
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background Pattern (subtle dots or circles)
          Positioned(
            top: -20,
            left: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            right: -10,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),

          // College Name
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'SVCE',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'STUDENT ID CARD',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${student.batch} EDITION',
                      style: GoogleFonts.sourceCodePro(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4), // White border effect
      child: CircleAvatar(
        radius: 50,
        backgroundColor: AppColors.surface,
        backgroundImage: student.photoUrl != null
            ? AssetImage(
                student.photoUrl!,
              ) // Using AssetImage for now as per entity
            : const AssetImage('assets/images/studentavatar.png'),
      ),
    );
  }

  Widget _buildStudentDetails(BuildContext context) {
    return Column(
      children: [
        // Role Chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'STUDENT',
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          student.name.toUpperCase(),
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          student
              .id, // Email was in design, but ID is cleaner here; or use mock email
          textAlign: TextAlign.center,
          style: GoogleFonts.sourceCodePro(
            color: Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoItem(
            'LOCATION',
            'SIETK',
            isLeft: true,
          ), // Hardcoded as per mock or fetch? 'SIETK' from image
        ),
        Container(
          width: 1,
          height: 40,
          color: Colors.grey.withValues(alpha: 0.3),
        ),
        Expanded(
          child: _buildInfoItem(
            'DOB',
            'UNKNOWN',
            isLeft: false,
          ), // Missing in entity, using placeholder or batch
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value, {bool isLeft = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            color: Colors.grey[500],
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(
            color: const Color(0xFF333333),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBarcodeFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MEMBER ID',
                  style: GoogleFonts.sourceCodePro(
                    color: Colors.grey[600],
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  student.barcodeValue, // Show the raw value or ID
                  style: GoogleFonts.sourceCodePro(
                    color: const Color(0xFFFF5252), // Red accent text
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
          // QR/Barcode Container
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: BarcodeWidget(
              barcode: Barcode.qrCode(), // QR Code as per image
              data: student.barcodeValue,
              width: 60,
              height: 60,
              color: Colors.black,
              drawText: false,
            ),
          ),
        ],
      ),
    );
  }
}
