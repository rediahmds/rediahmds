import 'package:flutter/material.dart';

/// M3 Expressive shape tokens — asymmetric corners that break the grid.
class ExpressiveShapes {
  ExpressiveShapes._();

  /// "Squircle" variant: top-left and bottom-right are large, others small.
  static const BorderRadius asymmetricA = BorderRadius.only(
    topLeft: Radius.circular(40),
    topRight: Radius.circular(12),
    bottomLeft: Radius.circular(12),
    bottomRight: Radius.circular(40),
  );

  /// Inverse asymmetric: top-right and bottom-left are large.
  static const BorderRadius asymmetricB = BorderRadius.only(
    topLeft: Radius.circular(12),
    topRight: Radius.circular(40),
    bottomLeft: Radius.circular(40),
    bottomRight: Radius.circular(12),
  );

  /// One dramatic corner (top-left) with soft others.
  static const BorderRadius heroShape = BorderRadius.only(
    topLeft: Radius.circular(48),
    topRight: Radius.circular(16),
    bottomLeft: Radius.circular(16),
    bottomRight: Radius.circular(32),
  );

  /// Pill-like but with one flat corner.
  static const BorderRadius pillClip = BorderRadius.only(
    topLeft: Radius.circular(32),
    topRight: Radius.circular(8),
    bottomLeft: Radius.circular(32),
    bottomRight: Radius.circular(8),
  );

  /// Standard large radius for non-expressive cards.
  static final BorderRadius roundedLarge = BorderRadius.circular(28);
}

/// A reusable animated surface that provides:
/// - Scale-up on hover (1.02x)
/// - Elevation shift on hover
/// - Surface tint color shift on hover
/// - Optional asymmetric M3 Expressive shape
///
/// Wrap any Card-like content with this for interactive web feel.
class HoverSurface extends StatefulWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final Color? color;
  final Color? hoverColor;
  final double elevation;
  final double hoverElevation;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Duration duration;

  const HoverSurface({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(28)),
    this.color,
    this.hoverColor,
    this.elevation = 0,
    this.hoverElevation = 4,
    this.padding = const EdgeInsets.all(24),
    this.onTap,
    this.duration = const Duration(milliseconds: 250),
  });

  @override
  State<HoverSurface> createState() => _HoverSurfaceState();
}

class _HoverSurfaceState extends State<HoverSurface> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final baseColor = widget.color ?? cs.surfaceContainerLow;
    final hoverColor = widget.hoverColor ?? cs.surfaceContainer;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: widget.duration,
          curve: Curves.easeOutCubic,
          transform: Matrix4.diagonal3Values(
            _hovered ? 1.02 : 1.0,
            _hovered ? 1.02 : 1.0,
            1.0,
          ),
          transformAlignment: Alignment.center,
          child: AnimatedPhysicalModel(
            duration: widget.duration,
            curve: Curves.easeOutCubic,
            elevation: _hovered ? widget.hoverElevation : widget.elevation,
            color: _hovered ? hoverColor : baseColor,
            shadowColor: cs.shadow,
            shape: BoxShape.rectangle,
            borderRadius: widget.borderRadius,
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: widget.padding,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
