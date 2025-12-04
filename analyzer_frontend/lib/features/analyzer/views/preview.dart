import 'package:analyzer_frontend/features/analyzer/cubits/analyzer_cubit.dart';
import 'package:analyzer_frontend/features/analyzer/models/preview_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Preview extends StatelessWidget {
  final PreviewModel preview;
  const Preview({required this.preview, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Preview"),
          SizedBox(height: 10),
          Text("Image: ${preview.image}"),
          Text("resolution: ${preview.resolution}"),
          Text("size: ${preview.size}"),
          SizedBox(height: 20),
          TextButton.icon(
            onPressed:
                () => context.read<AnalyzerCubit>().results(Uint8List(1000)),
            label: Text("Analyze"),
            icon: Icon(Icons.analytics),
          ),
        ],
      ),
    );
  }
}
