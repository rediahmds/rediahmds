import 'package:flutter/material.dart';
import 'package:portofolio/models/resume_model.dart';
import '../common/section_header.dart';
import '../common/scroll_reveal.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ExperienceItem — strongly-typed unified model for both experience + education.
// Wraps the raw JSON models and adds parsed DateTime fields for sorting.
// ─────────────────────────────────────────────────────────────────────────────

enum ItemKind { work, education }

class ExperienceItem {
  final String title;
  final String subtitle;
  final String location;
  final DateTime startDate;

  /// null = "Present" / ongoing
  final DateTime? endDate;

  final ItemKind kind;
  final String metaKey;

  const ExperienceItem({
    required this.title,
    required this.subtitle,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.kind,
    required this.metaKey,
  });

  /// The effective date used for sorting: ongoing items sort as far-future.
  DateTime get _sortKey => endDate ?? DateTime(9999);

  /// Human-readable period string, e.g. "Dec 2025 – Present" or "Feb – Jul 2024".
  String get formattedPeriod {
    final start = _fmtMonth(startDate);
    if (endDate == null) return '$start – Present';
    final end = _fmtMonth(endDate!);
    // Omit year from start if same year
    if (startDate.year == endDate!.year) {
      return '${_monthName(startDate.month)} – $end';
    }
    return '$start – $end';
  }

  static String _fmtMonth(DateTime d) => '${_monthName(d.month)} ${d.year}';

  static String _monthName(int m) => const [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ][m];

  // ── Factories ──────────────────────────────────────────────────────────────

  factory ExperienceItem.fromExperience(ExperienceModel e) {
    final (start, end) = _parsePeriod(e.period);
    return ExperienceItem(
      title: e.role,
      subtitle: e.company,
      location: e.location,
      startDate: start,
      endDate: end,
      kind: ItemKind.work,
      metaKey: e.company,
    );
  }

  factory ExperienceItem.fromEducation(EducationModel e) {
    final (start, end) = _parsePeriod(e.period);
    return ExperienceItem(
      title: e.degree.split(',').first.trim(),
      subtitle: e.institution,
      location: e.location,
      startDate: start,
      endDate: end,
      kind: ItemKind.education,
      metaKey: e.institution,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Period parser — handles all JSON formats found in resume.json:
//   "Dec 2025 – Present"   (en-dash, no end year)
//   "Feb – Jul 2024"       (en-dash, start has no year)
//   "Sep 2021 - Sep 2025"  (hyphen, both have month+year)
// ─────────────────────────────────────────────────────────────────────────────

(DateTime, DateTime?) _parsePeriod(String raw) {
  // Normalize: replace en-dash and em-dash with ASCII hyphen, trim.
  final s = raw.replaceAll('–', '-').replaceAll('—', '-').trim();
  final parts = s.split('-').map((p) => p.trim()).toList();

  if (parts.length < 2) {
    // Single token — use as start, treat as ongoing.
    return (_parseMonthYear(parts[0], null), null);
  }

  final startRaw = parts[0];
  final endRaw = parts.sublist(1).join('-').trim(); // handles "Sep 2025" after split

  final DateTime? endDate;
  if (endRaw.toLowerCase() == 'present' || endRaw.isEmpty) {
    endDate = null;
  } else {
    endDate = _parseMonthYear(endRaw, null);
  }

  // If start has no year (e.g. "Feb"), borrow year from end.
  final startYear = endDate?.year;
  final startDate = _parseMonthYear(startRaw, startYear);

  return (startDate, endDate);
}

/// Parses "Dec 2025", "Feb", "Sep 2021", etc.
/// [fallbackYear] is used when the token contains only a month name.
DateTime _parseMonthYear(String token, int? fallbackYear) {
  const months = {
    'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
    'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12,
  };
  final words = token.trim().split(RegExp(r'\s+'));
  int? month;
  int? year;

  for (final w in words) {
    final lower = w.toLowerCase().substring(0, w.length.clamp(0, 3));
    if (months.containsKey(lower)) {
      month = months[lower];
    } else {
      final parsed = int.tryParse(w);
      if (parsed != null && parsed > 1900) year = parsed;
    }
  }

  return DateTime(year ?? fallbackYear ?? DateTime.now().year, month ?? 1);
}

// ─────────────────────────────────────────────────────────────────────────────
// Sorting — reverse-chronological: most-recent effective end date first.
// Ongoing (endDate == null) sorts above everything.
// ─────────────────────────────────────────────────────────────────────────────

List<ExperienceItem> _sortItems(List<ExperienceItem> items) {
  final sorted = [...items];
  sorted.sort((a, b) => b._sortKey.compareTo(a._sortKey));
  return sorted;
}

// ─────────────────────────────────────────────────────────────────────────────
// Per-entry static metadata (tools + headline metric)
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
    tools: ['Go', 'Gin', 'GORM', 'JWT', 'MQTT', 'WebSocket', 'Docker', 'AWS', 'InfluxDB'],
    metricValue: '80%',
    metricLabel: 'DB roundtrips cut',
    metricIcon: Icons.speed_rounded,
    accentColor: Color(0xFF00ADD8),
  ),
  'Bangkit': _EntryMeta(
    tools: ['TypeScript', 'Hapi.js', 'PostgreSQL', 'Prisma', 'GCP', 'Cloud Run', 'GitHub Actions'],
    metricValue: '7s → 500ms',
    metricLabel: 'Upload latency',
    metricIcon: Icons.rocket_launch_rounded,
    accentColor: Color(0xFF4285F4),
  ),
  'Gunadarma': _EntryMeta(
    tools: ['Python', 'PyTorch', 'OpenCV', 'ESP32', 'C++', 'MQTT'],
    metricValue: '3.91 / 4.00',
    metricLabel: 'GPA',
    metricIcon: Icons.school_rounded,
    accentColor: Color(0xFF6750A4),
  ),
};

_EntryMeta? _resolveMeta(String key) {
  for (final e in _metaMap.entries) {
    if (key.toLowerCase().contains(e.key.toLowerCase())) return e.value;
  }
  return null;
}

// ─────────────────────────────────────────────────────────────────────────────
// ExperienceSection — public widget consumed by HomeScreen
// ─────────────────────────────────────────────────────────────────────────────

class ExperienceSection extends StatelessWidget {
  final List<ExperienceModel> experience;
  final List<EducationModel>? education;

  const ExperienceSection({
    super.key,
    required this.experience,
    this.education,
  });

  @override
  Widget build(BuildContext context) {
    // Build unified list, then sort reverse-chronologically.
    final raw = [
      ...experience.map(ExperienceItem.fromExperience),
      if (education != null) ...education!.map(ExperienceItem.fromEducation),
    ];
    final sorted = _sortItems(raw);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Experience', icon: Icons.work_outline),
        _Timeline(items: sorted),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Timeline — renders sorted list on a strictly left-anchored axis
// ─────────────────────────────────────────────────────────────────────────────

class _Timeline extends StatelessWidget {
  final List<ExperienceItem> items;
  const _Timeline({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < items.length; i++)
          _TimelineRow(
            item: items[i],
            index: i,
            isFirst: i == 0,
            // Line stops AT the last node — no trailing segment.
            isLast: i == items.length - 1,
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Single row: [node + connector] | [card]
// ─────────────────────────────────────────────────────────────────────────────

class _TimelineRow extends StatelessWidget {
  final ExperienceItem item;
  final int index;
  final bool isFirst;
  final bool isLast;

  const _TimelineRow({
    required this.item,
    required this.index,
    required this.isFirst,
    required this.isLast,
  });

  bool get _isOngoing => item.endDate == null;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const nodeCol = 40.0;
    const gap = 16.0;

    // Current/ongoing → vibrant primary.  Past → muted surface token.
    final nodeColor = _isOngoing ? cs.primary : cs.surfaceContainerHighest;
    final nodeBorder = _isOngoing ? Colors.transparent : cs.outlineVariant;
    final innerDot = _isOngoing ? cs.onPrimary : cs.outline;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Left axis ─────────────────────────────────────────────────────
          SizedBox(
            width: nodeCol,
            child: Column(
              children: [
                // Node
                _Node(
                  color: nodeColor,
                  borderColor: nodeBorder,
                  dotColor: innerDot,
                  pulse: _isOngoing,
                ),
                // Connector — omitted after the final node so no empty line.
                if (!isLast)
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              _isOngoing
                                  ? cs.primary.withValues(alpha: 0.5)
                                  : cs.outlineVariant.withValues(alpha: 0.5),
                              cs.outlineVariant.withValues(alpha: 0.15),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: gap),

          // ── Card — slides in from the right ───────────────────────────────
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: ScrollReveal(
                delay: Duration(milliseconds: 80 * index),
                slideOffset: const Offset(28, 0),
                child: _TimelineCard(item: item, isOngoing: _isOngoing),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Node — with optional pulse animation for ongoing items
// ─────────────────────────────────────────────────────────────────────────────

class _Node extends StatefulWidget {
  final Color color;
  final Color borderColor;
  final Color dotColor;
  final bool pulse;

  const _Node({
    required this.color,
    required this.borderColor,
    required this.dotColor,
    required this.pulse,
  });

  @override
  State<_Node> createState() => _NodeState();
}

class _NodeState extends State<_Node> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _scale = Tween<double>(begin: 1.0, end: 1.9).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _opacity = Tween<double>(begin: 0.55, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    if (widget.pulse) {
      _ctrl.repeat(period: const Duration(milliseconds: 2200));
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const size = 20.0;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Ripple ring — only rendered for ongoing nodes
          if (widget.pulse)
            AnimatedBuilder(
              animation: _ctrl,
              builder: (context, _) => Transform.scale(
                scale: _scale.value,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withValues(alpha: _opacity.value),
                  ),
                ),
              ),
            ),
          // Solid node
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color,
              border: Border.all(color: widget.borderColor, width: 1.5),
              boxShadow: widget.pulse
                  ? [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.dotColor.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Content card
// ─────────────────────────────────────────────────────────────────────────────

class _TimelineCard extends StatefulWidget {
  final ExperienceItem item;
  final bool isOngoing;
  const _TimelineCard({required this.item, required this.isOngoing});

  @override
  State<_TimelineCard> createState() => _TimelineCardState();
}

class _TimelineCardState extends State<_TimelineCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final meta = _resolveMeta(widget.item.metaKey);

    // Ongoing item gets a subtle primary tint on hover; past items are neutral.
    final baseColor = widget.isOngoing
        ? cs.primaryContainer.withValues(alpha: 0.08)
        : cs.surfaceContainerLow;
    final hoverColor = widget.isOngoing
        ? cs.primaryContainer.withValues(alpha: 0.18)
        : cs.surfaceContainer;

    final stripeColor = widget.isOngoing
        ? cs.primary.withValues(alpha: _hovered ? 0.9 : 0.5)
        : cs.outlineVariant.withValues(alpha: _hovered ? 0.8 : 0.4);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(_hovered ? -2 : 0, 0, 0),
        child: AnimatedPhysicalModel(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(24),
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(24),
          ),
          elevation: _hovered ? 5 : 1,
          color: _hovered ? hoverColor : baseColor,
          shadowColor: cs.shadow,
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: stripeColor, width: 3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Role + period ──────────────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.item.title,
                        style: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _PeriodBadge(
                      period: widget.item.formattedPeriod,
                      isOngoing: widget.isOngoing,
                      cs: cs,
                      tt: tt,
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // ── Company / institution ──────────────────────────────────
                Row(
                  children: [
                    Icon(
                      widget.item.kind == ItemKind.work
                          ? Icons.business_rounded
                          : Icons.school_rounded,
                      size: 14,
                      color: cs.secondary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${widget.item.subtitle} · ${widget.item.location}',
                        style: tt.bodySmall?.copyWith(
                          color: cs.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                // ── Metric badge ───────────────────────────────────────────
                if (meta != null) ...[
                  const SizedBox(height: 14),
                  _MetricBadge(meta: meta),
                ],

                // ── Tool chips ─────────────────────────────────────────────
                if (meta != null) ...[
                  const SizedBox(height: 12),
                  _ToolChips(tools: meta.tools, cs: cs, tt: tt),
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
// Period badge — "Present" gets a primary tint to stand out
// ─────────────────────────────────────────────────────────────────────────────

class _PeriodBadge extends StatelessWidget {
  final String period;
  final bool isOngoing;
  final ColorScheme cs;
  final TextTheme tt;

  const _PeriodBadge({
    required this.period,
    required this.isOngoing,
    required this.cs,
    required this.tt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isOngoing
            ? cs.primaryContainer.withValues(alpha: 0.6)
            : cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(100),
        border: isOngoing
            ? Border.all(color: cs.primary.withValues(alpha: 0.3))
            : null,
      ),
      child: Text(
        period,
        style: tt.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: isOngoing ? cs.primary : cs.onSurfaceVariant,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Metric badge
// ─────────────────────────────────────────────────────────────────────────────

class _MetricBadge extends StatelessWidget {
  final _EntryMeta meta;
  const _MetricBadge({required this.meta});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          meta.accentColor.withValues(alpha: 0.12),
          meta.accentColor.withValues(alpha: 0.04),
        ]),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(14),
          bottomLeft: Radius.circular(6),
          bottomRight: Radius.circular(14),
        ),
        border: Border.all(color: meta.accentColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(meta.metricIcon, size: 16, color: meta.accentColor),
          const SizedBox(width: 8),
          Text(
            meta.metricValue,
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: meta.accentColor,
              height: 1.0,
            ),
          ),
          const SizedBox(width: 6),
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
// Tool chips
// ─────────────────────────────────────────────────────────────────────────────

class _ToolChips extends StatelessWidget {
  final List<String> tools;
  final ColorScheme cs;
  final TextTheme tt;
  const _ToolChips({required this.tools, required this.cs, required this.tt});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: tools
          .asMap()
          .entries
          .map((e) => _Chip(label: e.value, index: e.key, cs: cs, tt: tt))
          .toList(),
    );
  }
}

class _Chip extends StatefulWidget {
  final String label;
  final int index;
  final ColorScheme cs;
  final TextTheme tt;
  const _Chip({required this.label, required this.index,
      required this.cs, required this.tt});

  @override
  State<_Chip> createState() => _ChipState();
}

class _ChipState extends State<_Chip> {
  bool _hovered = false;

  Color _bg() => switch (widget.index % 4) {
        0 => widget.cs.primaryContainer.withValues(alpha: _hovered ? 1.0 : 0.55),
        1 => widget.cs.secondaryContainer.withValues(alpha: _hovered ? 1.0 : 0.55),
        2 => widget.cs.tertiaryContainer.withValues(alpha: _hovered ? 1.0 : 0.55),
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
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        transform: Matrix4.diagonal3Values(
          _hovered ? 1.06 : 1.0, _hovered ? 1.06 : 1.0, 1.0,
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
