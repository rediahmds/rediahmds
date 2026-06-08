import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portofolio/models/resume_model.dart';
import '../common/section_header.dart';
import '../common/scroll_reveal.dart';
import '../common/hover_surface.dart' show ExpressiveShapes;

/// Metadata for a single skill badge.
/// Supports both [FaIconData] (brand icons) and [IconData] (Material fallback).
class _SkillDef {
  final String name;

  /// Either an [FaIconData] or a Material [IconData].
  final dynamic icon;
  final Color brandColor;

  const _SkillDef(this.name, this.icon, this.brandColor);

  bool get isFaIcon => icon is FaIconData;
}

/// Maps skill names (from resume JSON) to their brand icon + color.
/// Uses FontAwesomeIcons for recognized brands, Material Icons otherwise.
final Map<String, _SkillDef> _skillIconMap = {
  // --- Languages ---
  'Node.js': _SkillDef(
    'Node.js',
    FontAwesomeIcons.nodeJs,
    const Color(0xFF5FA04E),
  ),
  'Python': _SkillDef(
    'Python',
    FontAwesomeIcons.python,
    const Color(0xFF3776AB),
  ),
  'Dart': _SkillDef('Dart', FontAwesomeIcons.dartLang, const Color(0xFF0175C2)),
  'JavaScript': _SkillDef(
    'JavaScript',
    FontAwesomeIcons.js,
    const Color(0xFFF7DF1E),
  ),
  'TypeScript': _SkillDef(
    'TypeScript',
    FontAwesomeIcons.typescript,
    const Color(0xFF3178C6),
  ),
  'Golang': _SkillDef(
    'Golang',
    FontAwesomeIcons.golang,
    const Color(0xFF00ADD8),
  ),
  'Arduino': _SkillDef(
    'Arduino',
    Icons.memory_rounded,
    const Color(0xFF00979D),
  ),

  // --- Backend & Cloud ---
  'Google Cloud Platform (GCP)': _SkillDef(
    'GCP',
    FontAwesomeIcons.google,
    const Color(0xFF4285F4),
  ),
  'AWS': _SkillDef('AWS', FontAwesomeIcons.aws, const Color(0xFFFF9900)),
  'PostgreSQL': _SkillDef(
    'PostgreSQL',
    Icons.storage_rounded,
    const Color(0xFF4169E1),
  ),
  'Redis': _SkillDef('Redis', Icons.bolt_rounded, const Color(0xFFFF4438)),
  'RabbitMQ': _SkillDef(
    'RabbitMQ',
    Icons.swap_horiz_rounded,
    const Color(0xFFFF6600),
  ),
  'RESTful APIs': _SkillDef(
    'REST APIs',
    Icons.api_rounded,
    const Color(0xFF6DB33F),
  ),
  'Nginx': _SkillDef('Nginx', Icons.dns_rounded, const Color(0xFF009639)),
  'Docker': _SkillDef(
    'Docker',
    FontAwesomeIcons.docker,
    const Color(0xFF2496ED),
  ),
  'Gin': _SkillDef('Gin', Icons.local_bar_rounded, const Color(0xFF00ADD8)),

  // --- Mobile ---
  'Flutter': _SkillDef(
    'Flutter',
    FontAwesomeIcons.flutter,
    const Color(0xFF02569B),
  ),
  'Provider': _SkillDef(
    'Provider',
    Icons.account_tree_rounded,
    const Color(0xFF6A1B9A),
  ),
  'Clean Architecture': _SkillDef(
    'Clean Arch',
    Icons.layers_rounded,
    const Color(0xFF00897B),
  ),
  'Google Maps Integration': _SkillDef(
    'Maps',
    Icons.map_rounded,
    const Color(0xFF34A853),
  ),

  // --- DevOps & Tools ---
  'Git (Version Control)': _SkillDef(
    'Git',
    FontAwesomeIcons.gitAlt,
    const Color(0xFFF05032),
  ),
  'GitHub Actions (CI/CD)': _SkillDef(
    'GitHub CI',
    FontAwesomeIcons.github,
    const Color(0xFF8B949E),
  ),
  'TDD (Jest)': _SkillDef(
    'TDD / Jest',
    Icons.check_circle_rounded,
    const Color(0xFFC21325),
  ),
  'Postman': _SkillDef('Postman', Icons.send_rounded, const Color(0xFFFF6C37)),
  'Hoppscotch': _SkillDef(
    'Hoppscotch',
    Icons.send_rounded,
    const Color(0xFF04C8C6),
  ),
};

/// Resolves a skill name to its definition, with a safe fallback.
_SkillDef _resolve(String name) {
  return _skillIconMap[name] ??
      _SkillDef(name, Icons.code_rounded, const Color(0xFF78909C));
}

// ---------------------------------------------------------------------------
// Category definition
// ---------------------------------------------------------------------------

class _CategoryDef {
  final String title;
  final IconData icon;
  final List<String> skills;
  final Color accentColor;

  const _CategoryDef({
    required this.title,
    required this.icon,
    required this.skills,
    required this.accentColor,
  });
}

// ---------------------------------------------------------------------------
// Main section widget
// ---------------------------------------------------------------------------

/// Expressive Skills section with brand icons, categorized Wrap layout,
/// staggered pop-in entrance, and hover micro-interactions per badge.
class SkillsSection extends StatelessWidget {
  final SkillsModel skills;
  const SkillsSection({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final categories = [
      _CategoryDef(
        title: 'Languages',
        icon: Icons.code_rounded,
        skills: skills.languages,
        accentColor: cs.primary,
      ),
      _CategoryDef(
        title: 'Backend & Cloud',
        icon: Icons.cloud_outlined,
        skills: skills.backendCloud,
        accentColor: cs.secondary,
      ),
      _CategoryDef(
        title: 'Mobile',
        icon: Icons.smartphone_rounded,
        skills: skills.mobile,
        accentColor: cs.tertiary,
      ),
      _CategoryDef(
        title: 'DevOps & Tools',
        icon: Icons.build_circle_outlined,
        skills: skills.devopsTools,
        accentColor: cs.primary,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Tech Stack', icon: Icons.code_rounded),
        ScrollReveal(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cs.surfaceContainerLowest,
                  cs.surfaceContainerLow,
                  cs.surfaceContainer,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              borderRadius: ExpressiveShapes.asymmetricA,
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < categories.length; i++) ...[
                  if (i > 0) const SizedBox(height: 32),
                  _SkillCategoryCluster(
                    category: categories[i],
                    categoryIndex: i,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SkillCategoryCluster extends StatelessWidget {
  final _CategoryDef category;
  final int categoryIndex;

  const _SkillCategoryCluster({
    required this.category,
    required this.categoryIndex,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // Base delay for this category's stagger group
    final baseDelay = categoryIndex * 250;

    return ScrollReveal(
      delay: Duration(milliseconds: categoryIndex * 100),
      slideOffset: const Offset(0, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Category title with accent line ---
          Row(
            children: [
              Container(
                width: 3,
                height: 28,
                decoration: BoxDecoration(
                  color: category.accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Icon(category.icon, size: 18, color: cs.onSurfaceVariant),
              const SizedBox(width: 8),
              Text(
                category.title,
                style: tt.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // --- Flowing badge cluster ---
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: category.skills.asMap().entries.map((entry) {
              final def = _resolve(entry.value);
              return _SkillBadge(
                def: def,
                staggerDelay: Duration(
                  milliseconds: baseDelay + entry.key * 60,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _SkillBadge extends StatefulWidget {
  final _SkillDef def;
  final Duration staggerDelay;

  const _SkillBadge({required this.def, required this.staggerDelay});

  @override
  State<_SkillBadge> createState() => _SkillBadgeState();
}

class _SkillBadgeState extends State<_SkillBadge>
    with TickerProviderStateMixin {
  // --- Entrance animation ---
  late final AnimationController _entranceController;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;

  // --- Hover animation ---
  late final AnimationController _hoverController;
  late final Animation<double> _hoverScale;
  late final Animation<double> _hoverElevation;
  late final Animation<double> _iconRotation;

  bool _hovered = false;

  @override
  void initState() {
    super.initState();

    // Entrance: scale from 0.6→1.0 + fade from 0→1
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutBack),
    );
    _fadeAnim = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );

    // Hover: subtle scale + elevation + icon rotation
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _hoverScale = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
    );
    _hoverElevation = Tween<double>(begin: 0.0, end: 6.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
    );
    _iconRotation = Tween<double>(begin: 0.0, end: 0.08).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
    );

    // Trigger entrance after stagger delay
    Future.delayed(widget.staggerDelay, () {
      if (mounted) _entranceController.forward();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool hovering) {
    if (hovering == _hovered) return;
    _hovered = hovering;
    if (hovering) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Brand color adapts to theme brightness for readability
    final brandColor = isDark
        ? Color.lerp(widget.def.brandColor, Colors.white, 0.3)!
        : widget.def.brandColor;

    // Asymmetric pill shape for M3 Expressive personality
    const badgeRadius = BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(8),
      bottomLeft: Radius.circular(8),
      bottomRight: Radius.circular(20),
    );

    return AnimatedBuilder(
      animation: Listenable.merge([_entranceController, _hoverController]),
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnim.value,
          child: Transform.scale(
            scale: _scaleAnim.value * _hoverScale.value,
            child: child,
          ),
        );
      },
      child: MouseRegion(
        onEnter: (_) => _onHoverChanged(true),
        onExit: (_) => _onHoverChanged(false),
        cursor: SystemMouseCursors.basic,
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, _) {
            return PhysicalModel(
              elevation: _hoverElevation.value,
              color: _hovered
                  ? cs.surfaceContainerHigh
                  : cs.surfaceContainerLow,
              shadowColor: cs.shadow.withValues(alpha: 0.3),
              borderRadius: badgeRadius,
              clipBehavior: Clip.antiAlias,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _hovered
                        ? brandColor.withValues(alpha: 0.4)
                        : cs.outlineVariant.withValues(alpha: 0.3),
                    width: _hovered ? 1.5 : 1.0,
                  ),
                  borderRadius: badgeRadius,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Brand icon with hover rotation
                    Transform.rotate(
                      angle: _iconRotation.value * math.pi,
                      child: _buildIcon(brandColor),
                    ),
                    const SizedBox(width: 10),
                    // Skill label
                    Text(
                      widget.def.name,
                      style: tt.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _hovered ? cs.onSurface : cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Renders the correct icon widget based on the icon type.
  Widget _buildIcon(Color color) {
    final icon = widget.def.icon;
    if (icon is FaIconData) {
      return FaIcon(icon, size: 18, color: color);
    }
    return Icon(icon as IconData, size: 20, color: color);
  }
}
