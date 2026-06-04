import 'package:flutter/material.dart';
import 'package:portofolio/models/resume_model.dart';
import '../common/section_header.dart';

/// Skills section using a single M3 **Filled** Card with category groups.
class SkillsSection extends StatelessWidget {
  final SkillsModel skills;

  const SkillsSection({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Skills', icon: Icons.code_outlined),
        Card.filled(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkillCategory(
                  title: 'Languages',
                  icon: Icons.language,
                  skills: skills.languages,
                ),
                const SizedBox(height: 24),
                _SkillCategory(
                  title: 'Backend & Cloud',
                  icon: Icons.cloud_outlined,
                  skills: skills.backendCloud,
                ),
                const SizedBox(height: 24),
                _SkillCategory(
                  title: 'Mobile',
                  icon: Icons.smartphone,
                  skills: skills.mobile,
                ),
                const SizedBox(height: 24),
                _SkillCategory(
                  title: 'DevOps & Tools',
                  icon: Icons.build_outlined,
                  skills: skills.devopsTools,
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

  const _SkillCategory({
    required this.title,
    required this.icon,
    required this.skills,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: cs.secondary),
            const SizedBox(width: 8),
            Text(title, style: tt.titleSmall),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills
              .map((skill) => Chip(label: Text(skill)))
              .toList(),
        ),
      ],
    );
  }
}
