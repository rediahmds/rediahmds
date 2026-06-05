import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Animates a child into view when it scrolls into the viewport.
///
/// Listens to the **ancestor** [Scrollable]'s position (not child
/// notifications) so it correctly detects scroll events from a parent
/// [SingleChildScrollView] or [ListView].
class ScrollReveal extends StatefulWidget {
  final Widget child;

  /// Delay before the animation starts (for staggering within a list).
  final Duration delay;

  /// Duration of the entrance animation.
  final Duration duration;

  /// Starting offset for the slide-in (positive y = from below).
  final Offset slideOffset;

  const ScrollReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
    this.slideOffset = const Offset(0, 40),
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;
  bool _hasAnimated = false;
  ScrollPosition? _scrollPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _opacity = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _offset = Tween<Offset>(
      begin: widget.slideOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Detach from previous scroll position if dependency changed
    _scrollPosition?.removeListener(_onScroll);

    // Attach to the ancestor scrollable's position
    final scrollable = Scrollable.maybeOf(context);
    _scrollPosition = scrollable?.position;
    _scrollPosition?.addListener(_onScroll);

    // Check visibility after this frame (handles items already in view)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _checkVisibility();
    });
  }

  void _onScroll() {
    _checkVisibility();
  }

  void _checkVisibility() {
    if (_hasAnimated || !mounted) return;

    final renderObject = context.findRenderObject();
    if (renderObject == null || renderObject is! RenderBox || !renderObject.attached) return;

    // Get the widget's position relative to the viewport
    try {
      final viewport = RenderAbstractViewport.of(renderObject);
      final revealOffset = viewport.getOffsetToReveal(renderObject, 0.0);

      if (_scrollPosition == null) return;

      final viewportHeight = _scrollPosition!.viewportDimension;
      final scrollOffset = _scrollPosition!.pixels;
      final itemTop = revealOffset.offset;

      // Visible when top edge is within viewport (with 10% bottom buffer)
      final isVisible = itemTop < scrollOffset + viewportHeight * 1.1 &&
          itemTop + renderObject.size.height > scrollOffset;

      if (isVisible) {
        _triggerAnimation();
      }
    } catch (_) {
      // If viewport detection fails (e.g., not yet laid out), skip this frame
    }
  }

  void _triggerAnimation() {
    if (_hasAnimated) return;
    _hasAnimated = true;
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: _offset.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
