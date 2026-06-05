import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Floating M3-colored abstract shapes that drift slowly behind hero content.
/// Creates depth and visual interest without performance-heavy filters.
class FloatingShapes extends StatefulWidget {
  const FloatingShapes({super.key});

  @override
  State<FloatingShapes> createState() => _FloatingShapesState();
}

class _FloatingShapesState extends State<FloatingShapes>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return Stack(
          children: [
            // Large primary pill — slow drift right-to-left
            _FloatingShape(
              t: t,
              baseX: 0.7,
              baseY: 0.2,
              driftX: -0.08,
              driftY: 0.06,
              rotation: t * math.pi * 0.3,
              color: cs.primaryContainer.withValues(alpha: 0.3),
              width: 220,
              height: 80,
              borderRadius: BorderRadius.circular(50),
            ),
            // Medium secondary circle — float upward
            _FloatingShape(
              t: t,
              baseX: 0.15,
              baseY: 0.6,
              driftX: 0.05,
              driftY: -0.1,
              rotation: -t * math.pi * 0.5,
              color: cs.secondaryContainer.withValues(alpha: 0.25),
              width: 140,
              height: 140,
              borderRadius: BorderRadius.circular(70),
            ),
            // Small tertiary squircle — wobble
            _FloatingShape(
              t: t,
              baseX: 0.5,
              baseY: 0.7,
              driftX: 0.04,
              driftY: 0.03,
              rotation: t * math.pi * 0.8,
              color: cs.tertiaryContainer.withValues(alpha: 0.2),
              width: 100,
              height: 100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(40),
              ),
            ),
            // Tiny primary accent dot
            _FloatingShape(
              t: t,
              baseX: 0.85,
              baseY: 0.55,
              driftX: -0.03,
              driftY: -0.05,
              rotation: -t * math.pi,
              color: cs.primary.withValues(alpha: 0.15),
              width: 60,
              height: 60,
              borderRadius: BorderRadius.circular(30),
            ),
          ],
        );
      },
    );
  }
}

class _FloatingShape extends StatelessWidget {
  final double t;
  final double baseX;
  final double baseY;
  final double driftX;
  final double driftY;
  final double rotation;
  final Color color;
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const _FloatingShape({
    required this.t,
    required this.baseX,
    required this.baseY,
    required this.driftX,
    required this.driftY,
    required this.rotation,
    required this.color,
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    // Smooth sinusoidal drift
    final x = baseX + math.sin(t * 2 * math.pi) * driftX;
    final y = baseY + math.cos(t * 2 * math.pi) * driftY;

    return Positioned(
      left: x * MediaQuery.sizeOf(context).width - width / 2,
      top: y * MediaQuery.sizeOf(context).height - height / 2,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius,
          ),
        ),
      ),
    );
  }
}
