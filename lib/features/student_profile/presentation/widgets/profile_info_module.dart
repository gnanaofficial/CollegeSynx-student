import 'package:flutter/material.dart';

class ProfileInfoModule extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  final Color? valueColor;
  final VoidCallback? onTap;

  const ProfileInfoModule({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    this.valueColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue.shade700, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black,
            ),
          ),
          if (onTap != null)
            const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
        ],
      ),
    );
  }
}
