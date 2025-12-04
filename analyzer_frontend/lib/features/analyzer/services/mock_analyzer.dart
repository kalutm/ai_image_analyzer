import 'dart:typed_data';

import 'package:analyzer_frontend/features/analyzer/models/analysis_result.dart';
import 'package:analyzer_frontend/features/analyzer/models/label.dart';
import 'package:analyzer_frontend/features/analyzer/services/analyzer.dart';

class MockAnalyzer implements Analyzer{
  @override
  Future<AnalysisResult> analyze(Uint8List imgBytes) async {
    await Future.delayed(Duration(seconds: 2));
    return AnalysisResult(
      labels: [
        Label(name: "Object", confidence: 0.87),
        Label(name: "Random", confidence: 0.65),
      ],
      description: "This is a mocked description.",
      colors: ["blue", "black"],
      safety: "safe",
    );
  }
}
