import 'package:analyzer_frontend/features/analyzer/models/label.dart';

class AnalysisResult {
  final List<Label> labels;
  final String description;
  final List<String> colors;
  final String safety;

  AnalysisResult({
    required this.labels,
    required this.description,
    required this.colors,
    required this.safety
  });
}