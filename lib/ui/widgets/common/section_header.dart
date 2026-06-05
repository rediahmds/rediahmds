import 'package:flutter/material.dart';
import 'scroll_reveal.dart';

/// Consistent section heading with entrance animation.
/// Displays an icon badge + title using M3 headlineSmall,
/// with a decorative accent line that slides in from the left.
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

    return ScrollReveal(
      slideOffset: const Offset(-30, 0),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 28),
        child: Row(
          children: [
            // Decorative accent bar
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [cs.primary, cs.tertiary],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Icon(icon, size: 24, color: cs.onPrimaryContainer),
            ),
            const SizedBox(width: 16),
            Text(title, style: tt.headlineSmall),
          ],
        ),
      ),
    );
  }
}
