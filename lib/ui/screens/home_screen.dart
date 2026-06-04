import 'package:flutter/material.dart';
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

/// Main portfolio screen with responsive M3 navigation.
///
/// - **Desktop (>800px)**: [NavigationRail] on the left + scrollable content.
/// - **Mobile (≤800px)**: [NavigationBar] at the bottom + scrollable content.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // Navigation destinations shared by Rail and Bar.
  static const _destinations = [
    _NavItem(icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Home'),
    _NavItem(icon: Icons.school_outlined, selectedIcon: Icons.school, label: 'Education'),
    _NavItem(icon: Icons.code_outlined, selectedIcon: Icons.code, label: 'Skills'),
    _NavItem(icon: Icons.work_outline, selectedIcon: Icons.work, label: 'Experience'),
    _NavItem(icon: Icons.rocket_launch_outlined, selectedIcon: Icons.rocket_launch, label: 'Projects'),
    _NavItem(icon: Icons.workspace_premium_outlined, selectedIcon: Icons.workspace_premium, label: 'Certificates'),
    _NavItem(icon: Icons.api_outlined, selectedIcon: Icons.api, label: 'API'),
    _NavItem(icon: Icons.mail_outline, selectedIcon: Icons.mail, label: 'Contact'),
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
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load portfolio data',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '$err',
                style: Theme.of(context).textTheme.bodySmall,
              ),
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

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
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
    final keys = ref.watch(sectionKeysProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final themeState = ref.watch(themeProvider);
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        // --- Navigation Rail ---
        NavigationRail(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            ref.read(selectedNavIndexProvider.notifier).state = index;
            _scrollToSection(keys, index);
          },
          labelType: NavigationRailLabelType.all,
          leading: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'RA.',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
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
          destinations: HomeScreen._destinations
              .map(
                (d) => NavigationRailDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: Text(d.label),
                ),
              )
              .toList(),
        ),

        // Subtle divider
        VerticalDivider(
          width: 1,
          thickness: 1,
          color: cs.outlineVariant,
        ),

        // --- Main content area ---
        Expanded(
          child: _ContentBody(resumeData: resumeData),
        ),
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
    final keys = ref.watch(sectionKeysProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final themeState = ref.watch(themeProvider);

    // Mobile only shows a subset of destinations (max 5 for NavigationBar)
    const mobileDestinations = [0, 3, 4, 7]; // Home, Experience, Projects, Contact

    // Map selected index to mobile subset
    final mobileIndex = mobileDestinations.indexOf(selectedIndex);
    final effectiveMobileIndex = mobileIndex == -1 ? 0 : mobileIndex;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with logo and theme toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'RA.',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
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
            Expanded(
              child: _ContentBody(resumeData: resumeData),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: effectiveMobileIndex,
        onDestinationSelected: (index) {
          final actualIndex = mobileDestinations[index];
          ref.read(selectedNavIndexProvider.notifier).state = actualIndex;
          _scrollToSection(keys, actualIndex);
        },
        destinations: mobileDestinations
            .map((i) => HomeScreen._destinations[i])
            .map(
              (d) => NavigationDestination(
                icon: Icon(d.icon),
                selectedIcon: Icon(d.selectedIcon),
                label: d.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared content body — the scrollable portfolio sections
// ---------------------------------------------------------------------------

class _ContentBody extends ConsumerWidget {
  final dynamic resumeData;

  const _ContentBody({required this.resumeData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keys = ref.watch(sectionKeysProvider);
    final isDesktop = MediaQuery.sizeOf(context).width > 800;

    return SingleChildScrollView(
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
              // Home / Hero
              Container(
                key: keys['Home'],
                child: HeroSection(personal: resumeData.personal),
              ),
              const SizedBox(height: 56),

              // Education
              Container(
                key: keys['Education'],
                child: EducationSection(education: resumeData.education),
              ),
              const SizedBox(height: 56),

              // Skills
              Container(
                key: keys['Skills'],
                child: SkillsSection(skills: resumeData.skills),
              ),
              const SizedBox(height: 56),

              // Experience
              Container(
                key: keys['Experience'],
                child: ExperienceSection(experience: resumeData.experience),
              ),
              const SizedBox(height: 56),

              // Projects
              Container(
                key: keys['Projects'],
                child: ProjectsSection(projects: resumeData.projects),
              ),
              const SizedBox(height: 56),

              // Certificates
              Container(
                key: keys['Certificates'],
                child: CertificatesSection(
                  certificates: resumeData.certificates,
                ),
              ),
              const SizedBox(height: 56),

              // API Explorer
              Container(
                key: keys['API'],
                child: ApiExplorerSection(resumeData: resumeData),
              ),
              const SizedBox(height: 56),

              // Contact
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

/// Scroll to the section matching the navigation index.
void _scrollToSection(Map<String, GlobalKey> keys, int index) {
  final sectionNames = [
    'Home',
    'Education',
    'Skills',
    'Experience',
    'Projects',
    'Certificates',
    'API',
    'Contact',
  ];

  if (index >= 0 && index < sectionNames.length) {
    final key = keys[sectionNames[index]];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }
}

/// Returns the appropriate theme mode icon.
IconData _themeIcon(ThemeMode mode) {
  return switch (mode) {
    ThemeMode.system => Icons.brightness_auto,
    ThemeMode.light => Icons.light_mode,
    ThemeMode.dark => Icons.dark_mode,
  };
}
