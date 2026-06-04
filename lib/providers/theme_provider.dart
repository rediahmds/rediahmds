import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeState {
  final ThemeMode themeMode;
  final Color seedColor;

  const ThemeState({
    this.themeMode = ThemeMode.dark,
    this.seedColor = const Color(0xFF00FFCC), // Vibrant cyan seed
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    Color? seedColor,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      seedColor: seedColor ?? this.seedColor,
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(const ThemeState());

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }

  void cycleThemeMode() {
    final next = switch (state.themeMode) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light  => ThemeMode.dark,
      ThemeMode.dark   => ThemeMode.system,
    };
    state = state.copyWith(themeMode: next);
  }

  void setSeedColor(Color color) {
    state = state.copyWith(seedColor: color);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});
