import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/resume_model.dart';
import 'package:google_fonts/google_fonts.dart';

class TerminalContent extends StatelessWidget {
  final ResumeModel resumeData;

  const TerminalContent({super.key, required this.resumeData});

  @override
  Widget build(BuildContext context) {
    const jsonEncoder = JsonEncoder.withIndent('  ');
    final jsonString = jsonEncoder.convert(resumeData.toJson());

    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.5)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 12, height: 12, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red)),
              const SizedBox(width: 8),
              Container(width: 12, height: 12, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.yellow)),
              const SizedBox(width: 8),
              Container(width: 12, height: 12, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green)),
              const SizedBox(width: 16),
              const Text('user@redi-ahmad: ~/portfolio\$ cat resume.json', style: TextStyle(color: Colors.white70, fontFamily: 'monospace')),
            ],
          ),
          const Divider(color: Colors.white24),
          SelectableText(
            jsonString,
            style: GoogleFonts.firaCode(
              color: Colors.greenAccent,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          const Text('user@redi-ahmad: ~/portfolio\$ █', style: TextStyle(color: Colors.white, fontFamily: 'monospace')),
        ],
      ),
    );
  }
}
