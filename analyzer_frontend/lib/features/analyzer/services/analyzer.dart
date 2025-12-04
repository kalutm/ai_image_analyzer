import 'dart:typed_data';

import 'package:analyzer_frontend/features/analyzer/models/analysis_result.dart';

abstract class Analyzer {
  Future<AnalysisResult> analyze(Uint8List imgBytes);
}
