import 'package:analyzer_frontend/features/analyzer/models/analysis_result.dart';
import 'package:analyzer_frontend/features/analyzer/models/preview_model.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AnalyzerState{}

class AnalyzerInitial extends AnalyzerState{}

class AnalyzerLoading extends AnalyzerState{}

class AnalyzerStateUpload extends AnalyzerState{}

class AnalyzerStatePreview extends AnalyzerState{
  final PreviewModel? preview;
  AnalyzerStatePreview([this.preview]);
}

class AnalyzerStateResults extends AnalyzerState{
  final AnalysisResult? result;
  AnalyzerStateResults([this.result]);
}