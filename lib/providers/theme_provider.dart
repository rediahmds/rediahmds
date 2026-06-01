import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:palette_generator/palette_generator.dart';

class ThemeState {
  final ThemeMode themeMode;
  final Color seedColor;
  final String backgroundUrl;
  final bool isTerminalMode;

  ThemeState({
    this.themeMode = ThemeMode.system,
    this.seedColor = Colors.blueAccent,
    this.backgroundUrl = '',
    this.isTerminalMode = false,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    Color? seedColor,
    String? backgroundUrl,
    bool? isTerminalMode,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      seedColor: seedColor ?? this.seedColor,
      backgroundUrl: backgroundUrl ?? this.backgroundUrl,
      isTerminalMode: isTerminalMode ?? this.isTerminalMode,
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(ThemeState()) {
    _initTheme();
  }

  Future<void> _initTheme() async {
    try {
      final response = await http.get(Uri.parse('https://bing.biturl.top/?resolution=1920&format=json&index=0&mkt=en-US'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String imageUrl = data['url'];
        
        final palette = await PaletteGenerator.fromImageProvider(
          NetworkImage(imageUrl),
        );
        
        final dominantColor = palette.dominantColor?.color ?? Colors.blueAccent;
        
        state = state.copyWith(
          seedColor: dominantColor,
          backgroundUrl: imageUrl,
        );
      }
    } catch (e) {
      debugPrint('Failed to load Bing wallpaper: $e');
    }
  }

  void toggleThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }

  void toggleTerminalMode() {
    state = state.copyWith(isTerminalMode: !state.isTerminalMode);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});
