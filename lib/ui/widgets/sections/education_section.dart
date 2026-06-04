import 'package:flutter/material.dart';
import 'package:portofolio/models/resume_model.dart';
import '../common/section_header.dart';

/// Education section using M3 **Filled** Card for medium emphasis.
class EducationSection extends StatelessWidget {
  final List<EducationModel> education;

  const EducationSection({super.key, required this.education});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Education', icon: Icons.school_outlined),
        ...education.map((edu) => _EducationCard(education: edu)),
      ],
    );
  }
}

class _EducationCard extends StatelessWidget {
  final EducationModel education;

  const _EducationCard({required this.education});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card.filled(
        color: cs.surfaceContainerLow,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.tertiaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.account_balance,
                  color: cs.onTertiaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      education.institution,
                      style: tt.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${education.degree} · ${education.location}',
                      style: tt.bodyMedium?.copyWith(
                        color: cs.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      education.period,
                      style: tt.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...education.details.map(
                      (detail) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 16,
                              color: cs.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(detail, style: tt.bodyMedium),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
