import 'package:flutter/material.dart';
import '../pages/growth_page.dart';
import '../pages/diagnostics_page.dart';

/// Representa el estado de navegación de la aplicación.
///
/// En Navigator 2.0 la navegación es declarativa: en lugar de hacer
/// `push` imperativo, se describe cuál es el estado actual de navegación.
/// Esta clase modela ese estado.
///
/// Para este MVP, el estado se reduce a una ubicación (`location`)
/// representada como string. En aplicaciones más grandes esto suele
/// evolucionar a enums o clases de rutas tipadas.
class SimpleRoutePath {
  final String location;

  SimpleRoutePath(this.location);
}

/// Traduce información de rutas externas (URL, deep links, intents)
/// al estado interno de navegación ([SimpleRoutePath]).
///
/// Actúa como adaptador entre:
/// - el sistema de rutas de la plataforma
/// - el estado de navegación de la aplicación
class SimpleRouteParser extends RouteInformationParser<SimpleRoutePath> {
  @override
  Future<SimpleRoutePath> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    // Si no hay una ruta definida, se usa la raíz como valor por defecto.
    final loc = routeInformation.location;
    return SimpleRoutePath(loc);
  }

  @override
  RouteInformation restoreRouteInformation(
    SimpleRoutePath configuration,
  ) {
    // Convierte el estado interno de navegación nuevamente
    // en información de ruta entendible por la plataforma.
    // Esto es clave para sincronización con la URL (especialmente en web).
    return RouteInformation(location: configuration.location);
  }
}

/// Router central basado en Navigator 2.0.
///
/// Esta clase:
/// - Mantiene el estado de navegación (_location)
/// - Construye el stack de páginas de forma declarativa
/// - Notifica cambios para reconstruir el Navigator
///
/// Está ubicada en la capa de presentación y no contiene
/// lógica de negocio.
class SimpleRouterDelegate extends RouterDelegate<SimpleRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<SimpleRoutePath> {

  /// Clave global requerida por Navigator para controlar el stack.
  ///
  /// También permite que servicios externos (RouterService)
  /// puedan ejecutar acciones como `pop()`.
  @override
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Estado interno de navegación.
  ///
  /// Representa la ruta lógica actual de la aplicación,
  /// no el árbol de widgets.
  String _location = '/';

  /// Devuelve la configuración actual de navegación.
  ///
  /// Flutter la utiliza para sincronizar el estado interno
  /// con el sistema de rutas (URL, deep links).
  @override
  SimpleRoutePath get currentConfiguration =>
      SimpleRoutePath(_location);

  /// Se ejecuta cuando la ruta cambia desde el exterior
  /// (por ejemplo, deep links o refresco del navegador).
  ///
  /// Es importante actualizar el estado y notificar listeners
  /// para que el Navigator se reconstruya correctamente.
  @override
  Future<void> setNewRoutePath(
    SimpleRoutePath configuration,
  ) async {
    _location = configuration.location;
    notifyListeners();
  }

  /// Punto de entrada para navegación programática.
  ///
  /// Las capas superiores (BLoC o RouterService) expresan
  /// la intención de navegar, y este método se encarga
  /// de reflejarla en el estado de navegación.
  void push(String location) {
    _location = location;
    notifyListeners();
  }

  /// Construye el Navigator en función del estado actual.
  ///
  /// El stack de páginas se declara como una lista,
  /// lo que permite a Flutter gestionar los cambios
  /// de forma automática.
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,

      // Stack de páginas declarativo.
      pages: [
        const MaterialPage(child: GrowthPage()),

        // Página adicional solo si la ruta lo requiere.
        if (_location == '/diagnostics')
          const MaterialPage(child: DiagnosticsPage()),
      ],

      /// Maneja la navegación hacia atrás (botón físico o gesto).
      ///
      /// Es fundamental mantener sincronizado el estado interno
      /// cuando una página es removida del stack.
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        // Al hacer pop, se restaura la ruta lógica anterior.
        _location = '/';
        notifyListeners();
        return true;
      },
    );
  }
}


// Navegación declarativa con Navigator 2.0

// Estado de navegación explícito y controlado

// Desacoplado del BLoC y de la UI

// Alineado con Clean Architecture

// Fácil de evolucionar a go_router manteniendo la abstracción