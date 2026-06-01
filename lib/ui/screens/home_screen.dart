import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/resume_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/scroll_provider.dart';
import '../widgets/background_view.dart';
import '../widgets/top_navigation.dart';
import '../widgets/resume_content.dart';
import '../widgets/terminal_content.dart';
import '../widgets/api_explorer.dart';
import '../widgets/contact_form.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumeAsyncValue = ref.watch(resumeDataProvider);
    final themeState = ref.watch(themeProvider);
    final keys = ref.watch(sectionKeysProvider);

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundView(),
          SafeArea(
            child: Column(
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: const TopNavigation(),
                  ),
                ),
                Expanded(
                  child: resumeAsyncValue.when(
                    data: (resumeData) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1000),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (themeState.isTerminalMode)
                                  TerminalContent(resumeData: resumeData)
                                else
                                  ResumeContent(resumeData: resumeData),
                                const SizedBox(height: 48),
                                const Divider(),
                                const SizedBox(height: 24),
                                Container(
                                  key: keys['API'],
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      const Text(
                                        'API Explorer',
                                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 16),
                                      ApiExplorer(resumeData: resumeData),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 48),
                                const Divider(),
                                const SizedBox(height: 24),
                                Container(
                                  key: keys['Contact'],
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      const Text(
                                        'Contact Me',
                                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 16),
                                      const ContactForm(),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 48),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(child: Text('Error: $error')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
