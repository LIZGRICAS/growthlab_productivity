// Clase base abstracta para todos los eventos del GrowthBloc.
// Representa intenciones del usuario o del sistema provenientes de la UI.
//
// Los eventos:
// - NO contienen lógica de negocio
// - NO llaman casos de uso
// - NO conocen dominio ni infraestructura
// Solo describen "qué pasó".

// Equatable permite comparar eventos por valor.
// En BLoC es importante para evitar emisiones duplicadas
// y facilitar debugging y testing.
import 'package:equatable/equatable.dart';


abstract class GrowthEvent extends Equatable {
  // Constructor const porque los eventos son inmutables
  // y no contienen lógica interna.
  const GrowthEvent();

  // Por defecto, los eventos no tienen propiedades.
  // Las subclases sobrescriben esto si necesitan datos.
  @override
  List<Object?> get props => [];
}

// Evento emitido cuando la UI solicita crear un usuario.
// Representa una intención del usuario (ej: presionar un botón).
class CreateUserRequested extends GrowthEvent {}

// Evento emitido cuando la UI solicita completar el perfil.
// No decide qué campos se completan; eso lo resuelve el Bloc
// y/o los casos de uso.
class CompleteProfileRequested extends GrowthEvent {}

// Evento emitido cuando la UI solicita registrar un evento
// de productividad o analítica.
class TrackEventRequested extends GrowthEvent {}

// Evento emitido cuando la UI solicita sincronizar datos externos
// (Firebase, REST, etc.).
class SyncDataRequested extends GrowthEvent {}

// Evento emitido cuando la UI solicita generar tareas.
// La lógica de generación NO vive aquí.
class GenerateTasksRequested extends GrowthEvent {}

// Evento emitido cuando el usuario cambia de pestaña en la UI.
// Es un evento puramente de presentación.
class NavigationTabChanged extends GrowthEvent {

  // Índice de la pestaña seleccionada.
  // No es una regla de negocio, solo estado de UI.
  final int index;

  // Constructor const para mantener inmutabilidad.
  const NavigationTabChanged(this.index);

  // Se debería sobrescribir props para incluir el índice,
  // de modo que Equatable pueda comparar correctamente el evento.
  @override
  List<Object?> get props => [index];
}
