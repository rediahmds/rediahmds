import 'package:flutter/material.dart';
import 'package:portofolio/models/resume_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../common/floating_shapes.dart';
import '../common/terminal_hero.dart';

/// Immersive hero section with:
/// - Floating M3-colored abstract shapes behind content
/// - Display-scale typography acting as a graphical element
/// - Overlapping profile image that breaks the card boundary
/// - Staggered entrance animations
class HeroSection extends StatefulWidget {
  final PersonalModel personal;

  const HeroSection({super.key, required this.personal});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;
  late final Animation<double> _scaleIn;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeIn = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _slideUp = Tween<Offset>(
      begin: const Offset(0, 50),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.1, 0.8, curve: Curves.easeOutCubic),
    ));

    _scaleIn = Tween<double>(begin: 0.92, end: 1.0).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
    ));

    // Start entrance animation
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _entranceController.forward();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

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

    return AnimatedBuilder(
      animation: _entranceController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeIn.value,
          child: Transform.translate(
            offset: _slideUp.value,
            child: Transform.scale(
              scale: _scaleIn.value,
              child: child,
            ),
          ),
        );
      },
      child: SizedBox(
        height: isDesktop ? 520 : null,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // --- Floating background shapes ---
            if (isDesktop)
              const Positioned.fill(
                child: FloatingShapes(),
              ),

            // --- Main hero card with expressive shape ---
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      cs.surfaceContainerLow,
                      cs.surfaceContainer,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(48),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(48),
                  ),
                  border: Border.all(
                    color: cs.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),

            // --- Content ---
            Padding(
              padding: EdgeInsets.all(isDesktop ? 48 : 28),
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildIdentity(context, cs, tt, isDesktop),
                              const SizedBox(height: 24),
                              Expanded(
                                child: _buildBio(context, cs, tt, isDesktop),
                              ),
                              const SizedBox(height: 20),
                              _buildActions(context, cs),
                            ],
                          ),
                        ),
                        const SizedBox(width: 32),
                        SizedBox(
                          width: 280,
                          height: 340,
                          child: TerminalHero(),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildIdentity(context, cs, tt, isDesktop),
                        SizedBox(height: isDesktop ? 32 : 24),
                        _buildBio(context, cs, tt, isDesktop),
                        const SizedBox(height: 32),
                        _buildActions(context, cs),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 240,
                          child: TerminalHero(),
                        ),
                      ],
                    ),
            ),

            // --- Overlapping decorative element (top-right) ---
            if (isDesktop)
              Positioned(
                top: -12,
                right: -12,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: cs.tertiaryContainer.withValues(alpha: 0.6),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                ),
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
        // Profile image with asymmetric border
        Container(
          width: isDesktop ? 110 : 76,
          height: isDesktop ? 110 : 76,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(32),
            ),
            border: Border.all(color: cs.primaryContainer, width: 3),
            boxShadow: [
              BoxShadow(
                color: cs.primary.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(29),
              topRight: Radius.circular(9),
              bottomLeft: Radius.circular(9),
              bottomRight: Radius.circular(29),
            ),
            child: Image.asset(
              'assets/me.png',
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
            ),
          ),
        ),
        const SizedBox(width: 28),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Immersive display text — acts as graphical element
              Text(
                widget.personal.name,
                style: (isDesktop ? tt.displayMedium : tt.headlineLarge)
                    ?.copyWith(
                  height: 1.1,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 12),
              // Title badge with asymmetric shape
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      cs.tertiaryContainer,
                      cs.secondaryContainer,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Text(
                  widget.personal.title,
                  style: tt.labelLarge?.copyWith(
                    color: cs.onTertiaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBio(
    BuildContext context,
    ColorScheme cs,
    TextTheme tt,
    bool isDesktop,
  ) {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: cs.primary.withValues(alpha: 0.4),
            width: 3,
          ),
        ),
      ),
      child: Text(
        widget.personal.bio,
        style: tt.bodyLarge?.copyWith(
          height: 1.8,
          color: cs.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, ColorScheme cs) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        FilledButton.icon(
          onPressed: () => _launchUrl(widget.personal.github),
          icon: SvgPicture.asset(
            'assets/icons/github.svg',
            width: 18, height: 18,
            colorFilter: ColorFilter.mode(cs.onPrimary, BlendMode.srcIn),
          ),
          label: const Text('GitHub'),
        ),
        FilledButton.tonalIcon(
          onPressed: () => _launchUrl(widget.personal.linkedin),
          icon: SvgPicture.asset(
            'assets/icons/linkedin.svg',
            width: 18, height: 18,
            colorFilter: ColorFilter.mode(
              cs.onSecondaryContainer, BlendMode.srcIn,
            ),
          ),
          label: const Text('LinkedIn'),
        ),
        OutlinedButton.icon(
          onPressed: () => _launchUrl('mailto:${widget.personal.email}'),
          icon: const Icon(Icons.email_outlined),
          label: Text(widget.personal.email),
        ),
      ],
    );
  }
}
