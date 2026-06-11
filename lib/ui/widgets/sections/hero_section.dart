import 'package:flutter/material.dart';
import 'package:portofolio/models/resume_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../common/terminal_hero.dart';

/// Bulletproof two-column Hero section.
///
/// Desktop: [IdentityColumn | TerminalColumn] via Row + Expanded/constrained.
/// Mobile:  stacked Column — identity → metrics → terminal → actions.
///
/// Zero paragraphs: bio text is replaced by glanceable M3 metric micro-cards
/// and a live terminal widget that immediately signals "backend developer".
class HeroSection extends StatefulWidget {
  final PersonalModel personal;
  const HeroSection({super.key, required this.personal});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _ctrl,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut));
    _slide = Tween<Offset>(begin: const Offset(0, 32), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl,
            curve: const Interval(0.05, 0.8, curve: Curves.easeOutCubic)));
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDesktop = MediaQuery.sizeOf(context).width > 800;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) => Opacity(
        opacity: _fade.value,
        child: Transform.translate(offset: _slide.value, child: child),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [cs.surfaceContainerLow, cs.surfaceContainer],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(48),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(48),
          ),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
        ),
        padding: EdgeInsets.all(isDesktop ? 40 : 24),
        child: isDesktop
            ? _buildDesktop(context, cs)
            : _buildMobile(context, cs),
      ),
    );
  }

  // ── Desktop: strict 50/50 Row layout ───────────────────────────────────────

  Widget _buildDesktop(BuildContext context, ColorScheme cs) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left column — exactly 50% of available width
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ProfileRow(personal: widget.personal, isDesktop: true),
                const SizedBox(height: 24),
                _MetricRow(isDesktop: true),
                const SizedBox(height: 28),
                _ActionRow(personal: widget.personal, launch: _launch),
              ],
            ),
          ),
          const SizedBox(width: 32),
          // Right column — fixed max-width terminal, never overflows
          SizedBox(
            width: 380,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 280, maxHeight: 360),
              child: const TerminalHero(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Mobile: stacked layout ──────────────────────────────────────────────────

  Widget _buildMobile(BuildContext context, ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _ProfileRow(personal: widget.personal, isDesktop: false),
        const SizedBox(height: 20),
        _MetricRow(isDesktop: false),
        const SizedBox(height: 20),
        _ActionRow(personal: widget.personal, launch: _launch),
        const SizedBox(height: 20),
        SizedBox(height: 220, child: const TerminalHero()),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile row — avatar + name + title badge
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileRow extends StatelessWidget {
  final PersonalModel personal;
  final bool isDesktop;
  const _ProfileRow({required this.personal, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final avatarSize = isDesktop ? 100.0 : 72.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar with asymmetric clip
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(32),
            ),
            border: Border.all(color: cs.primaryContainer, width: 3),
            boxShadow: [
              BoxShadow(
                color: cs.primary.withValues(alpha: 0.18),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(29),
              topRight: Radius.circular(9),
              bottomLeft: Radius.circular(9),
              bottomRight: Radius.circular(29),
            ),
            child: Image.asset('assets/me.png',
                fit: BoxFit.cover, filterQuality: FilterQuality.medium),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                personal.name,
                style:
                    (isDesktop ? tt.headlineLarge : tt.headlineMedium)?.copyWith(
                  height: 1.1,
                  letterSpacing: -0.8,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              // Gradient title badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [cs.tertiaryContainer, cs.secondaryContainer],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Text(
                  'Backend & Cloud · Mobile',
                  style: tt.labelMedium?.copyWith(
                    color: cs.onTertiaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Metric micro-cards — replaces the bio paragraph entirely.
// Each card is a glanceable data point.
// ─────────────────────────────────────────────────────────────────────────────

class _MetricRow extends StatelessWidget {
  final bool isDesktop;
  const _MetricRow({required this.isDesktop});

  static const _metrics = [
    _MetricData(
      icon: Icons.storage_rounded,
      value: 'Backend',
      label: 'Architecture',
    ),
    _MetricData(
      icon: Icons.psychology_rounded,
      value: 'CV / AI',
      label: 'Edge Computing',
    ),
    _MetricData(
      icon: Icons.smartphone_rounded,
      value: 'Flutter',
      label: 'Mobile Dev',
    ),
    _MetricData(
      icon: Icons.cloud_done_rounded,
      value: 'AWS · GCP',
      label: 'Cloud Deploy',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _metrics
          .asMap()
          .entries
          .map((e) => _MetricChip(data: e.value, index: e.key))
          .toList(),
    );
  }
}

class _MetricData {
  final IconData icon;
  final String value;
  final String label;
  const _MetricData(
      {required this.icon, required this.value, required this.label});
}

class _MetricChip extends StatefulWidget {
  final _MetricData data;
  final int index;
  const _MetricChip({required this.data, required this.index});

  @override
  State<_MetricChip> createState() => _MetricChipState();
}

class _MetricChipState extends State<_MetricChip> {
  bool _hovered = false;

  // Cycles through M3 container color pairs by index
  Color _bg(ColorScheme cs) => switch (widget.index % 4) {
        0 => cs.primaryContainer,
        1 => cs.secondaryContainer,
        2 => cs.tertiaryContainer,
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
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.diagonal3Values(
          _hovered ? 1.04 : 1.0,
          _hovered ? 1.04 : 1.0,
          1.0,
        ),
        transformAlignment: Alignment.center,
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: _hovered
              ? _bg(cs)
              : _bg(cs).withValues(alpha: 0.6),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(6),
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(16),
          ),
          border: Border.all(
            color: _hovered
                ? _fg(cs).withValues(alpha: 0.3)
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.data.icon, size: 18, color: _fg(cs)),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.data.value,
                  style: tt.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: _fg(cs),
                    height: 1.1,
                  ),
                ),
                Text(
                  widget.data.label,
                  style: tt.labelSmall?.copyWith(
                    color: _fg(cs).withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Action buttons row
// ─────────────────────────────────────────────────────────────────────────────

class _ActionRow extends StatelessWidget {
  final PersonalModel personal;
  final Future<void> Function(String) launch;
  const _ActionRow({required this.personal, required this.launch});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        FilledButton.icon(
          onPressed: () => launch(personal.github),
          icon: SvgPicture.asset('assets/icons/github.svg',
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(cs.onPrimary, BlendMode.srcIn)),
          label: const Text('GitHub'),
        ),
        FilledButton.tonalIcon(
          onPressed: () => launch(personal.linkedin),
          icon: SvgPicture.asset('assets/icons/linkedin.svg',
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(
                  cs.onSecondaryContainer, BlendMode.srcIn)),
          label: const Text('LinkedIn'),
        ),
        OutlinedButton.icon(
          onPressed: () => launch('mailto:${personal.email}'),
          icon: const Icon(Icons.email_outlined, size: 18),
          label: const Text('Email Me'),
        ),
      ],
    );
  }
}
