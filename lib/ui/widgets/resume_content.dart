import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/resume_model.dart';
import '../../providers/scroll_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'glass_card.dart';

class ResumeContent extends ConsumerWidget {
  final ResumeModel resumeData;

  const ResumeContent({super.key, required this.resumeData});

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keys = ref.watch(sectionKeysProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(key: keys['Home'], child: _buildHeader(context)),
        const SizedBox(height: 48),
        Container(
          key: keys['Education'],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(context, 'Education', Icons.school_outlined),
              _buildEducationSection(context),
            ],
          ),
        ),
        const SizedBox(height: 48),
        Container(
          key: keys['Skills'],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(context, 'Skills', Icons.code_outlined),
              _buildSkillsSection(context),
            ],
          ),
        ),
        const SizedBox(height: 48),
        Container(
          key: keys['Experience'],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(context, 'Experience', Icons.work_outline),
              _buildExperienceSection(context),
            ],
          ),
        ),
        const SizedBox(height: 48),
        Container(
          key: keys['Projects'],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(context, 'Projects', Icons.rocket_launch_outlined),
              _buildProjectsSection(context),
            ],
          ),
        ),
        const SizedBox(height: 48),
        Container(
          key: keys['Certificates'],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(context, 'Certificates', Icons.workspace_premium_outlined),
              _buildCertificatesSection(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, size: 48, color: colorScheme.onPrimaryContainer),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resumeData.personal.name,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [colorScheme.primary, colorScheme.tertiary],
                      ).createShader(bounds),
                      child: Text(
                        resumeData.personal.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            resumeData.personal.bio,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              FilledButton.icon(
                onPressed: () => _launchUrl(resumeData.personal.github),
                icon: SvgPicture.asset('assets/icons/github.svg', width: 20, height: 20, colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn)),
                label: const Text('GitHub'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              FilledButton.tonalIcon(
                onPressed: () => _launchUrl(resumeData.personal.linkedin),
                icon: SvgPicture.asset('assets/icons/linkedin.svg', width: 20, height: 20, colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSecondaryContainer, BlendMode.srcIn)),
                label: const Text('LinkedIn'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              TextButton.icon(
                onPressed: () => _launchUrl('mailto:${resumeData.personal.email}'),
                icon: const Icon(Icons.email_outlined),
                label: Text(resumeData.personal.email),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationSection(BuildContext context) {
    return Column(
      children: resumeData.education.map((edu) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GlassCard(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.account_balance, color: Theme.of(context).colorScheme.onTertiaryContainer),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        edu.institution,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${edu.degree} • ${edu.location}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        edu.period,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...edu.details.map((detail) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check_circle_outline, size: 16, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 8),
                            Expanded(child: Text(detail, style: Theme.of(context).textTheme.bodyMedium)),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSkillsSection(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSkillCategory(context, 'Languages', resumeData.skills.languages, Icons.language),
          const SizedBox(height: 24),
          _buildSkillCategory(context, 'Backend & Cloud', resumeData.skills.backendCloud, Icons.cloud_outlined),
          const SizedBox(height: 24),
          _buildSkillCategory(context, 'Mobile', resumeData.skills.mobile, Icons.smartphone),
          const SizedBox(height: 24),
          _buildSkillCategory(context, 'DevOps & Tools', resumeData.skills.devopsTools, Icons.build_outlined),
        ],
      ),
    );
  }

  Widget _buildSkillCategory(BuildContext context, String title, List<String> skills, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(width: 8),
            Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills.map((skill) {
            return Chip(
              label: Text(skill),
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.5),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExperienceSection(BuildContext context) {
    return Column(
      children: resumeData.experience.map((exp) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.business, color: Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  exp.role,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  exp.period,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${exp.company} • ${exp.location}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ...exp.bullets.map((bullet) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Icon(Icons.circle, size: 8, color: Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          bullet,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProjectsSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: resumeData.projects.map((project) {
            final isDesktop = constraints.maxWidth > 800;
            final width = isDesktop ? (constraints.maxWidth / 2) - 8 : constraints.maxWidth;
            
            return SizedBox(
              width: width,
              child: GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.folder_outlined, size: 32, color: Theme.of(context).colorScheme.primary),
                        IconButton.filledTonal(
                          onPressed: () => _launchUrl(project.github),
                          icon: SvgPicture.asset('assets/icons/github.svg', width: 18, height: 18, colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSecondaryContainer, BlendMode.srcIn)),
                          tooltip: 'View Source',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      project.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      project.period,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: project.bullets.map((bullet) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Icon(Icons.arrow_right, size: 20, color: Theme.of(context).colorScheme.primary),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(bullet, style: Theme.of(context).textTheme.bodyMedium)),
                          ],
                        ),
                      )).toList(),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      }
    );
  }

  Widget _buildCertificatesSection(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: resumeData.certificates.map((cert) {
        return SizedBox(
          width: 350,
          child: GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.verified, color: Theme.of(context).colorScheme.tertiary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        cert.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cert.date,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    TextButton(
                      onPressed: () => _launchUrl(cert.url),
                      child: const Text('Verify'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
