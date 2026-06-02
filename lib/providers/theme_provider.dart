import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeState {
  final ThemeMode themeMode;
  final Color seedColor;
  final bool isTerminalMode;

  ThemeState({
    this.themeMode = ThemeMode.dark, // Default to dark for backend aesthetic
    this.seedColor = const Color(0xFF00FFCC), // Cyber/Backend Cyan
    this.isTerminalMode = false,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    Color? seedColor,
    bool? isTerminalMode,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      seedColor: seedColor ?? this.seedColor,
      isTerminalMode: isTerminalMode ?? this.isTerminalMode,
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(ThemeState());

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
