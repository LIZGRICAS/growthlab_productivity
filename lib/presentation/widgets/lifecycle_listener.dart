import 'package:flutter/widgets.dart';

/// Widget que escucha los cambios del ciclo de vida de la aplicación
/// y notifica esos cambios mediante el callback [onStateChanged].
///
/// Este widget actúa como un adaptador entre el ciclo de vida de Flutter
/// (AppLifecycleState) y la lógica de la aplicación.
///
/// Es útil para:
/// - tracking de analytics
/// - sincronización de datos
/// - manejo de sesiones
/// - detección de foreground / background
class LifecycleListener extends StatefulWidget {
  /// Callback que se ejecuta cada vez que el estado del ciclo de vida cambia.
  final void Function(AppLifecycleState) onStateChanged;

  /// Widget hijo que se renderiza normalmente.
  /// El listener no afecta el layout ni la UI.
  final Widget child;

  const LifecycleListener({
    required this.onStateChanged,
    required this.child,
    super.key,
  });

  @override
  State<LifecycleListener> createState() => _LifecycleListenerState();
}

/// Estado interno que observa el ciclo de vida de la app.
///
/// Implementa [WidgetsBindingObserver] para recibir eventos
/// como pause, resume, inactive y detached.
class _LifecycleListenerState extends State<LifecycleListener>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();

    // Registra este objeto como observador del ciclo de vida de la app.
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Es importante remover el observer para evitar memory leaks
    // cuando el widget se destruye.
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Propaga el nuevo estado de ciclo de vida hacia capas superiores
    // (por ejemplo, un BLoC o un servicio de analytics).
    widget.onStateChanged(state);
  }

  @override
  Widget build(BuildContext context) {
    // Este widget no introduce UI propia.
    // Simplemente devuelve su hijo.
    return widget.child;
  }
}
