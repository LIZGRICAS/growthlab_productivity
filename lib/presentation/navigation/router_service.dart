import 'simple_router.dart';

/// Abstraction for navigation so implementations can be injected/mocked in tests.
///
/// Esta interfaz define el contrato de navegación para la capa de presentación.
/// Permite desacoplar el BLoC y la UI del framework de navegación concreto (Navigator 2.0).
abstract class RouterServiceInterface {
  /// Registra el delegate real encargado de interactuar con Navigator.
  /// Normalmente se llama una sola vez desde el Composition Root o la UI raíz.
  void registerDelegate(SimpleRouterDelegate delegate);

  /// Indica si el servicio ya tiene un delegate registrado.
  /// Útil para evitar navegación antes de que el árbol de widgets esté listo.
  bool get isRegistered;

  /// Solicita navegación hacia una nueva ruta.
  /// La capa de presentación solo expresa la intención, no el mecanismo.
  void push(String location);

  /// Solicita volver a la ruta anterior.
  void pop();
}

/// concreta implementacion el delegate creado en  `SimpleRouterDelegate`.
///
/// Esta implementación actúa como adaptador entre la capa de presentación
/// y el RouterDelegate concreto basado en Navigator 2.0.
class RouterServiceImpl implements RouterServiceInterface {
  /// Delegate real que contiene el Navigator y el stack de rutas.
  /// Es nullable porque se registra dinámicamente al iniciar la app.
  SimpleRouterDelegate? _delegate;

  @override
  void registerDelegate(SimpleRouterDelegate delegate) {
    _delegate = delegate;
  }

  @override
  bool get isRegistered => _delegate != null;


//El operador ?. evita crashes si se llama antes del registro
  @override
  void push(String location) => _delegate?.push(location);

  @override
  void pop() => _delegate?.navigatorKey.currentState?.pop();
}


// ✅ La UI no navega directamente
// ✅ El BLoC puede emitir intención de navegación sin conocer Flutter
// ✅ El router es inyectable y mockeable
// ✅ No hay dependencia directa de Navigator fuera del delegate
// para proyectos grandes con Feature-first architecture utilizar go_router