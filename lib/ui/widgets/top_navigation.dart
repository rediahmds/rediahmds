import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';

class TopNavigation extends ConsumerWidget {
  const TopNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'RA.',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
            ),
          ),
          Row(
            children: [
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment<bool>(
                    value: false,
                    icon: Icon(Icons.web),
                    label: Text('UI Mode'),
                  ),
                  ButtonSegment<bool>(
                    value: true,
                    icon: Icon(Icons.terminal),
                    label: Text('Terminal'),
                  ),
                ],
                selected: {themeState.isTerminalMode},
                onSelectionChanged: (Set<bool> newSelection) {
                  if (newSelection.first != themeState.isTerminalMode) {
                    themeNotifier.toggleTerminalMode();
                  }
                },
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
