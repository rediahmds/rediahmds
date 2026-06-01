import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
