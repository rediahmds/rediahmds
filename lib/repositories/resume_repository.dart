import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/resume_model.dart';

abstract class ResumeRepository {
  Future<ResumeModel> fetchResumeData();
}

class MockResumeRepository implements ResumeRepository {
  @override
  Future<ResumeModel> fetchResumeData() async {
    // Simulate network latency
    // await Future.delayed(const Duration(milliseconds: 1500));
    
    try {
      final String jsonString = await rootBundle.loadString('assets/data/resume.json');
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return ResumeModel.fromJson(jsonMap);
    } catch (e) {
      throw Exception('Failed to load resume data: $e');
    }
  }
}
