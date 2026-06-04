import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/theme_provider.dart';
import 'ui/theme/app_theme.dart';
import 'ui/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: PortfolioApp()));
}

class PortfolioApp extends ConsumerWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Redi Ahmad Supriyatna — Portfolio',
      debugShowCheckedModeBanner: false,
      themeMode: themeState.themeMode,
      theme: AppTheme.buildTheme(
        seedColor: themeState.seedColor,
        brightness: Brightness.light,
      ),
      darkTheme: AppTheme.buildTheme(
        seedColor: themeState.seedColor,
        brightness: Brightness.dark,
      ),
      home: const HomeScreen(),
    );
  }
}
