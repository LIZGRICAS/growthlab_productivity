// GrowthBloc
// -----------------------------
// Rol: Orquestador de presentación (NO dominio)
//
// Responsabilidades:
// - Escuchar eventos de UI (GrowthEvent)
// - Decidir qué UseCase ejecutar
// - Adaptar resultados del dominio a GrowthState (estado de vista)
// - Exponer logs para debugging/feedback visual
//
// No hace:
// - No contiene lógica de negocio
// - No conoce infraestructura (Firebase, CleverTap, REST)
// - No crea dependencias (eso ocurre en el Composition Root)

import 'package:flutter_bloc/flutter_bloc.dart'; // dependencia de framework de presentación
import 'growth_event.dart'; // contratos propios de presentation (GrowthEvent) - Input
import 'growth_state.dart'; // contratos propios de presentation (GrowthState) - Output
import '../../domain/entities/user_profile.dart'; //  datos de dominio (UserProfile) - El Bloc puede conocer entidades porque solo representan datos y reglas, no detalles de infraestructura ni frameworks.
import '../../domain/usecases/growth_usecases.dart'; // lógica de negocio del dominio (CreateUserProfileUseCase, TrackProductivityUseCase, SyncDataUseCase)
import '../../domain/usecases/update_user_profile_use_case.dart'; // contrato del dominio para actualizar datos, sin saber cómo se implementa. El Bloc conoce casos de uso, que encapsulan el acceso al repositorio, pero no conoce detalles de implementación ni infraestructura. El Bloc no tiene lógica de negocio, solo coordina la llamada a los casos de uso y adapta el resultado a su propio estado. El Bloc no sabe nada de la plataforma, solo sabe que tiene un repositorio que le permite acceder a los datos necesarios para la presentación.

//El Bloc no expone métodos públicos de negocio, solo reacciona a eventos, Input → GrowthEvent - y emite estados, output → GrowthState
class GrowthBloc extends Bloc<GrowthEvent, GrowthState> {
  //No expone métodos de negocio.
  // Dependencias del Bloc.
  // Son UseCases del dominio, inyectados desde el Composition Root.
  // El Bloc no sabe cómo funcionan internamente ni qué infraestructura usan.

  final CreateUserProfileUseCase _createUser;
  final TrackProductivityUseCase _trackEvent;
  final SyncDataUseCase _syncData;
  final UpdateUserProfileUseCase _updateProfile;

  // Inyección de dependencias.
  // El Bloc no construye UseCases.
  // El Composition Root es responsable de crearlos.

  /// permitir inyección externa (testing / DI) `AnalyticsRepositoryImpl`.
  GrowthBloc({
    required CreateUserProfileUseCase createUser,
    required TrackProductivityUseCase trackEvent,
    required SyncDataUseCase syncData,
    required UpdateUserProfileUseCase updateProfile,
  }) : _createUser = createUser,
       _trackEvent = trackEvent,
       _syncData = syncData,
       _updateProfile = updateProfile,
       //Estado inicial: sin usuario,sin tareas, logs vacíos, tab 0, sin errores
       super(const GrowthState()) {
    // Registro de handlers de eventos - cada evento → un handler, Cada evento de UI se mapea a una intención clara del usuario.
    on<CreateUserRequested>(_onCreateUser);
    on<CompleteProfileRequested>(_onCompleteProfile);
    on<TrackEventRequested>(_onTrackEvent);
    on<SyncDataRequested>(_onSyncData);
    on<GenerateTasksRequested>(_onGenerateTasks);
    on<NavigationTabChanged>(
      (e, emit) => emit(state.copyWith(activeTab: e.index)),
    );
  }

  //Método _log: Logging de presentación, genera timestamp, agrega logs al estado, los logs viven en GrowthState, Vive en el estado porque la UI puede mostrarlo (debug / feedback).
  void _log(Emitter<GrowthState> emit, String msg) {
    final timestamp = DateTime.now().toString().substring(11, 19);
    emit(state.copyWith(logs: ['[$timestamp] $msg', ...state.logs]));
  }

  //// Evento de onboarding.
  // El Bloc:
  // - construye la intención (UserProfile)
  // - delega la operación al UseCase
  // - maneja estados de carga / éxito / error
  // el UseCase valida el perfil, guarda en Firestore, guarda en Firestore
  Future<void> _onCreateUser(
    CreateUserRequested e,
    Emitter<GrowthState> emit,
  ) async {
    emit(state.copyWith(status: GrowthStatus.loading));
    _log(emit, 'Iniciando Onboarding Senior...');

    final profile = UserProfile(
      name: 'Lizbeth Grisales Castro',
      identity: '1036626480', // REQUISITO: String numérico puro
      email: 'lizgricas@gmail.con',
      phone: '+573008333775',
    );

    try {
      await _createUser(profile);
      emit(state.copyWith(status: GrowthStatus.success, user: profile));
      _log(emit, 'Perfil CleverTap + Firestore sincronizado.');
    } catch (err) {
      emit(state.copyWith(status: GrowthStatus.error));
      _log(emit, 'Error en onboarding: $err');
    }
  }

  // Método para completar perfil.
  // Validaciones de flujo (UI) se hacen aquí.
  // Validaciones de negocio viven en el dominio.
  Future<void> _onCompleteProfile(
    CompleteProfileRequested e,
    Emitter<GrowthState> emit,
  ) async {
    if (state.user == null) {
      _log(emit, 'Error: Debe identificar al usuario primero.');
      return;
    }

    emit(state.copyWith(status: GrowthStatus.loading));
    const dob = '1992-08-15';

    try {
      await _updateProfile(state.user!.identity, {'DOB': dob});

      emit(
        state.copyWith(
          status: GrowthStatus.success,
          user: state.user!.copyWith(dob: dob),
        ),
      );

      _log(emit, 'Atributo DOB enviado a la nube.');
    } catch (err) {
      emit(state.copyWith(status: GrowthStatus.error));
      _log(emit, 'Error en Update: $err');
    }
  }

  // Método Tracking de evento.
  // El Bloc no conoce la herramienta de analytics.
  // Solo expresa la intención: "registrar evento".
  Future<void> _onTrackEvent(
    TrackEventRequested e,
    Emitter<GrowthState> emit,
  ) async {
    emit(state.copyWith(status: GrowthStatus.loading));
    try {
      await _trackEvent();
      emit(state.copyWith(status: GrowthStatus.success));
      _log(emit, 'Evento "Hola_mundo" enviado con éxito.');
    } catch (err) {
      emit(state.copyWith(status: GrowthStatus.error));
    }
  }

  // Método de Sincronización.
  // El Bloc recibe datos ya procesados por el dominio
  // y los adapta a un estado consumible por la UI.
  Future<void> _onSyncData(
    SyncDataRequested e,
    Emitter<GrowthState> emit,
  ) async {
    emit(state.copyWith(status: GrowthStatus.loading));
    _log(emit, 'Sync 7s: Sincronizando nodos REST...');
    try {
      final results = await _syncData();
      emit(
        state.copyWith(
          status: GrowthStatus.success,
          tasks: [...state.tasks, ...results],
        ),
      );
      _log(emit, 'Sincronización completa: ${results.length} nuevas tareas.');
    } catch (err) {
      emit(state.copyWith(status: GrowthStatus.error));
      _log(emit, 'Error en Sync: $err');
    }
  }

  // Método de Generación local de tareas para UI.
  // No representa una regla de negocio.
  // Vive en presentation.
  void _onGenerateTasks(GenerateTasksRequested e, Emitter<GrowthState> emit) {
    // REQUISITO: ListView eficiente (hasta 400 elementos)
    final count = (DateTime.now().millisecond % 399) + 1;
    final list = List.generate(
      count,
      (i) => 'Enterprise Task Sprint #${i + 1}',
    );
    emit(state.copyWith(tasks: list));
    _log(emit, 'Generadas $count tareas mediante ListView.builder.');
  }
}

// ✔️ El Bloc no llama directamente a DataSources
// ✔️ El Bloc usa UseCases para acciones principales
// ✔️ El dominio no depende del Bloc
// ✔️ Las capas están claras conceptualmente
// ✔️ La composición de dependencias ocurre fuera del Bloc
