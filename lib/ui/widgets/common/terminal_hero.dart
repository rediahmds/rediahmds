import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A playful M3-styled terminal widget with typing animation.
///
/// Simulates a backend developer's console with color-coded output
/// and a blinking cursor. Uses M3 surface tokens and expressive shapes.
class TerminalHero extends StatefulWidget {
  const TerminalHero({super.key});

  @override
  State<TerminalHero> createState() => _TerminalHeroState();
}

class _TerminalHeroState extends State<TerminalHero> {
  final List<_TerminalLine> _visibleLines = [];
  int _currentLineIndex = 0;
  int _currentCharIndex = 0;
  Timer? _typingTimer;
  bool _cursorVisible = true;
  Timer? _cursorTimer;

  // Lines to type out — simulates a Go backend dev workflow
  static const _lines = [
    _TerminalLine('❯ ', 'go run ./cmd/server', _LineType.command),
    _TerminalLine('  ', '🚀 Server starting on :8080', _LineType.success),
    _TerminalLine('  ', '📦 Connected to PostgreSQL', _LineType.info),
    _TerminalLine('  ', '🔌 MQTT broker linked', _LineType.info),
    _TerminalLine('  ', '✅ All services healthy', _LineType.success),
    _TerminalLine('❯ ', 'curl /api/v1/health | jq', _LineType.command),
    _TerminalLine('  ', '{ "status": "ok", "uptime": "99.9%" }', _LineType.json),
  ];

  @override
  void initState() {
    super.initState();
    // Start cursor blink
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 530), (_) {
      if (mounted) setState(() => _cursorVisible = !_cursorVisible);
    });
    // Start typing after a short delay
    Future.delayed(const Duration(milliseconds: 800), _startTyping);
  }

  void _startTyping() {
    if (!mounted || _currentLineIndex >= _lines.length) return;

    // Add current line as empty (will fill char by char)
    final line = _lines[_currentLineIndex];
    if (_currentCharIndex == 0) {
      _visibleLines.add(_TerminalLine(line.prompt, '', line.type));
    }

    _typingTimer = Timer.periodic(
      Duration(milliseconds: line.type == _LineType.command ? 45 : 18),
      (timer) {
        if (!mounted) { timer.cancel(); return; }

        final fullText = line.text;
        if (_currentCharIndex < fullText.length) {
          setState(() {
            _visibleLines.last = _TerminalLine(
              line.prompt,
              fullText.substring(0, _currentCharIndex + 1),
              line.type,
            );
            _currentCharIndex++;
          });
        } else {
          timer.cancel();
          _currentCharIndex = 0;
          _currentLineIndex++;

          // Pause between lines, then continue
          final delay = line.type == _LineType.command ? 400 : 200;
          Future.delayed(Duration(milliseconds: delay), _startTyping);
        }
      },
    );
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final monoStyle = GoogleFonts.firaCode(fontSize: 13, height: 1.7);

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? cs.surfaceContainerHighest
            : const Color(0xFF1E1E2E),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(20),
        ),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.3),
        ),
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
        children: [
          // --- Title bar ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                // Traffic light dots
                Container(width: 12, height: 12,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF5F57), shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Container(width: 12, height: 12,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFBD2E), shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Container(width: 12, height: 12,
                  decoration: const BoxDecoration(
                    color: Color(0xFF28C840), shape: BoxShape.circle)),
                const SizedBox(width: 16),
                Text(
                  '~/portfolio — zsh',
                  style: monoStyle.copyWith(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // --- Terminal body ---
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._visibleLines.asMap().entries.map((entry) {
                  final line = entry.value;
                  final isLast = entry.key == _visibleLines.length - 1;

                  return RichText(
                    text: TextSpan(
                      children: [
                        // Prompt
                        TextSpan(
                          text: line.prompt,
                          style: monoStyle.copyWith(
                            color: _promptColor(line.type, cs),
                          ),
                        ),
                        // Text content
                        TextSpan(
                          text: line.text,
                          style: monoStyle.copyWith(
                            color: _textColor(line.type, cs),
                          ),
                        ),
                        // Blinking cursor on the last line
                        if (isLast && _currentLineIndex < _lines.length)
                          TextSpan(
                            text: _cursorVisible ? '█' : ' ',
                            style: monoStyle.copyWith(
                              color: cs.primary,
                            ),
                          ),
                      ],
                    ),
                  );
                }),
                // Final cursor after all lines are typed
                if (_currentLineIndex >= _lines.length)
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '❯ ',
                          style: monoStyle.copyWith(color: cs.primary),
                        ),
                        TextSpan(
                          text: _cursorVisible ? '█' : ' ',
                          style: monoStyle.copyWith(color: cs.primary),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _promptColor(_LineType type, ColorScheme cs) {
    return switch (type) {
      _LineType.command => cs.primary,
      _ => Colors.transparent,
    };
  }

  Color _textColor(_LineType type, ColorScheme cs) {
    return switch (type) {
      _LineType.command => Colors.white.withValues(alpha: 0.9),
      _LineType.success => const Color(0xFFA6E3A1),
      _LineType.info => const Color(0xFF89B4FA),
      _LineType.json => const Color(0xFFF9E2AF),
    };
  }
}

// ---------------------------------------------------------------------------
// Data types
// ---------------------------------------------------------------------------

enum _LineType { command, success, info, json }

class _TerminalLine {
  final String prompt;
  final String text;
  final _LineType type;
  const _TerminalLine(this.prompt, this.text, this.type);
}
