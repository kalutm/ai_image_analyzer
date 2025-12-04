import 'package:analyzer_frontend/features/analyzer/models/analysis_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/analyzer_cubit.dart';

class ResultsView extends StatelessWidget {
  final AnalysisResult result;
  const ResultsView({required this.result, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Results"),
          SizedBox(height: 10),
          Text("description: ${result.description}"),
          Text("color: ${result.colors.first}"),
          Text("label: ${result.labels.first}"),
          SizedBox(height: 20),
          TextButton.icon(
            onPressed:
                () => context.read<AnalyzerCubit>().upload(),
            label: Text("Analyze Again"),
            icon: Icon(Icons.analytics),
          ),
        ],
      ),
    );
  }
}