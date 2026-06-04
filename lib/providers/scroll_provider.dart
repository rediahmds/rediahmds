import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global keys for each content section, used for scroll-to-section navigation.
final sectionKeysProvider = Provider<Map<String, GlobalKey>>((ref) {
  return {
    'Home': GlobalKey(),
    'Education': GlobalKey(),
    'Skills': GlobalKey(),
    'Experience': GlobalKey(),
    'Projects': GlobalKey(),
    'Certificates': GlobalKey(),
    'API': GlobalKey(),
    'Contact': GlobalKey(),
  };
});

/// Currently selected navigation index, synced between Rail and Bar.
final selectedNavIndexProvider = StateProvider<int>((ref) => 0);
