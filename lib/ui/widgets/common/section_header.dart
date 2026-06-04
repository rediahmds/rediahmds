import 'package:flutter/material.dart';

/// Consistent section heading used across all portfolio sections.
/// Displays an icon + title using M3 headlineSmall.
class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionHeader({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: cs.onPrimaryContainer),
          ),
          const SizedBox(width: 16),
          Text(title, style: tt.headlineSmall),
        ],
      ),
    );
  }
}
