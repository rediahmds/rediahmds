import 'package:flutter/material.dart';
import 'package:portofolio/models/resume_model.dart';
import '../common/section_header.dart';
import '../common/scroll_reveal.dart';
import '../common/hover_surface.dart';

/// Experience section with staggered entrance and hover-interactive cards.
class ExperienceSection extends StatelessWidget {
  final List<ExperienceModel> experience;
  const ExperienceSection({super.key, required this.experience});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Experience', icon: Icons.work_outline),
        ...experience.asMap().entries.map((entry) => ScrollReveal(
              delay: Duration(milliseconds: 150 * entry.key),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _ExperienceCard(
                  experience: entry.value,
                  isEven: entry.key.isEven,
                ),
              ),
            )),
      ],
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final ExperienceModel experience;
  final bool isEven;
  const _ExperienceCard({required this.experience, required this.isEven});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // Alternate between asymmetric shape variants for visual rhythm
    final shape = isEven
        ? const BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(36),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(36),
            bottomLeft: Radius.circular(36),
            bottomRight: Radius.circular(12),
          );

    return HoverSurface(
      borderRadius: shape,
      elevation: 1,
      hoverElevation: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.business, color: cs.onPrimaryContainer),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(experience.role, style: tt.titleMedium),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [cs.surfaceContainerHighest, cs.surfaceContainerHigh],
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            experience.period,
                            style: tt.labelSmall?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${experience.company} · ${experience.location}',
                      style: tt.bodyMedium?.copyWith(
                        color: cs.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...experience.bullets.map(
            (bullet) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [cs.primary, cs.tertiary],
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(bullet, style: tt.bodyMedium?.copyWith(height: 1.6)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
