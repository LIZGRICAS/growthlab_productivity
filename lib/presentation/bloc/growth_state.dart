// Equatable permite comparar estados por valor.
// Es fundamental en BLoC para evitar renders innecesarios
// y detectar cambios reales en el estado.
import 'package:equatable/equatable.dart';

// Importa entidades del dominio.
// El estado de presentación puede contener entidades,
// pero NO lógica de dominio.
import '../../domain/entities/user_profile.dart';

// Enum que representa el estado general del flujo.
// Es una abstracción de UI, no un estado de negocio.
enum GrowthStatus {
  initial, // Estado inicial de la pantalla
  loading, // Operación en progreso (spinner, bloqueo UI)
  success, // Operación completada correctamente
  error,   // Error ocurrido (mensaje mostrado en UI)
}

// Estado del GrowthBloc.
// Representa una "foto" inmutable de la UI en un momento dado.
class GrowthState extends Equatable {

  // Estado general del flujo (loading, success, etc.).
  final GrowthStatus status;

  // Índice de la pestaña activa.
  // Es estado puramente de presentación.
  final int activeTab;

  // Usuario actual.
  // Es una entidad del dominio expuesta a la UI.
  // Puede ser null si el usuario aún no existe o no se ha cargado.
  final UserProfile? user;

  // Lista de tareas generadas.
  // En presentation se manejan como Strings;
  // si creciera en complejidad, debería ser una entidad o ViewModel.
  final List<String> tasks;

  // Logs visibles en la UI.
  // Útil para debugging, QA o pantallas de diagnóstico.
  final List<String> logs;

  // Constructor inmutable con valores por defecto.
  // Permite crear un estado inicial sin boilerplate.
  const GrowthState({
    this.status = GrowthStatus.initial,
    this.activeTab = 0,
    this.user,
    this.tasks = const [],
    this.logs = const ['Growth Engine Booted...'],
  });

  // Método copyWith para producir un nuevo estado
  // a partir del actual, modificando solo algunos campos.
  //
  // Es la forma correcta de evolucionar estado en BLoC.
  GrowthState copyWith({
    GrowthStatus? status,
    int? activeTab,
    UserProfile? user,
    List<String>? tasks,
    List<String>? logs,
  }) {
    return GrowthState(
      status: status ?? this.status,
      activeTab: activeTab ?? this.activeTab,
      user: user ?? this.user,
      tasks: tasks ?? this.tasks,
      logs: logs ?? this.logs,
    );
  }

  // Define igualdad por valor.
  // Si ninguno de estos campos cambia,
  // el Bloc no emitirá un nuevo estado.
  @override
  List<Object?> get props => [
        status,
        activeTab,
        user,
        tasks,
        logs,
      ];
}
