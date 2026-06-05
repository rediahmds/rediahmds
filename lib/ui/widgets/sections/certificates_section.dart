import 'package:flutter/material.dart';
import 'package:portofolio/models/resume_model.dart';
import '../common/section_header.dart';
import '../common/scroll_reveal.dart';
import '../common/hover_surface.dart';
import 'package:url_launcher/url_launcher.dart';

/// Certificates with staggered entrance and hover-interactive outlined cards.
class CertificatesSection extends StatelessWidget {
  final List<CertificateModel> certificates;
  const CertificatesSection({super.key, required this.certificates});

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Certificates', icon: Icons.workspace_premium_outlined),
        LayoutBuilder(builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;
          final isMedium = constraints.maxWidth > 500;
          final cols = isDesktop ? 3 : (isMedium ? 2 : 1);
          const gap = 16.0;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: certificates.asMap().entries.map((entry) {
              final w = cols > 1
                  ? (constraints.maxWidth - gap * (cols - 1)) / cols
                  : constraints.maxWidth;
              return ScrollReveal(
                delay: Duration(milliseconds: 80 * entry.key),
                child: SizedBox(
                  width: w,
                  child: _CertCard(
                    cert: entry.value,
                    onVerify: () => _launchUrl(entry.value.url),
                    index: entry.key,
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}

class _CertCard extends StatelessWidget {
  final CertificateModel cert;
  final VoidCallback onVerify;
  final int index;
  const _CertCard({required this.cert, required this.onVerify, required this.index});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // Alternating shapes for visual variety
    final shape = index % 3 == 0
        ? ExpressiveShapes.asymmetricA
        : index % 3 == 1
            ? ExpressiveShapes.asymmetricB
            : ExpressiveShapes.pillClip;

    return HoverSurface(
      borderRadius: shape,
      color: cs.surface,
      hoverColor: cs.surfaceContainerLow,
      elevation: 0,
      hoverElevation: 3,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.verified, color: cs.tertiary),
            const SizedBox(width: 12),
            Expanded(child: Text(cert.name, style: tt.titleSmall)),
          ]),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(cert.date, style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
            FilledButton.tonal(onPressed: onVerify, child: const Text('Verify')),
          ]),
        ],
      ),
    );
  }
}
