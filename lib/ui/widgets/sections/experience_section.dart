import 'package:flutter/material.dart';
import 'package:portofolio/models/resume_model.dart';
import '../common/section_header.dart';
import '../common/scroll_reveal.dart';
import '../common/hover_surface.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Static data: per-experience tool chips + headline metric
// ─────────────────────────────────────────────────────────────────────────────

class _ExpMeta {
  final List<String> tools;
  final String metricValue;
  final String metricLabel;
  final IconData metricIcon;

  const _ExpMeta({
    required this.tools,
    required this.metricValue,
    required this.metricLabel,
    required this.metricIcon,
  });
}

// Keyed by partial company name match
const _expMetaMap = <String, _ExpMeta>{
  'Aruna': _ExpMeta(
    tools: ['Go', 'Gin', 'GORM', 'JWT', 'MQTT', 'WebSocket',
            'Docker', 'AWS', 'InfluxDB', 'PostgreSQL'],
    metricValue: '80%',
    metricLabel: 'DB roundtrips reduced',
    metricIcon: Icons.speed_rounded,
  ),
  'Bangkit': _ExpMeta(
    tools: ['TypeScript', 'Hapi.js', 'PostgreSQL', 'Prisma',
            'GCP', 'Cloud Run', 'GitHub Actions'],
    metricValue: 'CI/CD',
    metricLabel: 'Full pipeline automated',
    metricIcon: Icons.rocket_launch_rounded,
  ),
};

_ExpMeta? _resolveMeta(String company) {
  for (final key in _expMetaMap.keys) {
    if (company.toLowerCase().contains(key.toLowerCase())) {
      return _expMetaMap[key];
    }
  }
  return null;
}

// ─────────────────────────────────────────────────────────────────────────────
// Section widget
// ─────────────────────────────────────────────────────────────────────────────

class ExperienceSection extends StatelessWidget {
  final List<ExperienceModel> experience;
  const ExperienceSection({super.key, required this.experience});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Experience', icon: Icons.work_outline),
        for (int i = 0; i < experience.length; i++)
          ScrollReveal(
            delay: Duration(milliseconds: 150 * i),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _ExperienceCard(
                experience: experience[i],
                isEven: i.isEven,
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Experience card — NO bullet paragraphs.
// Replaces text with: role header + single headline metric + tool chips.
// ─────────────────────────────────────────────────────────────────────────────

class _ExperienceCard extends StatelessWidget {
  final ExperienceModel experience;
  final bool isEven;
  const _ExperienceCard({required this.experience, required this.isEven});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final meta = _resolveMeta(experience.company);

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
          // ── Role header ─────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.business_rounded,
                    color: cs.onPrimaryContainer, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(experience.role,
                        style: tt.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700)),
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
              const SizedBox(width: 8),
              // Period pill
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    cs.surfaceContainerHighest,
                    cs.surfaceContainerHigh,
                  ]),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(experience.period,
                    style:
                        tt.labelSmall?.copyWith(fontWeight: FontWeight.w600)),
              ),
            ],
          ),

          // ── Headline metric callout ──────────────────────────────────────
          if (meta != null) ...[
            const SizedBox(height: 20),
            _MetricCallout(meta: meta),
          ],

          // ── Tool chips ───────────────────────────────────────────────────
          if (meta != null) ...[
            const SizedBox(height: 16),
            _ToolChips(tools: meta.tools),
          ] else ...[
            // Fallback: show condensed single-line summaries
            const SizedBox(height: 16),
            _FallbackSummary(bullets: experience.bullets),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Metric callout — bold number + label in a surface container
// ─────────────────────────────────────────────────────────────────────────────

class _MetricCallout extends StatelessWidget {
  final _ExpMeta meta;
  const _MetricCallout({required this.meta});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cs.primaryContainer.withValues(alpha: 0.5),
            cs.tertiaryContainer.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(6),
          bottomLeft: Radius.circular(6),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(meta.metricIcon, color: cs.primary, size: 22),
          const SizedBox(width: 12),
          Text(
            meta.metricValue,
            style: tt.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.primary,
              height: 1.0,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            meta.metricLabel,
            style: tt.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tool chips — M3 ActionChip-styled badges for each technology used
// ─────────────────────────────────────────────────────────────────────────────

class _ToolChips extends StatelessWidget {
  final List<String> tools;
  const _ToolChips({required this.tools});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tools
          .asMap()
          .entries
          .map((e) => _ToolChip(
                label: e.value,
                index: e.key,
              ))
          .toList(),
    );
  }
}

class _ToolChip extends StatefulWidget {
  final String label;
  final int index;
  const _ToolChip({required this.label, required this.index});

  @override
  State<_ToolChip> createState() => _ToolChipState();
}

class _ToolChipState extends State<_ToolChip> {
  bool _hovered = false;

  // Rotate through subtle tonal colors for visual variety
  Color _bg(ColorScheme cs) => switch (widget.index % 4) {
        0 => cs.primaryContainer.withValues(alpha: _hovered ? 1.0 : 0.5),
        1 => cs.secondaryContainer.withValues(alpha: _hovered ? 1.0 : 0.5),
        2 => cs.tertiaryContainer.withValues(alpha: _hovered ? 1.0 : 0.5),
        _ => cs.surfaceContainerHighest,
      };

  Color _fg(ColorScheme cs) => switch (widget.index % 4) {
        0 => cs.onPrimaryContainer,
        1 => cs.onSecondaryContainer,
        2 => cs.onTertiaryContainer,
        _ => cs.onSurface,
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        transform: Matrix4.diagonal3Values(
          _hovered ? 1.05 : 1.0,
          _hovered ? 1.05 : 1.0,
          1.0,
        ),
        transformAlignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _bg(cs),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(6),
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(14),
          ),
        ),
        child: Text(
          widget.label,
          style: tt.labelMedium?.copyWith(
            color: _fg(cs),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Fallback: if no meta defined, show first 2 bullet key phrases only
// ─────────────────────────────────────────────────────────────────────────────

class _FallbackSummary extends StatelessWidget {
  final List<String> bullets;
  const _FallbackSummary({required this.bullets});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final preview = bullets.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: preview.map((b) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    b,
                    style: tt.bodyMedium?.copyWith(
                      height: 1.5,
                      color: cs.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          )).toList(),
    );
  }
}
