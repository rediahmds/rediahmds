import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/resume_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/scroll_provider.dart';
import '../widgets/sections/hero_section.dart';
import '../widgets/sections/education_section.dart';
import '../widgets/sections/skills_section.dart';
import '../widgets/sections/experience_section.dart';
import '../widgets/sections/projects_section.dart';
import '../widgets/sections/certificates_section.dart';
import '../widgets/sections/api_explorer_section.dart';
import '../widgets/sections/contact_section.dart';

/// Main portfolio screen with responsive M3 navigation + ScrollSpy.
///
/// - **Desktop (>800px)**: [NavigationRail] on the left + scrollable content.
/// - **Mobile (≤800px)**: [NavigationBar] at the bottom + scrollable content.
/// - Navigation tabs auto-update as user scrolls between sections.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // Navigation destinations shared by Rail and Bar.
  static const destinations = [
    _NavItem(icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Home'),
    _NavItem(icon: Icons.school_outlined, selectedIcon: Icons.school, label: 'Education'),
    _NavItem(icon: Icons.code_outlined, selectedIcon: Icons.code, label: 'Skills'),
    _NavItem(icon: Icons.work_outline, selectedIcon: Icons.work, label: 'Experience'),
    _NavItem(icon: Icons.rocket_launch_outlined, selectedIcon: Icons.rocket_launch, label: 'Projects'),
    _NavItem(icon: Icons.workspace_premium_outlined, selectedIcon: Icons.workspace_premium, label: 'Certificates'),
    _NavItem(icon: Icons.api_outlined, selectedIcon: Icons.api, label: 'API'),
    _NavItem(icon: Icons.mail_outline, selectedIcon: Icons.mail, label: 'Contact'),
  ];

  /// Ordered section names matching the navigation destinations.
  static const sectionNames = [
    'Home', 'Education', 'Skills', 'Experience',
    'Projects', 'Certificates', 'API', 'Contact',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumeAsync = ref.watch(resumeDataProvider);
    final isDesktop = MediaQuery.sizeOf(context).width > 800;

    return Scaffold(
      body: resumeAsync.when(
        data: (data) => isDesktop
            ? _DesktopLayout(resumeData: data)
            : _MobileLayout(resumeData: data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48,
                  color: Theme.of(context).colorScheme.error),
              const SizedBox(height: 16),
              Text('Failed to load portfolio data',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text('$err', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Navigation item data
// ---------------------------------------------------------------------------

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  const _NavItem({required this.icon, required this.selectedIcon, required this.label});
}

// ---------------------------------------------------------------------------
// Desktop layout — NavigationRail + Content
// ---------------------------------------------------------------------------

class _DesktopLayout extends ConsumerWidget {
  final dynamic resumeData;
  const _DesktopLayout({required this.resumeData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedNavIndexProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final themeState = ref.watch(themeProvider);
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        NavigationRail(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            ref.read(selectedNavIndexProvider.notifier).state = index;
            _scrollToSection(ref.read(sectionKeysProvider), index);
          },
          labelType: NavigationRailLabelType.all,
          leading: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text('RA.',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: cs.primary, fontWeight: FontWeight.w900, letterSpacing: 2,
              ),
            ),
          ),
          trailing: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => themeNotifier.cycleThemeMode(),
                  icon: Icon(_themeIcon(themeState.themeMode)),
                  tooltip: 'Toggle Theme',
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          destinations: HomeScreen.destinations
              .map((d) => NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: Text(d.label),
                  ))
              .toList(),
        ),
        VerticalDivider(width: 1, thickness: 1, color: cs.outlineVariant),
        Expanded(child: _ScrollSpyBody(resumeData: resumeData)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Mobile layout — Content + NavigationBar
// ---------------------------------------------------------------------------

class _MobileLayout extends ConsumerWidget {
  final dynamic resumeData;
  const _MobileLayout({required this.resumeData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedNavIndexProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final themeState = ref.watch(themeProvider);

    const mobileDestinations = [0, 3, 4, 7]; // Home, Experience, Projects, Contact
    final mobileIndex = mobileDestinations.indexOf(selectedIndex);
    final effectiveMobileIndex = mobileIndex == -1 ? 0 : mobileIndex;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('RA.',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w900, letterSpacing: 2,
                    ),
                  ),
                  IconButton(
                    onPressed: () => themeNotifier.cycleThemeMode(),
                    icon: Icon(_themeIcon(themeState.themeMode)),
                    tooltip: 'Toggle Theme',
                  ),
                ],
              ),
            ),
            Expanded(child: _ScrollSpyBody(resumeData: resumeData)),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: effectiveMobileIndex,
        onDestinationSelected: (index) {
          final actualIndex = mobileDestinations[index];
          ref.read(selectedNavIndexProvider.notifier).state = actualIndex;
          _scrollToSection(ref.read(sectionKeysProvider), actualIndex);
        },
        destinations: mobileDestinations
            .map((i) => HomeScreen.destinations[i])
            .map((d) => NavigationDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: d.label,
                ))
            .toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ScrollSpy Content Body — detects which section is visible and updates nav
// ---------------------------------------------------------------------------

class _ScrollSpyBody extends ConsumerStatefulWidget {
  final dynamic resumeData;
  const _ScrollSpyBody({required this.resumeData});

  @override
  ConsumerState<_ScrollSpyBody> createState() => _ScrollSpyBodyState();
}

class _ScrollSpyBodyState extends ConsumerState<_ScrollSpyBody> {
  final ScrollController _scrollController = ScrollController();

  /// When true, the scroll listener ignores position updates.
  /// Prevents fight between programmatic scroll and ScrollSpy.
  bool _isProgrammaticScroll = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Called on every scroll frame. Determines which section is currently
  /// at the top of the viewport and updates the nav index.
  void _onScroll() {
    if (_isProgrammaticScroll) return;

    final keys = ref.read(sectionKeysProvider);
    final sectionNames = HomeScreen.sectionNames;

    // Walk sections in reverse order. The first one whose top edge is
    // at or above the viewport top (with a buffer) is the active section.
    int activeIndex = 0;
    const topBuffer = 150.0; // px below viewport top to trigger switch

    for (int i = sectionNames.length - 1; i >= 0; i--) {
      final key = keys[sectionNames[i]];
      if (key?.currentContext == null) continue;

      final renderObject = key!.currentContext!.findRenderObject();
      if (renderObject == null || renderObject is! RenderBox) continue;
      if (!renderObject.attached) continue;

      // Get the section's position relative to the viewport
      final viewport = RenderAbstractViewport.of(renderObject);
      final revealOffset = viewport.getOffsetToReveal(renderObject, 0.0).offset;
      final scrollOffset = _scrollController.offset;

      if (revealOffset <= scrollOffset + topBuffer) {
        activeIndex = i;
        break;
      }
    }

    // Only update if changed
    final current = ref.read(selectedNavIndexProvider);
    if (current != activeIndex) {
      ref.read(selectedNavIndexProvider.notifier).state = activeIndex;
    }
  }

  /// Smooth-scrolls to a section and temporarily disables ScrollSpy
  /// to prevent the listener from fighting the animation.
  void scrollToSection(Map<String, GlobalKey> keys, int index) {
    final sectionNames = HomeScreen.sectionNames;
    if (index < 0 || index >= sectionNames.length) return;

    final key = keys[sectionNames[index]];
    if (key?.currentContext == null) return;

    _isProgrammaticScroll = true;

    Scrollable.ensureVisible(
      key!.currentContext!,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    ).then((_) {
      // Re-enable ScrollSpy after animation completes
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) _isProgrammaticScroll = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final keys = ref.watch(sectionKeysProvider);
    final isDesktop = MediaQuery.sizeOf(context).width > 800;

    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 48 : 20,
        vertical: 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                key: keys['Home'],
                child: HeroSection(personal: widget.resumeData.personal),
              ),
              const SizedBox(height: 56),
              Container(
                key: keys['Education'],
                child: EducationSection(education: widget.resumeData.education),
              ),
              const SizedBox(height: 56),
              Container(
                key: keys['Skills'],
                child: SkillsSection(skills: widget.resumeData.skills),
              ),
              const SizedBox(height: 56),
              Container(
                key: keys['Experience'],
                child: ExperienceSection(
                  experience: widget.resumeData.experience,
                  education: widget.resumeData.education,
                ),
              ),
              const SizedBox(height: 56),
              Container(
                key: keys['Projects'],
                child: ProjectsSection(projects: widget.resumeData.projects),
              ),
              const SizedBox(height: 56),
              Container(
                key: keys['Certificates'],
                child: CertificatesSection(certificates: widget.resumeData.certificates),
              ),
              const SizedBox(height: 56),
              Container(
                key: keys['API'],
                child: ApiExplorerSection(resumeData: widget.resumeData),
              ),
              const SizedBox(height: 56),
              Container(
                key: keys['Contact'],
                child: const ContactSection(),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Scroll to section — delegates to the nearest _ScrollSpyBody ancestor.
void _scrollToSection(Map<String, GlobalKey> keys, int index) {
  final sectionNames = HomeScreen.sectionNames;
  if (index < 0 || index >= sectionNames.length) return;

  final key = keys[sectionNames[index]];
  if (key?.currentContext == null) return;

  Scrollable.ensureVisible(
    key!.currentContext!,
    duration: const Duration(milliseconds: 600),
    curve: Curves.easeInOutCubic,
  );
}

/// Returns the appropriate theme mode icon.
IconData _themeIcon(ThemeMode mode) {
  return switch (mode) {
    ThemeMode.system => Icons.brightness_auto,
    ThemeMode.light => Icons.light_mode,
    ThemeMode.dark => Icons.dark_mode,
  };
}
