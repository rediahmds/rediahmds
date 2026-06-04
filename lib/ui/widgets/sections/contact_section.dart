import 'dart:convert';
import 'package:flutter/material.dart';
import '../common/section_header.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});
  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);
      final payload = {
        'sender_name': _nameController.text,
        'sender_email': _emailController.text,
        'message_body': _messageController.text,
        'submitted_at': DateTime.now().toIso8601String(),
      };
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isSubmitting = false);
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            icon: Icon(Icons.check_circle_outline, color: Theme.of(ctx).colorScheme.primary, size: 48),
            title: const Text('Message Sent'),
            content: Text('Simulated POST payload:\n\n${const JsonEncoder.withIndent("  ").convert(payload)}'),
            actions: [
              FilledButton(
                onPressed: () { Navigator.pop(ctx); _nameController.clear(); _emailController.clear(); _messageController.clear(); },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  void dispose() { _nameController.dispose(); _emailController.dispose(); _messageController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Contact Me', icon: Icons.mail_outline),
        Card(
          elevation: 1, color: cs.surfaceContainerLow,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.person_outline)),
                    validator: (v) => (v == null || v.isEmpty) ? 'Please enter your name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Please enter your email';
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) return 'Please enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _messageController,
                    decoration: const InputDecoration(labelText: 'Message', alignLabelWithHint: true),
                    maxLines: 5,
                    validator: (v) => (v == null || v.isEmpty) ? 'Please enter a message' : null,
                  ),
                  const SizedBox(height: 28),
                  FilledButton.icon(
                    onPressed: _isSubmitting ? null : _submitForm,
                    icon: _isSubmitting
                        ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: cs.onPrimary))
                        : const Icon(Icons.send_rounded),
                    label: const Text('Submit to /api/v1/contact'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
