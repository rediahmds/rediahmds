import 'package:flutter/material.dart';
import 'package:portofolio/models/resume_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The hero/header card displayed at the top of the portfolio.
/// Uses an M3 ElevatedCard for maximum visual emphasis.
class HeroSection extends StatelessWidget {
  final PersonalModel personal;

  const HeroSection({super.key, required this.personal});

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDesktop = MediaQuery.sizeOf(context).width > 800;

    return Card(
      elevation: 2,
      color: cs.surfaceContainerLow,
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 40 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Avatar + Name row ---
            _buildIdentity(context, cs, tt, isDesktop),
            const SizedBox(height: 32),

            // --- Bio ---
            Text(
              personal.bio,
              style: tt.bodyLarge?.copyWith(
                height: 1.7,
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            // --- Action buttons ---
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton.icon(
                  onPressed: () => _launchUrl(personal.github),
                  icon: SvgPicture.asset(
                    'assets/icons/github.svg',
                    width: 18,
                    height: 18,
                    colorFilter: ColorFilter.mode(cs.onPrimary, BlendMode.srcIn),
                  ),
                  label: const Text('GitHub'),
                ),
                FilledButton.tonalIcon(
                  onPressed: () => _launchUrl(personal.linkedin),
                  icon: SvgPicture.asset(
                    'assets/icons/linkedin.svg',
                    width: 18,
                    height: 18,
                    colorFilter: ColorFilter.mode(
                      cs.onSecondaryContainer,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: const Text('LinkedIn'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _launchUrl('mailto:${personal.email}'),
                  icon: const Icon(Icons.email_outlined),
                  label: Text(personal.email),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdentity(
    BuildContext context,
    ColorScheme cs,
    TextTheme tt,
    bool isDesktop,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Profile image with M3 shape token
        Container(
          width: isDesktop ? 96 : 72,
          height: isDesktop ? 96 : 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: cs.primaryContainer,
              width: 3,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(21),
            child: Image.asset(
              'assets/me.png',
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                personal.name,
                style: isDesktop
                    ? tt.displaySmall
                    : tt.headlineMedium,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: cs.tertiaryContainer,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  personal.title,
                  style: tt.labelLarge?.copyWith(
                    color: cs.onTertiaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
