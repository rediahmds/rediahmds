import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';
import '../../providers/scroll_provider.dart';

class TopNavigation extends ConsumerWidget {
  const TopNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final keys = ref.watch(sectionKeysProvider);

    void scrollTo(String keyName) {
      final key = keys[keyName];
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    }

    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'RA.',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          if (isDesktop)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: () => scrollTo('Home'), child: const Text('Home')),
                  const SizedBox(width: 8),
                  TextButton(onPressed: () => scrollTo('Education'), child: const Text('Education')),
                  const SizedBox(width: 8),
                  TextButton(onPressed: () => scrollTo('Skills'), child: const Text('Skills')),
                  const SizedBox(width: 8),
                  TextButton(onPressed: () => scrollTo('Experience'), child: const Text('Experience')),
                  const SizedBox(width: 8),
                  TextButton(onPressed: () => scrollTo('Projects'), child: const Text('Projects')),
                ],
              ),
            ),
          Row(
            children: [
              IconButton(
                onPressed: () => themeNotifier.toggleTerminalMode(),
                icon: Icon(themeState.isTerminalMode ? Icons.web : Icons.terminal),
                tooltip: 'Switch to ${themeState.isTerminalMode ? "UI" : "Terminal"} Mode',
                color: themeState.isTerminalMode ? Theme.of(context).colorScheme.primary : null,
              ),
              const SizedBox(width: 16),
              DropdownButtonHideUnderline(
                child: DropdownButton<ThemeMode>(
                  value: themeState.themeMode,
                  icon: const Icon(Icons.palette_outlined),
                  onChanged: (ThemeMode? newValue) {
                    if (newValue != null) {
                      themeNotifier.toggleThemeMode(newValue);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('System'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Light'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Dark'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
