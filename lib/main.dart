//el único lugar donde se “pegan” las capas, es configuración del sistema, no lógica de negocio.
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:growthlab_productivity/data/clevertap_datasource.dart';
import 'package:growthlab_productivity/data/datasources/firebase_datasource.dart';
import 'package:growthlab_productivity/data/datasources/firebase_storage_datasource.dart';
import 'package:growthlab_productivity/data/datasources/rest_datasource.dart';
import 'package:growthlab_productivity/data/productivity_repository.dart';
import 'package:growthlab_productivity/domain/repositories/analytics_repository.dart';
import 'package:growthlab_productivity/domain/usecases/growth_usecases.dart';
import 'package:growthlab_productivity/domain/usecases/update_user_profile_use_case.dart';
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/bloc/growth_bloc.dart';
import 'presentation/navigation/simple_router.dart';
import 'presentation/navigation/router_service.dart';
import 'presentation/widgets/lifecycle_listener.dart';

Future<void> main() async {
  // Inicialización del sistema, bootstrap del sistema, no negocio.
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {
    await Firebase.initializeApp();
  }

  // 🔹 DATA SOURCES -infraestructura que ninguna otra capa los conoce
  final cleverTapDataSource = CleverTapDataSource();
  final firebaseDataSource = FirebaseDataSource();
  final storageDataSource = FirebaseStorageDataSource();
  final restDataSource = RestDataSource();

  // 🔹 REPOSITORY -Dependency Inversion, Dominio conoce AnalyticsRepository (interface) pero Root decide AnalyticsRepositoryImpl, El repository sí orquesta DataSources, pero: no los crea, no decide cuáles existen
  // repository tipado por interfaz para reforzar el contrato
  final AnalyticsRepository analyticsRepository = AnalyticsRepositoryImpl(
    cleverTap: cleverTapDataSource,
    firebase: firebaseDataSource,
    storage: storageDataSource,
    rest: restDataSource,
  );

  // 🔹 USE CASES - Los UseCases no saben de Firebase, CleverTap ni REST. Solo saben de un contrato.Solo saben de un contrato.
  final createUser = CreateUserProfileUseCase(analyticsRepository);
  final trackEvent = TrackProductivityUseCase(analyticsRepository);
  final syncData = SyncDataUseCase(analyticsRepository);
  final updateProfile = UpdateUserProfileUseCase(analyticsRepository);

// Constructor- dependency injection manual no crea dominio, no conoce infraestructura, solo recibe dependencias
  runApp(
    GrowthLabApp(
      createUser: createUser,
      trackEvent: trackEvent,
      syncData: syncData,
      updateProfile: updateProfile,
    ),
  );
}

class GrowthLabApp extends StatelessWidget {
  GrowthLabApp({
    super.key,
    required this.createUser,
    required this.trackEvent,
    required this.syncData,
    required this.updateProfile,
  }) : _routerDelegate = SimpleRouterDelegate(),
       _routeParser = SimpleRouteParser(),
       _routerService = RouterServiceImpl() {
    _routerService.registerDelegate(_routerDelegate);
  }

  final CreateUserProfileUseCase createUser;
  final TrackProductivityUseCase trackEvent;
  final SyncDataUseCase syncData;
  final UpdateUserProfileUseCase updateProfile;

  //Router y navegación en el root, el routing es infraestructura de presentación, y se crea una sola vez, se comparte por toda la app
  final SimpleRouterDelegate _routerDelegate;
  final SimpleRouteParser _routeParser;
  final RouterServiceImpl _routerService;

  //Exposición por interfaz: UI depende de interfaz, no de implementación concreta, implementación queda encapsulada. El Bloc no sabe nada de la implementación concreta del repositorio, solo sabe que tiene un repositorio que le permite crear perfiles de usuario, trackear eventos de productividad y sincronizar datos externos. El Bloc no tiene lógica de negocio, solo coordina la llamada a los casos de uso y adapta el resultado a su propio estado. El Bloc no sabe nada de la plataforma, solo sabe que tiene un repositorio que le permite acceder a los datos necesarios para la presentación.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<RouterServiceInterface>.value(
      value: _routerService,
      child: BlocProvider(
        create: (_) => GrowthBloc(
          createUser: createUser,
          trackEvent: trackEvent,
          syncData: syncData,
          updateProfile: updateProfile,
        ),
        // Usamos Builder para obtener un contexto que esté por debajo del BlocProvider,
        // de modo que LifecycleListener pueda acceder al GrowthBloc vía context.read<>()
        child: Builder(
          builder: (childContext) => LifecycleListener(
            onStateChanged: (state) => childContext.read<GrowthBloc>().add(AppLifecycleChanged(state)),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
