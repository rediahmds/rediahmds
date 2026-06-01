import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/resume_repository.dart';
import '../models/resume_model.dart';

final resumeRepositoryProvider = Provider<ResumeRepository>((ref) {
  return MockResumeRepository();
});

final resumeDataProvider = FutureProvider<ResumeModel>((ref) async {
  final repository = ref.watch(resumeRepositoryProvider);
  return repository.fetchResumeData();
});
