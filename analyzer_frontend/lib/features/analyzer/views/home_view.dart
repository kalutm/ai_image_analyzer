import 'package:analyzer_frontend/features/analyzer/cubits/analyzer_cubit.dart';
import 'package:analyzer_frontend/features/analyzer/cubits/analyzer_state.dart';
import 'package:analyzer_frontend/features/analyzer/views/preview.dart';
import 'package:analyzer_frontend/features/analyzer/views/results_view.dart';
import 'package:analyzer_frontend/features/analyzer/views/upload_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // 0 Upload (Default), 1 Preview, 2 Results
  int _selectedNav = 0;
  void _onItemTapped(int index) {

    setState(() {
      _selectedNav = index;
    });
    if (index == 0) {
      context.read<AnalyzerCubit>().upload();
    } else if (index == 1) {
      context.read<AnalyzerCubit>().preview();
    } else if (index == 2) {
      context.read<AnalyzerCubit>().results();
    }
  }

  int indexFromState(AnalyzerState state) {
    if (state is AnalyzerStateUpload) {
      return 0;
    } else if (state is AnalyzerStatePreview) {
      return 1;
    } else {
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Analyzer"),
        backgroundColor: Colors.greenAccent,
      ),
      body: BlocBuilder<AnalyzerCubit, AnalyzerState>(
        builder: (context, state) {
          if (state is AnalyzerStateUpload) {
            return UploadView();
          } else if (state is AnalyzerStatePreview) {
            final preview = state.preview;
            if (preview != null) {
              return Preview(preview: preview);
            } else {
              return Center(
                child: Text(
                  "No image to preview!. please upload image in the upload section",
                ),
              );
            }
          } else if (state is AnalyzerStateResults) {
            final result = state.result;
            if (result != null) {
              return ResultsView(result: result);
            } else {
              return Center(
                child: Text(
                  "please upload image in the upload section before viewing result's",
                ),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: BlocListener<AnalyzerCubit, AnalyzerState>(
        listener: (context, state) {
          final index = indexFromState(state);
          setState(() {
            _selectedNav = index;
          });
        },
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.image), label: "Upload"),
            BottomNavigationBarItem(
              icon: Icon(Icons.preview),
              label: "Preview",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: "Result",
            ),
          ],
          currentIndex: _selectedNav,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
