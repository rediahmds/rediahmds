import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';

class BackgroundView extends ConsumerWidget {
  const BackgroundView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: themeState.backgroundUrl.isNotEmpty
          ? Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  themeState.backgroundUrl,
                  fit: BoxFit.cover,
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                  child: Container(
                    color: isDark 
                        ? Colors.black.withValues(alpha: 0.7) 
                        : Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            )
          : null,
    );
  }
}
