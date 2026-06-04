import 'package:flutter/material.dart';
import 'package:portofolio/models/resume_model.dart';
import '../common/section_header.dart';

/// Experience section using M3 **Elevated** Card for maximum visual emphasis.
class ExperienceSection extends StatelessWidget {
  final List<ExperienceModel> experience;

  const ExperienceSection({super.key, required this.experience});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Experience', icon: Icons.work_outline),
        ...experience.map((exp) => _ExperienceCard(experience: exp)),
      ],
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final ExperienceModel experience;

  const _ExperienceCard({required this.experience});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 1,
        color: cs.surfaceContainerLow,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header row: icon + role + period badge ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.business,
                      color: cs.onPrimaryContainer,
                    ),
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
                              child: Text(
                                experience.role,
                                style: tt.titleMedium,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: cs.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                experience.period,
                                style: tt.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
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

              // --- Bullet points ---
              ...experience.bullets.map(
                (bullet) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Icon(
                          Icons.circle,
                          size: 6,
                          color: cs.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          bullet,
                          style: tt.bodyMedium?.copyWith(height: 1.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
