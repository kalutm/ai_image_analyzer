import 'dart:math';

import 'package:analyzer_frontend/features/analyzer/cubits/analyzer_cubit.dart';
import 'package:analyzer_frontend/features/analyzer/models/preview_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadView extends StatelessWidget {
  final previewModels = [
    PreviewModel(image: "Image 1", resolution: "1080p", size: "3:4"),
    PreviewModel(image: "Image 2", resolution: "720p", size: "16:9"),
    PreviewModel(image: "Image 3", resolution: "1440p", size: "1:1"),
  ];
  UploadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Upload"),
          SizedBox(height: 10),
          TextButton.icon(
            onPressed:
                () => context.read<AnalyzerCubit>().preview(
                  previewModels.elementAt(Random().nextInt(4)),
                ),
            label: Text("Preview"),
          ),
        ],
      ),
    );
  }
}
