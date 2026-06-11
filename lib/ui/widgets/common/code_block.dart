import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// An M3-styled code editor block with mock syntax highlighting,
/// a language badge, a copy button, and asymmetric expressive shape.
///
/// Shows real code snippets from the developer's actual work.
class CodeBlock extends StatefulWidget {
  final String code;
  final String language;
  final String filename;

  const CodeBlock({
    super.key,
    required this.code,
    required this.language,
    required this.filename,
  });

  @override
  State<CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends State<CodeBlock> {
  bool _copied = false;

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark
        ? cs.surfaceContainerHighest
        : const Color(0xFF1E1E2E);
    final headerColor = isDark
        ? cs.surfaceContainerHighest.withValues(alpha: 0.7)
        : const Color(0xFF181825);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(24),
        ),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- Editor header ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                // Language badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _languageColor(
                      widget.language,
                    ).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _languageColor(
                        widget.language,
                      ).withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    widget.language,
                    style: GoogleFonts.firaCode(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _languageColor(widget.language),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Filename
                Text(
                  widget.filename,
                  style: GoogleFonts.firaCode(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                const Spacer(),
                // Copy button
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _copied
                      ? Icon(
                          Icons.check_rounded,
                          size: 18,
                          key: const ValueKey('check'),
                          color: const Color(0xFFA6E3A1),
                        )
                      : IconButton(
                          key: const ValueKey('copy'),
                          onPressed: _copyToClipboard,
                          icon: const Icon(Icons.copy_rounded, size: 16),
                          color: Colors.white.withValues(alpha: 0.5),
                          tooltip: 'Copy',
                          iconSize: 18,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                ),
              ],
            ),
          ),

          // --- Code body with line numbers ---
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildHighlightedCode(cs),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedCode(ColorScheme cs) {
    final lines = widget.code.split('\n');
    final monoStyle = GoogleFonts.firaCode(fontSize: 13, height: 1.7);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.asMap().entries.map((entry) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Line number
            SizedBox(
              width: 32,
              child: Text(
                '${entry.key + 1}',
                style: monoStyle.copyWith(
                  color: Colors.white.withValues(alpha: 0.25),
                ),
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(width: 16),
            // Highlighted code line
            Expanded(child: _highlightLine(entry.value, monoStyle)),
          ],
        );
      }).toList(),
    );
  }

  /// Naive but effective syntax highlighting using regex.
  Widget _highlightLine(String line, TextStyle baseStyle) {
    final spans = <TextSpan>[];
    final trimmed = line;

    // Patterns: keywords, strings, comments, types, numbers, functions
    final patterns = [
      _SyntaxPattern(
        RegExp(r'//.*$|#.*$'),
        Colors.white.withValues(alpha: 0.35),
      ),
      // Double-quoted strings
      _SyntaxPattern(RegExp(r'"[^"]*"'), const Color(0xFFA6E3A1)),
      // Single-quoted and backtick strings
      _SyntaxPattern(RegExp(r"'[^']*'|" r'`[^`]*`'), const Color(0xFFA6E3A1)),
      _SyntaxPattern(
        RegExp(
          r'\b(func|type|struct|return|if|else|for|range|import|package|from|def|async|await|class|const|var|let|final)\b',
        ),
        const Color(0xFFCBA6F7),
      ),
      _SyntaxPattern(
        RegExp(
          r'\b(string|int|bool|float64|error|nil|null|true|false|None|self)\b',
        ),
        const Color(0xFFFFB86C),
      ),
      _SyntaxPattern(RegExp(r'\b\d+\.?\d*\b'), const Color(0xFFF9E2AF)),
    ];

    int pos = 0;
    while (pos < trimmed.length) {
      _SyntaxPattern? matched;
      RegExpMatch? earliest;

      for (final pattern in patterns) {
        final match = pattern.regex.firstMatch(trimmed.substring(pos));
        if (match != null) {
          if (earliest == null || match.start < earliest.start) {
            earliest = match;
            matched = pattern;
          }
        }
      }

      if (earliest == null || matched == null) {
        spans.add(
          TextSpan(
            text: trimmed.substring(pos),
            style: baseStyle.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        );
        break;
      }

      // Text before match
      if (earliest.start > 0) {
        spans.add(
          TextSpan(
            text: trimmed.substring(pos, pos + earliest.start),
            style: baseStyle.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        );
      }

      // Matched text
      spans.add(
        TextSpan(
          text: earliest.group(0),
          style: baseStyle.copyWith(color: matched.color),
        ),
      );

      pos += earliest.start + earliest.group(0)!.length;
    }

    return RichText(text: TextSpan(children: spans));
  }

  Color _languageColor(String lang) {
    return switch (lang.toLowerCase()) {
      'go' || 'golang' => const Color(0xFF00ADD8),
      'python' => const Color(0xFF3776AB),
      'dart' => const Color(0xFF0175C2),
      'typescript' || 'ts' => const Color(0xFF3178C6),
      'javascript' || 'js' => const Color(0xFFF7DF1E),
      'yaml' || 'dockerfile' => const Color(0xFFCB171E),
      _ => const Color(0xFF89B4FA),
    };
  }
}

class _SyntaxPattern {
  final RegExp regex;
  final Color color;
  const _SyntaxPattern(this.regex, this.color);
}
