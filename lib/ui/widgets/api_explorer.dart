import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/resume_model.dart';
import 'glass_card.dart';

class ApiExplorer extends StatefulWidget {
  final ResumeModel resumeData;

  const ApiExplorer({super.key, required this.resumeData});

  @override
  State<ApiExplorer> createState() => _ApiExplorerState();
}

class _ApiExplorerState extends State<ApiExplorer> {
  String _selectedEndpoint = '/api/v1/personal';
  String _responseBody = '';
  bool _isLoading = false;

  final Map<String, dynamic> _endpoints = {
    '/api/v1/personal': 'personal',
    '/api/v1/skills': 'skills',
    '/api/v1/education': 'education',
    '/api/v1/experience': 'experience',
    '/api/v1/projects': 'projects',
    '/api/v1/certificates': 'certificates',
  };

  Future<void> _invokeEndpoint() async {
    setState(() {
      _isLoading = true;
      _responseBody = '';
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final Map<String, dynamic> jsonMap = widget.resumeData.toJson();
    final String key = _endpoints[_selectedEndpoint]!;
    
    const jsonEncoder = JsonEncoder.withIndent('  ');
    
    setState(() {
      _responseBody = jsonEncoder.convert(jsonMap[key]);
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _invokeEndpoint();
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'GET',
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedEndpoint,
                      isExpanded: true,
                      items: _endpoints.keys.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedEndpoint = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _invokeEndpoint,
                child: const Text('Send'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Response:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black54
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(16),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: SelectableText(
                      _responseBody,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
