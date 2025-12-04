import 'dart:typed_data';

import 'package:analyzer_frontend/features/analyzer/cubits/analyzer_state.dart';
import 'package:analyzer_frontend/features/analyzer/models/analysis_result.dart';
import 'package:analyzer_frontend/features/analyzer/models/preview_model.dart';
import 'package:analyzer_frontend/features/analyzer/services/analyzer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalyzerCubit extends Cubit<AnalyzerState> {
  final Analyzer analyzer;
  PreviewModel? _cachedPreviewModel;
  AnalysisResult? _cachedAnalysisResults;

  AnalyzerCubit(this.analyzer) : super(AnalyzerStateUpload());

  void upload() {
    emit(AnalyzerStateUpload());
  }

  void preview([PreviewModel? preview]) {
    if (preview != null) {
      _cachedPreviewModel = preview;
      emit(AnalyzerStatePreview(preview));
    } else {
      final cachedPreview = _cachedPreviewModel;
      if (cachedPreview != null) {
        emit(AnalyzerStatePreview(cachedPreview));
      } else {
        emit(AnalyzerStatePreview());
      }
    }
  }

  Future<void> results([Uint8List? imgBytes]) async {
    if (imgBytes != null) {
      
      emit(AnalyzerLoading());
      final results = await analyzer.analyze(Uint8List(1000));
      _cachedAnalysisResults = results;
      emit(AnalyzerStateResults(results));
    } else{
      
      final cachedResult = _cachedAnalysisResults;
      if(cachedResult != null){
        emit(AnalyzerStateResults(cachedResult));
      } else{
        emit(AnalyzerStateResults());
      }
    }
  }
}
