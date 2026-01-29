import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/bloc/growth_bloc.dart';
import 'presentation/pages/growth_page.dart';

void main() {
  runApp(const GrowthLabApp());
}

class GrowthLabApp extends StatelessWidget {
  const GrowthLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GrowthBloc(),
      child: MaterialApp(
        title: 'GrowthLab Productivity',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.light,
          ),
          cardTheme: const CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          ),
          home: const GrowthPage(),
      ),
    );
  }
}
