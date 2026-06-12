import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portofolio/models/resume_model.dart';
import '../common/section_header.dart';
import '../common/scroll_reveal.dart';
import '../common/hover_surface.dart' show ExpressiveShapes;

class ApiExplorerSection extends StatefulWidget {
  final ResumeModel resumeData;
  const ApiExplorerSection({super.key, required this.resumeData});

  @override
  State<ApiExplorerSection> createState() => _ApiExplorerSectionState();
}

class _ApiExplorerSectionState extends State<ApiExplorerSection> {
  String _selectedEndpoint = '/api/v1/personal';
  String _responseBody = '';
  bool _isLoading = false;

  static const Map<String, String> _endpoints = {
    '/api/v1/personal': 'personal',
    '/api/v1/skills': 'skills',
    '/api/v1/education': 'education',
    '/api/v1/experience': 'experience',
    '/api/v1/projects': 'projects',
    '/api/v1/certificates': 'certificates',
  };

  @override
  void initState() {
    super.initState();
    _invokeEndpoint();
  }

  Future<void> _invokeEndpoint() async {
    setState(() { _isLoading = true; _responseBody = ''; });
    
    // Randomize delay value to mock network condition
    const max = 999;
    const min = 50;
    final randomDelay = Random().nextInt(max - min + 1);

    await Future.delayed(Duration(milliseconds: randomDelay));
    final jsonMap = widget.resumeData.toJson();
    final key = _endpoints[_selectedEndpoint]!;
    const encoder = JsonEncoder.withIndent('  ');
    setState(() { _responseBody = encoder.convert(jsonMap[key]); _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'API Explorer', icon: Icons.api_outlined),
        ScrollReveal(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [cs.surfaceContainerLow, cs.surfaceContainer],
              ),
              borderRadius: ExpressiveShapes.asymmetricB,
              border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
            ),
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: 12, runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [cs.primaryContainer, cs.primary.withValues(alpha: 0.3)]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('GET', style: tt.labelLarge?.copyWith(color: cs.onPrimaryContainer, fontWeight: FontWeight.w700)),
                    ),
                    DropdownMenu<String>(
                      initialSelection: _selectedEndpoint,
                      onSelected: (value) { if (value != null) setState(() => _selectedEndpoint = value); },
                      dropdownMenuEntries: _endpoints.keys.map((ep) => DropdownMenuEntry(value: ep, label: ep)).toList(),
                      width: 280,
                    ),
                    FilledButton.icon(
                      onPressed: _isLoading ? null : _invokeEndpoint,
                      icon: const Icon(Icons.send_rounded, size: 18),
                      label: const Text('Send'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Response', style: tt.labelLarge?.copyWith(color: cs.onSurfaceVariant)),
                const SizedBox(height: 8),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          child: SelectableText(
                            _responseBody,
                            style: GoogleFonts.jetBrainsMono(color: cs.onSurface, fontSize: 13),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
