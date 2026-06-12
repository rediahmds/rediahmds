import 'package:flutter/material.dart';
import 'package:portofolio/models/resume_model.dart';
import '../common/section_header.dart';
import '../common/scroll_reveal.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Static per-entry metadata — tools and single headline metric.
// Resolved by fuzzy company/institution name match.
// ─────────────────────────────────────────────────────────────────────────────

class _EntryMeta {
  final List<String> tools;
  final String metricValue;
  final String metricLabel;
  final IconData metricIcon;
  final Color accentColor;

  const _EntryMeta({
    required this.tools,
    required this.metricValue,
    required this.metricLabel,
    required this.metricIcon,
    required this.accentColor,
  });
}

const _metaMap = <String, _EntryMeta>{
  'Aruna': _EntryMeta(
    tools: ['Go', 'Gin', 'GORM', 'JWT', 'MQTT',
            'WebSocket', 'Docker', 'AWS', 'InfluxDB'],
    metricValue: '80%',
    metricLabel: 'DB roundtrips cut',
    metricIcon: Icons.speed_rounded,
    accentColor: Color(0xFF00ADD8),
  ),
  'Bangkit': _EntryMeta(
    tools: ['TypeScript', 'Hapi.js', 'PostgreSQL',
            'Prisma', 'GCP', 'Cloud Run', 'GitHub Actions'],
    metricValue: '7s→500ms',
    metricLabel: 'Upload latency',
    metricIcon: Icons.rocket_launch_rounded,
    accentColor: Color(0xFF4285F4),
  ),
  'Gunadarma': _EntryMeta(
    tools: ['Python', 'PyTorch', 'OpenCV',
            'ESP32', 'C++', 'MQTT', 'Blynk'],
    metricValue: '3.91',
    metricLabel: 'GPA / 4.00',
    metricIcon: Icons.school_rounded,
    accentColor: Color(0xFF6750A4),
  ),
};

_EntryMeta? _resolveMeta(String key) {
  for (final entry in _metaMap.entries) {
    if (key.toLowerCase().contains(entry.key.toLowerCase())) {
      return entry.value;
    }
  }
  return null;
}

// ─────────────────────────────────────────────────────────────────────────────
// Unified timeline entry — wraps both experience and education uniformly.
// ─────────────────────────────────────────────────────────────────────────────

class _TimelineEntry {
  final String title;    // role or degree
  final String subtitle; // company or institution
  final String location;
  final String period;
  final String metaKey;  // used to look up _metaMap

  const _TimelineEntry({
    required this.title,
    required this.subtitle,
    required this.location,
    required this.period,
    required this.metaKey,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// ExperienceSection — left-anchored timeline replacing the previous card list.
//
// Layout (STRICT single-sided):
//
//   ●──────────────────────────────────────────────────────
//   │   [Role card — slides in from right on scroll]
//   │
//   ●──────────────────────────────────────────────────────
//   │   [Role card]
//   │
//   ◐   [Education card — softer node color]
//
// The vertical line and nodes are ALWAYS on the left.
// Content cards are ALWAYS on the right. Eyes move only top→bottom.
// ─────────────────────────────────────────────────────────────────────────────

class ExperienceSection extends StatelessWidget {
  final List<ExperienceModel> experience;

  /// Optionally pass education to render it beneath experience on the same axis.
  final List<EducationModel>? education;

  const ExperienceSection({
    super.key,
    required this.experience,
    this.education,
  });

  @override
  Widget build(BuildContext context) {
    final entries = <_TimelineEntry>[
      for (final e in experience)
        _TimelineEntry(
          title: e.role,
          subtitle: e.company,
          location: e.location,
          period: e.period,
          metaKey: e.company,
        ),
      if (education != null)
        for (final ed in education!)
          _TimelineEntry(
            title: ed.degree.split(',').first.trim(),
            subtitle: ed.institution,
            location: ed.location,
            period: ed.period,
            metaKey: ed.institution,
          ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Experience', icon: Icons.work_outline),
        _Timeline(entries: entries),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Timeline — renders the axis line + all entries
// ─────────────────────────────────────────────────────────────────────────────

class _Timeline extends StatelessWidget {
  final List<_TimelineEntry> entries;
  const _Timeline({required this.entries});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: entries.asMap().entries.map((e) {
        final isLast = e.key == entries.length - 1;
        return _TimelineRow(
          entry: e.value,
          index: e.key,
          isLast: isLast,
          cs: cs,
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Single timeline row — [node + line] | [content card]
// ─────────────────────────────────────────────────────────────────────────────

class _TimelineRow extends StatelessWidget {
  final _TimelineEntry entry;
  final int index;
  final bool isLast;
  final ColorScheme cs;

  const _TimelineRow({
    required this.entry,
    required this.index,
    required this.isLast,
    required this.cs,
  });

  // Alternate accent colors to distinguish entries without zig-zagging.
  Color _nodeColor() {
    final meta = _resolveMeta(entry.metaKey);
    if (meta != null) return meta.accentColor;
    return switch (index % 3) {
      0 => cs.primary,
      1 => cs.secondary,
      _ => cs.tertiary,
    };
  }

  @override
  Widget build(BuildContext context) {
    const nodeSize = 20.0;
    const nodeColumnWidth = 40.0; // fixed-width left column
    const lineWidth = 2.0;
    const cardGap = 16.0;
    final nodeColor = _nodeColor();

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Left axis column: node + connecting line ─────────────────────
          SizedBox(
            width: nodeColumnWidth,
            child: Column(
              children: [
                // Vibrant M3 node indicator
                Container(
                  width: nodeSize,
                  height: nodeSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: nodeColor,
                    boxShadow: [
                      BoxShadow(
                        color: nodeColor.withValues(alpha: 0.4),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  // Inner ring for depth
                  child: Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cs.surface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
                // Subtle connecting line — only if not the last entry
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: lineWidth,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            nodeColor.withValues(alpha: 0.5),
                            cs.outlineVariant.withValues(alpha: 0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: cardGap),

          // ── Right content card — slides in from the right on reveal ──────
          Expanded(
            child: Padding(
              // Bottom spacing between cards (except after last)
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: ScrollReveal(
                delay: Duration(milliseconds: 80 * index),
                slideOffset: const Offset(32, 0), // slides from the RIGHT
                child: _TimelineCard(entry: entry, nodeColor: nodeColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Content card — asymmetric M3 Expressive card
// ─────────────────────────────────────────────────────────────────────────────

class _TimelineCard extends StatefulWidget {
  final _TimelineEntry entry;
  final Color nodeColor;
  const _TimelineCard({required this.entry, required this.nodeColor});

  @override
  State<_TimelineCard> createState() => _TimelineCardState();
}

class _TimelineCardState extends State<_TimelineCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final meta = _resolveMeta(widget.entry.metaKey);

    // All cards use the same left-anchored asymmetric shape.
    // topLeft is always the large corner — it "points" toward the left axis.
    const cardShape = BorderRadius.only(
      topLeft: Radius.circular(6),
      topRight: Radius.circular(28),
      bottomLeft: Radius.circular(6),
      bottomRight: Radius.circular(28),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(_hovered ? -2 : 0, 0, 0),
        child: AnimatedPhysicalModel(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          shape: BoxShape.rectangle,
          borderRadius: cardShape,
          elevation: _hovered ? 6 : 1,
          color: _hovered ? cs.surfaceContainerHigh : cs.surfaceContainerLow,
          shadowColor: cs.shadow,
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              // Accent left-edge stripe "connecting" card to the node
              border: Border(
                left: BorderSide(
                  color: widget.nodeColor.withValues(alpha: _hovered ? 0.8 : 0.4),
                  width: 3,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header: role + period pill ─────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.entry.title,
                        style: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        widget.entry.period,
                        style: tt.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // ── Company / institution + location ───────────────────
                Text(
                  '${widget.entry.subtitle} · ${widget.entry.location}',
                  style: tt.bodyMedium?.copyWith(
                    color: cs.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // ── Headline metric ────────────────────────────────────
                if (meta != null) ...[
                  const SizedBox(height: 14),
                  _MetricBadge(meta: meta, cs: cs, tt: tt),
                ],

                // ── Tool chips ─────────────────────────────────────────
                if (meta != null) ...[
                  const SizedBox(height: 12),
                  _ToolChips(tools: meta.tools, cs: cs, tt: tt,
                      accentColor: widget.nodeColor),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Metric badge — bold callout number inside a tonal container
// ─────────────────────────────────────────────────────────────────────────────

class _MetricBadge extends StatelessWidget {
  final _EntryMeta meta;
  final ColorScheme cs;
  final TextTheme tt;
  const _MetricBadge({
    required this.meta,
    required this.cs,
    required this.tt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            meta.accentColor.withValues(alpha: 0.12),
            meta.accentColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(6),
          bottomRight: Radius.circular(16),
        ),
        border: Border.all(
          color: meta.accentColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(meta.metricIcon, color: meta.accentColor, size: 18),
          const SizedBox(width: 10),
          Text(
            meta.metricValue,
            style: tt.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: meta.accentColor,
              height: 1.0,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              meta.metricLabel,
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tool chips — rotating M3 tonal ActionChip-style badges
// ─────────────────────────────────────────────────────────────────────────────

class _ToolChips extends StatelessWidget {
  final List<String> tools;
  final ColorScheme cs;
  final TextTheme tt;
  final Color accentColor;

  const _ToolChips({
    required this.tools,
    required this.cs,
    required this.tt,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 7,
      runSpacing: 7,
      children: tools
          .asMap()
          .entries
          .map((e) => _ToolChip(
                label: e.value,
                index: e.key,
                cs: cs,
                tt: tt,
                accentColor: accentColor,
              ))
          .toList(),
    );
  }
}

class _ToolChip extends StatefulWidget {
  final String label;
  final int index;
  final ColorScheme cs;
  final TextTheme tt;
  final Color accentColor;

  const _ToolChip({
    required this.label,
    required this.index,
    required this.cs,
    required this.tt,
    required this.accentColor,
  });

  @override
  State<_ToolChip> createState() => _ToolChipState();
}

class _ToolChipState extends State<_ToolChip> {
  bool _hovered = false;

  Color _bg() => switch (widget.index % 4) {
        0 => widget.cs.primaryContainer
            .withValues(alpha: _hovered ? 1.0 : 0.55),
        1 => widget.cs.secondaryContainer
            .withValues(alpha: _hovered ? 1.0 : 0.55),
        2 => widget.cs.tertiaryContainer
            .withValues(alpha: _hovered ? 1.0 : 0.55),
        _ => widget.cs.surfaceContainerHighest,
      };

  Color _fg() => switch (widget.index % 4) {
        0 => widget.cs.onPrimaryContainer,
        1 => widget.cs.onSecondaryContainer,
        2 => widget.cs.onTertiaryContainer,
        _ => widget.cs.onSurface,
      };

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        transform: Matrix4.diagonal3Values(
          _hovered ? 1.06 : 1.0,
          _hovered ? 1.06 : 1.0,
          1.0,
        ),
        transformAlignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: _bg(),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Text(
          widget.label,
          style: widget.tt.labelSmall?.copyWith(
            color: _fg(),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
