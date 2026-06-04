import 'package:flutter/material.dart';
import 'package:portofolio/models/resume_model.dart';
import '../common/section_header.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Projects section using M3 **Outlined** Card for browsable grid items.
/// Adapts between 2-column (desktop) and 1-column (mobile) layouts.
class ProjectsSection extends StatelessWidget {
  final List<ProjectModel> projects;

  const ProjectsSection({super.key, required this.projects});

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Projects',
          icon: Icons.rocket_launch_outlined,
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 800;
            const spacing = 16.0;
            final crossAxisCount = isDesktop ? 2 : 1;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: projects.map((project) {
                final width = isDesktop
                    ? (constraints.maxWidth - spacing) / crossAxisCount
                    : constraints.maxWidth;
                return SizedBox(
                  width: width,
                  child: _ProjectCard(
                    project: project,
                    onGitHub: () => _launchUrl(project.github),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onGitHub;

  const _ProjectCard({
    required this.project,
    required this.onGitHub,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Top row: folder icon + GitHub button ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.folder_outlined,
                    size: 24,
                    color: cs.onPrimaryContainer,
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: onGitHub,
                  icon: SvgPicture.asset(
                    'assets/icons/github.svg',
                    width: 18,
                    height: 18,
                    colorFilter: ColorFilter.mode(
                      cs.onSecondaryContainer,
                      BlendMode.srcIn,
                    ),
                  ),
                  tooltip: 'View Source',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- Title + period ---
            Text(project.name, style: tt.titleMedium),
            const SizedBox(height: 4),
            Text(
              project.period,
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 16),

            // --- Bullets ---
            ...project.bullets.map(
              (bullet) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Icon(
                        Icons.arrow_right_rounded,
                        size: 20,
                        color: cs.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(bullet, style: tt.bodyMedium),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
