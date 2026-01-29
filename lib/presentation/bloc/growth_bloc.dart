import 'package:flutter_bloc/flutter_bloc.dart';
import 'growth_event.dart';
import 'growth_state.dart';
import '../../domain/entities.dart';
import '../../domain/usecases/growth_usecases.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../../data/repositories/analytics_repository_impl.dart';
import '../../data/datasources/firebase_storage_datasource.dart';
import '../../data/datasources/clevertap_datasource.dart';
import '../../data/datasources/firebase_datasource.dart';
import '../../data/datasources/rest_datasource.dart';

class GrowthBloc extends Bloc<GrowthEvent, GrowthState> {
  final CreateUserProfileUseCase _createUser;
  final TrackProductivityUseCase _trackEvent;
  final SyncDataUseCase _syncData;
  final AnalyticsRepository _repo;

  /// Allows injecting a pre-built `AnalyticsRepositoryImpl` for testing.
  GrowthBloc({AnalyticsRepository? repository})
      : _repo = repository ?? AnalyticsRepositoryImpl(
          cleverTap: CleverTapDataSource(),
          firebase: FirebaseDataSource(),
          storage: FirebaseStorageDataSource(),
          rest: RestDataSource(),
        ),
        _createUser = CreateUserProfileUseCase(repository ?? AnalyticsRepositoryImpl(
          cleverTap: CleverTapDataSource(),
          firebase: FirebaseDataSource(),
          storage: FirebaseStorageDataSource(),
          rest: RestDataSource(),
        )),
        _trackEvent = TrackProductivityUseCase(repository ?? AnalyticsRepositoryImpl(
          cleverTap: CleverTapDataSource(),
          firebase: FirebaseDataSource(),
          storage: FirebaseStorageDataSource(),
          rest: RestDataSource(),
        )),
        _syncData = SyncDataUseCase(repository ?? AnalyticsRepositoryImpl(
          cleverTap: CleverTapDataSource(),
          firebase: FirebaseDataSource(),
          storage: FirebaseStorageDataSource(),
          rest: RestDataSource(),
        )),
        super(const GrowthState()) {
    
    on<CreateUserRequested>(_onCreateUser);
    on<CompleteProfileRequested>(_onCompleteProfile);
    on<TrackEventRequested>(_onTrackEvent);
    on<SyncDataRequested>(_onSyncData);
    on<GenerateTasksRequested>(_onGenerateTasks);
    on<NavigationTabChanged>((e, emit) => emit(state.copyWith(activeTab: e.index)));
  }

  void _log(Emitter<GrowthState> emit, String msg) {
    final timestamp = DateTime.now().toString().substring(11, 19);
    emit(state.copyWith(
      logs: ['[$timestamp] $msg', ...state.logs]
    ));
  }

  Future<void> _onCreateUser(CreateUserRequested e, Emitter<GrowthState> emit) async {
    emit(state.copyWith(status: GrowthStatus.loading));
    _log(emit, 'Iniciando Onboarding Senior...');
    
    final profile = UserProfile(
      name: 'Lizbeth Grisales',
      identity: '1029384756', // REQUISITO: String numérico puro
      email: 'lgrisales.dev@example.com',
      phone: '573001234567'
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

  Future<void> _onCompleteProfile(CompleteProfileRequested e, Emitter<GrowthState> emit) async {
    if (state.user == null) {
      _log(emit, 'Error: Debe identificar al usuario primero.');
      return;
    }
    emit(state.copyWith(status: GrowthStatus.loading));
    const dob = '1992-08-15';
    
    try {
      await _repo.updateProfileAttributes(state.user!.identity, {'DOB': dob});
      emit(state.copyWith(
        status: GrowthStatus.success,
        user: state.user!.copyWith(dob: dob)
      ));
      _log(emit, 'Atributo DOB enviado a la nube.');
    } catch (err) {
      emit(state.copyWith(status: GrowthStatus.error));
      _log(emit, 'Error en Update: $err');
    }
  }

  Future<void> _onTrackEvent(TrackEventRequested e, Emitter<GrowthState> emit) async {
    emit(state.copyWith(status: GrowthStatus.loading));
    try {
      await _trackEvent();
      emit(state.copyWith(status: GrowthStatus.success));
      _log(emit, 'Evento "Hola_mundo" enviado con éxito.');
    } catch (err) {
      emit(state.copyWith(status: GrowthStatus.error));
    }
  }

  Future<void> _onSyncData(SyncDataRequested e, Emitter<GrowthState> emit) async {
    emit(state.copyWith(status: GrowthStatus.loading));
    _log(emit, 'Sync 7s: Sincronizando nodos REST...');
    try {
      final results = await _syncData();
      emit(state.copyWith(status: GrowthStatus.success, tasks: [...state.tasks, ...results]));
      _log(emit, 'Sincronización completa: ${results.length} nuevas tareas.');
    } catch (err) {
      emit(state.copyWith(status: GrowthStatus.error));
      _log(emit, 'Error en Sync: $err');
    }
  }

  void _onGenerateTasks(GenerateTasksRequested e, Emitter<GrowthState> emit) {
    // REQUISITO: ListView eficiente (hasta 400 elementos)
    final count = (DateTime.now().millisecond % 399) + 1;
    final list = List.generate(count, (i) => 'Enterprise Task Sprint #${i + 1}');
    emit(state.copyWith(tasks: list));
    _log(emit, 'Generadas $count tareas mediante ListView.builder.');
  }
}
