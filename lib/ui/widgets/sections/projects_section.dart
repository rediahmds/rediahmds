import 'package:flutter/material.dart';
import 'package:portofolio/models/resume_model.dart';
import '../common/section_header.dart';
import '../common/scroll_reveal.dart';
import '../common/hover_surface.dart' show HoverSurface, ExpressiveShapes;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Projects section with masonry-like layout (varied card spans)
/// and staggered hover-interactive cards.
class ProjectsSection extends StatelessWidget {
  final List<ProjectModel> projects;
  const ProjectsSection({super.key, required this.projects});

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Projects', icon: Icons.rocket_launch_outlined),
        LayoutBuilder(builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;
          const gap = 16.0;

          if (!isDesktop) {
            // Single column for mobile
            return Column(
              children: projects.asMap().entries.map((entry) {
                return ScrollReveal(
                  delay: Duration(milliseconds: 100 * entry.key),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: gap),
                    child: _ProjectCard(
                      project: entry.value,
                      onGitHub: () => _launchUrl(entry.value.github),
                      isFeature: false,
                      index: entry.key,
                    ),
                  ),
                );
              }).toList(),
            );
          }

          // Desktop: masonry-like — first card spans full width (feature),
          // rest are 2-column grid
          final feature = projects.isNotEmpty ? projects.first : null;
          final rest = projects.length > 1 ? projects.sublist(1) : <ProjectModel>[];
          final halfWidth = (constraints.maxWidth - gap) / 2;

          return Column(
            children: [
              // Feature card — full width, asymmetric shape
              if (feature != null)
                ScrollReveal(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: gap),
                    child: _ProjectCard(
                      project: feature,
                      onGitHub: () => _launchUrl(feature.github),
                      isFeature: true,
                      index: 0,
                    ),
                  ),
                ),
              // Grid cards
              Wrap(
                spacing: gap,
                runSpacing: gap,
                children: rest.asMap().entries.map((entry) {
                  return ScrollReveal(
                    delay: Duration(milliseconds: 100 * (entry.key + 1)),
                    child: SizedBox(
                      width: halfWidth,
                      child: _ProjectCard(
                        project: entry.value,
                        onGitHub: () => _launchUrl(entry.value.github),
                        isFeature: false,
                        index: entry.key + 1,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onGitHub;
  final bool isFeature;
  final int index;

  const _ProjectCard({
    required this.project,
    required this.onGitHub,
    required this.isFeature,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // Feature card gets the hero shape, others alternate
    final shape = isFeature
        ? ExpressiveShapes.heroShape
        : index.isEven
            ? ExpressiveShapes.asymmetricA
            : ExpressiveShapes.asymmetricB;

    return HoverSurface(
      borderRadius: shape,
      color: isFeature ? cs.surfaceContainer : cs.surfaceContainerLow,
      hoverColor: isFeature ? cs.surfaceContainerHigh : cs.surfaceContainer,
      elevation: isFeature ? 2 : 0,
      hoverElevation: isFeature ? 8 : 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(6),
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(14),
                  ),
                ),
                child: Icon(
                  isFeature ? Icons.star_rounded : Icons.folder_outlined,
                  size: 24,
                  color: cs.onPrimaryContainer,
                ),
              ),
              IconButton.filledTonal(
                onPressed: onGitHub,
                icon: SvgPicture.asset(
                  'assets/icons/github.svg',
                  width: 18, height: 18,
                  colorFilter: ColorFilter.mode(cs.onSecondaryContainer, BlendMode.srcIn),
                ),
                tooltip: 'View Source',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            project.name,
            style: isFeature ? tt.titleLarge : tt.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            project.period,
            style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          ...project.bullets.map(
            (bullet) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(Icons.arrow_right_rounded, size: 20, color: cs.primary),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(bullet, style: tt.bodyMedium)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
