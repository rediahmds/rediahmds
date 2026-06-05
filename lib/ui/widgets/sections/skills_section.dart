import 'package:flutter/material.dart';
import 'package:portofolio/models/resume_model.dart';
import '../common/section_header.dart';
import '../common/scroll_reveal.dart';
import '../common/hover_surface.dart' show ExpressiveShapes;

/// Skills section using layered surface containers for visual depth.
/// Each skill category gets its own tonal surface level to create
/// the "surface blending" effect requested.
class SkillsSection extends StatelessWidget {
  final SkillsModel skills;
  const SkillsSection({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Skills', icon: Icons.code_outlined),
        ScrollReveal(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cs.surfaceContainerLowest,
                  cs.surfaceContainerLow,
                  cs.surfaceContainer,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              borderRadius: ExpressiveShapes.asymmetricA,
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkillCategory(
                  title: 'Languages',
                  icon: Icons.language,
                  skills: skills.languages,
                  surfaceColor: cs.primaryContainer.withValues(alpha: 0.3),
                  chipColor: cs.primaryContainer,
                  onChipColor: cs.onPrimaryContainer,
                  delay: const Duration(milliseconds: 0),
                ),
                const SizedBox(height: 28),
                _SkillCategory(
                  title: 'Backend & Cloud',
                  icon: Icons.cloud_outlined,
                  skills: skills.backendCloud,
                  surfaceColor: cs.secondaryContainer.withValues(alpha: 0.3),
                  chipColor: cs.secondaryContainer,
                  onChipColor: cs.onSecondaryContainer,
                  delay: const Duration(milliseconds: 100),
                ),
                const SizedBox(height: 28),
                _SkillCategory(
                  title: 'Mobile',
                  icon: Icons.smartphone,
                  skills: skills.mobile,
                  surfaceColor: cs.tertiaryContainer.withValues(alpha: 0.3),
                  chipColor: cs.tertiaryContainer,
                  onChipColor: cs.onTertiaryContainer,
                  delay: const Duration(milliseconds: 200),
                ),
                const SizedBox(height: 28),
                _SkillCategory(
                  title: 'DevOps & Tools',
                  icon: Icons.build_outlined,
                  skills: skills.devopsTools,
                  surfaceColor: cs.surfaceContainerHighest.withValues(alpha: 0.5),
                  chipColor: cs.surfaceContainerHighest,
                  onChipColor: cs.onSurface,
                  delay: const Duration(milliseconds: 300),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SkillCategory extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> skills;
  final Color surfaceColor;
  final Color chipColor;
  final Color onChipColor;
  final Duration delay;

  const _SkillCategory({
    required this.title,
    required this.icon,
    required this.skills,
    required this.surfaceColor,
    required this.chipColor,
    required this.onChipColor,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return ScrollReveal(
      delay: delay,
      slideOffset: const Offset(20, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: onChipColor),
                const SizedBox(width: 8),
                Text(title, style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((skill) {
                return Chip(
                  label: Text(skill),
                  backgroundColor: chipColor,
                  labelStyle: TextStyle(
                    color: onChipColor,
                    fontWeight: FontWeight.w500,
                  ),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
