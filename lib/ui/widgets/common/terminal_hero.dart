import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// M3-styled terminal widget with char-by-char typing animation.
///
/// **Overflow safety:** relies on its parent giving it a tight width
/// constraint (e.g. `SizedBox(width: double.infinity, …)`). Internally
/// each text line is wrapped in a `Text.rich` (not bare `RichText`) so
/// the Flutter layout engine enforces the parent's max-width and wraps
/// long lines instead of overflowing.
class TerminalHero extends StatefulWidget {
  const TerminalHero({super.key});

  @override
  State<TerminalHero> createState() => _TerminalHeroState();
}

class _TerminalHeroState extends State<TerminalHero> {
  final List<_TLine> _visible = [];
  int _lineIdx = 0;
  int _charIdx = 0;
  Timer? _typeTimer;
  Timer? _cursorTimer;
  bool _cursorOn = true;

  // Short, intentionally concise lines — long strings risk overflow on
  // phones narrower than 320 px even with wrapping enabled.
  static const _script = [
    _TLine('❯ ', 'go run ./cmd/server', _T.cmd),
    _TLine('  ', '🚀 Server ready :8080', _T.ok),
    _TLine('  ', '📦 PostgreSQL connected', _T.info),
    _TLine('  ', '🔌 MQTT broker linked', _T.info),
    _TLine('  ', '✅ All services healthy', _T.ok),
    _TLine('❯ ', 'curl /api/v1/health', _T.cmd),
    _TLine('  ', '{ "status": "ok" }', _T.json),
  ];

  @override
  void initState() {
    super.initState();
    _cursorTimer = Timer.periodic(
      const Duration(milliseconds: 530),
      (_) { if (mounted) setState(() => _cursorOn = !_cursorOn); },
    );
    Future.delayed(const Duration(milliseconds: 700), _type);
  }

  void _type() {
    if (!mounted || _lineIdx >= _script.length) return;
    final line = _script[_lineIdx];
    if (_charIdx == 0) setState(() => _visible.add(_TLine(line.p, '', line.t)));

    _typeTimer = Timer.periodic(
      Duration(milliseconds: line.t == _T.cmd ? 48 : 20),
      (t) {
        if (!mounted) { t.cancel(); return; }
        if (_charIdx < line.text.length) {
          setState(() {
            _visible.last = _TLine(line.p, line.text.substring(0, ++_charIdx), line.t);
          });
        } else {
          t.cancel();
          _charIdx = 0;
          _lineIdx++;
          Future.delayed(
            Duration(milliseconds: line.t == _T.cmd ? 380 : 180),
            _type,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ClipRect guarantees nothing escapes the box even if a font renders
    // a character slightly wider than expected (emoji, CJK fallback, etc.).
    return ClipRect(
      child: Container(
        // Expand to the tight width given by the parent SizedBox.
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? cs.surfaceContainerHighest : const Color(0xFF1E1E2E),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(20),
          ),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitleBar(isDark, cs),
            _buildBody(cs),
          ],
        ),
      ),
    );
  }

  // ── Title bar ──────────────────────────────────────────────────────────────

  Widget _buildTitleBar(bool isDark, ColorScheme cs) {
    final style = GoogleFonts.jetBrainsMono(
      fontSize: 11,
      color: Colors.white.withValues(alpha: 0.5),
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: isDark
            ? cs.surfaceContainerHighest.withValues(alpha: 0.7)
            : const Color(0xFF181825),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          _dot(const Color(0xFFFF5F57)),
          const SizedBox(width: 7),
          _dot(const Color(0xFFFFBD2E)),
          const SizedBox(width: 7),
          _dot(const Color(0xFF28C840)),
          const SizedBox(width: 14),
          // Expanded clips the text before it can push past the row.
          Expanded(
            child: Text(
              '~/portfolio — zsh',
              style: style,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color c) => Container(
        width: 11, height: 11,
        decoration: BoxDecoration(color: c, shape: BoxShape.circle),
      );

  // ── Body ───────────────────────────────────────────────────────────────────

  Widget _buildBody(ColorScheme cs) {
    final mono = GoogleFonts.jetBrainsMono(fontSize: 12.5, height: 1.65);

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._visible.asMap().entries.map((e) {
            final line = e.value;
            final isLast = e.key == _visible.length - 1;
            final showCursor = isLast && _lineIdx < _script.length;

            return Padding(
              padding: const EdgeInsets.only(bottom: 1),
              // Text.rich — unlike bare RichText, it uses the layout
              // constraints from its parent directly and wraps naturally
              // when the available width is tight.
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: line.p,
                    style: mono.copyWith(color: _promptColor(line.t, cs)),
                  ),
                  TextSpan(
                    text: line.text,
                    style: mono.copyWith(color: _textColor(line.t)),
                  ),
                  if (showCursor)
                    TextSpan(
                      text: _cursorOn ? '█' : ' ',
                      style: mono.copyWith(color: cs.primary),
                    ),
                ]),
                softWrap: true,
                overflow: TextOverflow.clip,
              ),
            );
          }),
          // Idle cursor after all lines are typed
          if (_lineIdx >= _script.length)
            Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: '❯ ',
                  style: mono.copyWith(color: cs.primary),
                ),
                TextSpan(
                  text: _cursorOn ? '█' : ' ',
                  style: mono.copyWith(color: cs.primary),
                ),
              ]),
            ),
        ],
      ),
    );
  }

  Color _promptColor(_T t, ColorScheme cs) =>
      t == _T.cmd ? cs.primary : Colors.transparent;

  Color _textColor(_T t) => switch (t) {
        _T.cmd  => Colors.white.withValues(alpha: 0.9),
        _T.ok   => const Color(0xFFA6E3A1),
        _T.info => const Color(0xFF89B4FA),
        _T.json => const Color(0xFFF9E2AF),
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// Types
// ─────────────────────────────────────────────────────────────────────────────

enum _T { cmd, ok, info, json }

class _TLine {
  final String p;     // prompt prefix
  final String text;
  final _T t;         // line type
  const _TLine(this.p, this.text, this.t);
}
