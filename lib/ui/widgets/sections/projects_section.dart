import 'package:flutter/material.dart';
import 'package:portofolio/models/resume_model.dart';
import '../common/section_header.dart';
import '../common/scroll_reveal.dart';
import '../common/hover_surface.dart' show HoverSurface, ExpressiveShapes;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Architecture node data — maps each project to a visual tech flow
// ─────────────────────────────────────────────────────────────────────────────

class _TechNode {
  final IconData icon;
  final String label;
  final Color color;
  const _TechNode(this.icon, this.label, this.color);
}

class _ArchFlow {
  final List<_TechNode> nodes;
  const _ArchFlow(this.nodes);
}

// Per-project architecture flow definitions
const _projectFlows = <String, _ArchFlow>{
  'EcoSort': _ArchFlow([
    _TechNode(Icons.videocam_rounded, 'ESP32\nCamera', Color(0xFF00979D)),
    _TechNode(Icons.psychology_rounded, 'ResNet50\nPython', Color(0xFF3776AB)),
    _TechNode(Icons.cloud_sync_rounded, 'MQTT\nBroker', Color(0xFFFF6600)),
    _TechNode(Icons.dashboard_rounded, 'Blynk\nDashboard', Color(0xFF00B4D8)),
  ]),
  'Narrativa': _ArchFlow([
    _TechNode(Icons.smartphone_rounded, 'Flutter\nAndroid', Color(0xFF02569B)),
    _TechNode(Icons.route_rounded, 'go_router\nNav', Color(0xFF00ADD8)),
    _TechNode(Icons.api_rounded, 'REST\nAPI', Color(0xFF6DB33F)),
    _TechNode(Icons.map_rounded, 'Google\nMaps', Color(0xFF34A853)),
  ]),
  'pH Monitor': _ArchFlow([
    _TechNode(Icons.memory_rounded, 'ESP32\nSensor', Color(0xFF00979D)),
    _TechNode(Icons.bolt_rounded, 'FastAPI\nPython', Color(0xFF009688)),
    _TechNode(Icons.storage_rounded, 'SQLite\nORM', Color(0xFF4169E1)),
    _TechNode(Icons.bar_chart_rounded, 'ApexCharts\nJS', Color(0xFFF7DF1E)),
  ]),
  'OpenMusic': _ArchFlow([
    _TechNode(Icons.music_note_rounded, 'Hapi.js\nAPI', Color(0xFFF7A00A)),
    _TechNode(Icons.storage_rounded, 'PostgreSQL', Color(0xFF4169E1)),
    _TechNode(Icons.swap_horiz_rounded, 'RabbitMQ', Color(0xFFFF6600)),
    _TechNode(Icons.bolt_rounded, 'Redis\nCache', Color(0xFFFF4438)),
  ]),
};

/// Resolves a project name to its arch flow by fuzzy key matching.
_ArchFlow? _resolveFlow(String name) {
  for (final key in _projectFlows.keys) {
    if (name.toLowerCase().contains(key.toLowerCase())) {
      return _projectFlows[key];
    }
  }
  return null;
}

// ─────────────────────────────────────────────────────────────────────────────
// Section
// ─────────────────────────────────────────────────────────────────────────────

class ProjectsSection extends StatelessWidget {
  final List<ProjectModel> projects;
  const ProjectsSection({super.key, required this.projects});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Projects', icon: Icons.rocket_launch_outlined),
        LayoutBuilder(builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 700;
          const gap = 16.0;

          if (!isDesktop) {
            return Column(
              children: projects.asMap().entries.map((e) => ScrollReveal(
                    delay: Duration(milliseconds: 100 * e.key),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: gap),
                      child: _ProjectCard(
                        project: e.value,
                        onGitHub: () => _launchUrl(e.value.github),
                        isFeature: false,
                        index: e.key,
                      ),
                    ),
                  )).toList(),
            );
          }

          // Desktop: feature card (full-width) + 2-col grid
          final feature = projects.isNotEmpty ? projects.first : null;
          final rest = projects.length > 1 ? projects.sublist(1) : <ProjectModel>[];
          final halfWidth = (constraints.maxWidth - gap) / 2;

          return Column(
            children: [
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
              Wrap(
                spacing: gap,
                runSpacing: gap,
                children: rest.asMap().entries.map((e) => ScrollReveal(
                      delay: Duration(milliseconds: 100 * (e.key + 1)),
                      child: SizedBox(
                        width: halfWidth,
                        child: _ProjectCard(
                          project: e.value,
                          onGitHub: () => _launchUrl(e.value.github),
                          isFeature: false,
                          index: e.key + 1,
                        ),
                      ),
                    )).toList(),
              ),
            ],
          );
        }),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Project card — architecture flow replaces text bullets
// ─────────────────────────────────────────────────────────────────────────────

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

    final shape = isFeature
        ? ExpressiveShapes.heroShape
        : index.isEven
            ? ExpressiveShapes.asymmetricA
            : ExpressiveShapes.asymmetricB;

    final flow = _resolveFlow(project.name);

    return HoverSurface(
      borderRadius: shape,
      color: isFeature ? cs.surfaceContainer : cs.surfaceContainerLow,
      hoverColor: isFeature ? cs.surfaceContainerHigh : cs.surfaceContainer,
      elevation: isFeature ? 2 : 0,
      hoverElevation: isFeature ? 8 : 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ──────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon badge
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
                  size: 22,
                  color: cs.onPrimaryContainer,
                ),
              ),
              Row(
                children: [
                  // Period badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      project.period,
                      style: tt.labelSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // GitHub button
                  IconButton.filledTonal(
                    onPressed: onGitHub,
                    icon: SvgPicture.asset(
                      'assets/icons/github.svg',
                      width: 16, height: 16,
                      colorFilter: ColorFilter.mode(
                          cs.onSecondaryContainer, BlendMode.srcIn),
                    ),
                    tooltip: 'View Source',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Project name ────────────────────────────────────────────────
          Text(
            project.name,
            style: (isFeature ? tt.titleLarge : tt.titleMedium)?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),

          // ── Architecture flow — replaces all bullet text ─────────────────
          if (flow != null) _ArchFlowWidget(flow: flow, isFeature: isFeature)
          else _FallbackChips(bullets: project.bullets),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Architecture flow widget — horizontal node chain with animated connectors
// ─────────────────────────────────────────────────────────────────────────────

class _ArchFlowWidget extends StatelessWidget {
  final _ArchFlow flow;
  final bool isFeature;
  const _ArchFlowWidget({required this.flow, required this.isFeature});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < flow.nodes.length; i++) ...[
            _TechNodeWidget(node: flow.nodes[i], isFeature: isFeature),
            if (i < flow.nodes.length - 1)
              _AnimatedConnector(color: cs.outlineVariant),
          ],
        ],
      ),
    );
  }
}

class _TechNodeWidget extends StatefulWidget {
  final _TechNode node;
  final bool isFeature;
  const _TechNodeWidget({required this.node, required this.isFeature});

  @override
  State<_TechNodeWidget> createState() => _TechNodeWidgetState();
}

class _TechNodeWidgetState extends State<_TechNodeWidget> {
  bool _hovered = false;

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
          _hovered ? 1.08 : 1.0,
          _hovered ? 1.08 : 1.0,
          1.0,
        ),
        transformAlignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.all(widget.isFeature ? 14 : 10),
          decoration: BoxDecoration(
            color: _hovered
                ? widget.node.color.withValues(alpha: 0.18)
                : cs.surfaceContainerHighest,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(6),
              bottomLeft: Radius.circular(6),
              bottomRight: Radius.circular(16),
            ),
            border: Border.all(
              color: _hovered
                  ? widget.node.color.withValues(alpha: 0.5)
                  : cs.outlineVariant.withValues(alpha: 0.4),
              width: _hovered ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.node.icon,
                  size: widget.isFeature ? 28 : 22,
                  color: widget.node.color),
              const SizedBox(height: 6),
              Text(
                widget.node.label,
                textAlign: TextAlign.center,
                style: tt.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurfaceVariant,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Animated dashed connector line between architecture nodes.
class _AnimatedConnector extends StatefulWidget {
  final Color color;
  const _AnimatedConnector({required this.color});

  @override
  State<_AnimatedConnector> createState() => _AnimatedConnectorState();
}

class _AnimatedConnectorState extends State<_AnimatedConnector>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _dash;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat();
    _dash = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.linear));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: AnimatedBuilder(
        animation: _dash,
        builder: (context, _) => CustomPaint(
          size: const Size(36, 2),
          painter: _DashPainter(
            progress: _dash.value,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  final double progress;
  final Color color;
  const _DashPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const dashWidth = 5.0;
    const dashGap = 4.0;
    const step = dashWidth + dashGap;
    final offset = progress * step;

    var x = -offset;
    while (x < size.width) {
      final start = x.clamp(0.0, size.width);
      final end = (x + dashWidth).clamp(0.0, size.width);
      if (end > start) {
        canvas.drawLine(
          Offset(start, size.height / 2),
          Offset(end, size.height / 2),
          paint,
        );
      }
      x += step;
    }
  }

  @override
  bool shouldRepaint(_DashPainter old) => old.progress != progress;
}

// ─────────────────────────────────────────────────────────────────────────────
// Fallback: if no arch flow is defined, show compact key-phrase chips
// ─────────────────────────────────────────────────────────────────────────────

class _FallbackChips extends StatelessWidget {
  final List<String> bullets;
  const _FallbackChips({required this.bullets});

  // Extract a 2–4 word key phrase from a bullet by taking the first clause
  static String _keyPhrase(String bullet) {
    final words = bullet.split(' ');
    return words.take(4).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: bullets.map((b) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              _keyPhrase(b),
              style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          )).toList(),
    );
  }
}
