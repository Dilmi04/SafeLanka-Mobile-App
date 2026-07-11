import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/guide_model.dart';

class GuideService {
  Future<GuideModel> loadGuide(String fileName) async {
    try {
      final String response = await rootBundle.loadString('assets/guides/$fileName.json');
      final data = await json.decode(response);
      return GuideModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load guide: $e');
    }
  }
}
