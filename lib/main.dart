import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/bloc/growth_bloc.dart';
import 'presentation/pages/growth_page.dart';
import 'presentation/navigation/simple_router.dart';
import 'presentation/navigation/router_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // If firebase_options.dart hasn't been configured, fall back to default
    await Firebase.initializeApp();
  }
  runApp(GrowthLabApp());
}

class GrowthLabApp extends StatelessWidget {
  GrowthLabApp({super.key}) : _routerDelegate = SimpleRouterDelegate(), _routeParser = SimpleRouteParser(), _routerService = RouterServiceImpl() {
    _routerService.registerDelegate(_routerDelegate);
  }

  final SimpleRouterDelegate _routerDelegate;
  final SimpleRouteParser _routeParser;
  final RouterServiceImpl _routerService;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<RouterServiceInterface>.value(
      value: _routerService,
      child: BlocProvider(
        create: (context) => GrowthBloc(),
        child: MaterialApp.router(
          routerDelegate: _routerDelegate,
          routeInformationParser: _routeParser,
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
        ),
      ),
    );
  }
}
