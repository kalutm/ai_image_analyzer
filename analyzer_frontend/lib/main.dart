import 'package:analyzer_frontend/features/analyzer/cubits/analyzer_cubit.dart';
import 'package:analyzer_frontend/features/analyzer/services/mock_analyzer.dart';
import 'package:analyzer_frontend/features/analyzer/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AiImageAnalyzer());
}

class AiImageAnalyzer extends StatelessWidget {
  const AiImageAnalyzer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider<AnalyzerCubit>(create: (context) => AnalyzerCubit(MockAnalyzer()), child: Home()),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
    );
  }
}
