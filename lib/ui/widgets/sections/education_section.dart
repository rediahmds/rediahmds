import 'package:flutter/material.dart';
import 'package:portofolio/models/resume_model.dart';
import '../common/section_header.dart';
import '../common/scroll_reveal.dart';
import '../common/hover_surface.dart';

/// Education section with staggered scroll-reveal and hover-interactive cards.
class EducationSection extends StatelessWidget {
  final List<EducationModel> education;
  const EducationSection({super.key, required this.education});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Education', icon: Icons.school_outlined),
        ...education.asMap().entries.map((entry) => ScrollReveal(
              delay: Duration(milliseconds: 100 * entry.key),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _EducationCard(education: entry.value),
              ),
            )),
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

    return HoverSurface(
      borderRadius: ExpressiveShapes.asymmetricB,
      elevation: 0,
      hoverElevation: 3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.tertiaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Icon(Icons.account_balance, color: cs.onTertiaryContainer),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(education.institution, style: tt.titleMedium),
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
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 12),
                ...education.details.map((d) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle_outline, size: 16, color: cs.primary),
                          const SizedBox(width: 8),
                          Expanded(child: Text(d, style: tt.bodyMedium)),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
