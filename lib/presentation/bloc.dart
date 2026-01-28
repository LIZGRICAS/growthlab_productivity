
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../domain/entities.dart';
import '../data/datasources.dart';

// EVENTS
abstract class GrowthEvent extends Equatable {
  const GrowthEvent();
  @override
  List<Object?> get props => [];
}

class OnboardUser extends GrowthEvent {}
class CompleteDob extends GrowthEvent {}
class TrackHolaMundo extends GrowthEvent {}
class StartCloudSync extends GrowthEvent {}
class GenerateRandomTasks extends GrowthEvent {}
class TabChanged extends GrowthEvent {
  final int index;
  const TabChanged(this.index);
}

// STATE
enum GrowthStatus { initial, loading, success, error }

class GrowthState extends Equatable {
  final GrowthStatus status;
  final int activeTab;
  final UserProfile? user;
  final List<String> tasks;
  final List<String> logs;
  final AppConfig? config;

  const GrowthState({
    this.status = GrowthStatus.initial,
    this.activeTab = 0,
    this.user,
    this.tasks = const [],
    this.logs = const ['System Boot...'],
    this.config,
  });

  GrowthState copyWith({
    GrowthStatus? status,
    int? activeTab,
    UserProfile? user,
    List<String>? tasks,
    List<String>? logs,
    AppConfig? config,
  }) {
    return GrowthState(
      status: status ?? this.status,
      activeTab: activeTab ?? this.activeTab,
      user: user ?? this.user,
      tasks: tasks ?? this.tasks,
      logs: logs ?? this.logs,
      config: config ?? this.config,
    );
  }

  @override
  List<Object?> get props => [status, activeTab, user, tasks, logs, config];
}

/// BLoC principal que orquesta la lógica de GrowthLab.
/// 
/// Implementa los 5 casos de uso obligatorios de la prueba técnica.
class GrowthBloc extends Bloc<GrowthEvent, GrowthState> {
  final CleverTapDataSource _ct = CleverTapDataSource();
  final FirebaseDataSource _fb = FirebaseDataSource();
  final RestService _rest = RestService();

  GrowthBloc() : super(const GrowthState()) {
    on<OnboardUser>(_onOnboard);
    on<CompleteDob>(_onCompleteDob);
    on<TrackHolaMundo>(_onTrack);
    on<StartCloudSync>(_onSync);
    on<GenerateRandomTasks>(_onGenerate);
    on<TabChanged>((e, emit) => emit(state.copyWith(activeTab: e.index)));
  }

  void _log(Emitter<GrowthState> emit, String msg) {
    emit(state.copyWith(
      logs: ['[${DateTime.now().toString().substring(11, 19)}] $msg', ...state.logs]
    ));
  }

  Future<void> _onOnboard(OnboardUser e, Emitter<GrowthState> emit) async {
    emit(state.copyWith(status: GrowthStatus.loading));
    _log(emit, 'Iniciando Onboarding de perfil obligatorio...');
    
    // REQUISITO: Identidad numérica sin puntos ni guiones
    final user = UserProfile(
      name: 'Lizbeth Grisales', 
      identity: '1029384756', // Formato correcto: solo números
      email: 'lgrisales@dev.com', 
      phone: '573001234567'
    );

    try {
      await _ct.createProfile(user);
      final fbId = await _fb.saveToFirestore(user);
      
      emit(state.copyWith(
        status: GrowthStatus.success, 
        user: user.copyWith(firebaseId: fbId)
      ));
      _log(emit, 'Perfil CleverTap creado exitosamente.');
    } catch (error) {
      emit(state.copyWith(status: GrowthStatus.error));
      _log(emit, 'Error en onboarding: $error');
    }
  }

  Future<void> _onCompleteDob(CompleteDob e, Emitter<GrowthState> emit) async {
    if (state.user == null) {
      _log(emit, 'Error: Debe crear el perfil antes de agregar DOB.');
      return;
    }
    emit(state.copyWith(status: GrowthStatus.loading));
    const dob = '1992-08-15';
    
    try {
      await _ct.updateProfile(state.user!.identity, {'DOB': dob});
      emit(state.copyWith(
        status: GrowthStatus.success, 
        user: state.user!.copyWith(dob: dob)
      ));
      _log(emit, 'Fecha de nacimiento sincronizada.');
    } catch (error) {
      emit(state.copyWith(status: GrowthStatus.error));
      _log(emit, 'Error al actualizar DOB: $error');
    }
  }

  Future<void> _onTrack(TrackHolaMundo e, Emitter<GrowthState> emit) async {
    emit(state.copyWith(status: GrowthStatus.loading));
    
    // REQUISITO: Evento "Hola_mundo" con props exactas
    final props = {
      'years_mobile_experience': 8, 
      'years_flutter_experience': 5, 
      'published_apps': 12
    };

    try {
      await _ct.trackEvent('Hola_mundo', props);
      emit(state.copyWith(status: GrowthStatus.success));
      _log(emit, 'Evento "Hola_mundo" enviado a CleverTap.');
    } catch (error) {
      emit(state.copyWith(status: GrowthStatus.error));
      _log(emit, 'Error en tracking: $error');
    }
  }

  Future<void> _onSync(StartCloudSync e, Emitter<GrowthState> emit) async {
    emit(state.copyWith(status: GrowthStatus.loading));
    _log(emit, 'Iniciando Sincronización REST (7 segundos)...');
    
    try {
      // REQUISITO: Operación asíncrona de 7 segundos
      await Future.delayed(const Duration(seconds: 7));
      final newTasks = await _rest.fetchTasks();
      
      emit(state.copyWith(
        status: GrowthStatus.success, 
        tasks: [...state.tasks, ...newTasks]
      ));
      _log(emit, 'Sincronización de tareas REST completada.');
    } catch (error) {
      emit(state.copyWith(status: GrowthStatus.error));
      _log(emit, 'Error en sincronización: $error');
    }
  }

  void _onGenerate(GenerateRandomTasks e, Emitter<GrowthState> emit) {
    // REQUISITO: ListView eficiente hasta 400 elementos
    final count = (DateTime.now().millisecond % 399) + 1;
    final gen = List.generate(count, (i) => 'Tarea Dinámica #${i + 1}');
    
    emit(state.copyWith(tasks: gen));
    _log(emit, 'Generadas $count tareas locales con ListView.builder.');
  }
}
