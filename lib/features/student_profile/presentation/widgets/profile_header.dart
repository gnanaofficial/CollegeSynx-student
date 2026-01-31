import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../domain/entities/student.dart';

class ProfileHeader extends StatelessWidget {
  final Student? student;
  const ProfileHeader({super.key, this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 10),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar with shadow/border
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 44, // Slightly larger
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(3.0), // White border
                child: CircleAvatar(
                  radius: 41,
                  backgroundColor: Colors.grey.shade100,
                  backgroundImage: student?.photoUrl != null
                      ? AssetImage(student!.photoUrl!) as ImageProvider
                      : const NetworkImage('https://i.pravatar.cc/150?img=11'),
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),

          // Info Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name Handling: Use FittedBox to prevent overflow/wrapping if too long,
                // or just allow it to scale down.
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    student?.name ?? 'Loading...',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ID: ${student?.id ?? '...'}',
                  style: GoogleFonts.sourceCodePro(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  [
                    student?.program ?? '',
                    student?.department ?? '',
                    // student?.batch != null ? 'Batch ${student!.batch}' : '' // Optional: Batch here?
                  ].where((s) => s.isNotEmpty).join(' '),
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  student?.batch != null ? 'Batch ${student!.batch}' : '',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
