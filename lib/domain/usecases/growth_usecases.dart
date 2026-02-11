
// Caso de uso de negocio.
// Coordina: Define QUÉ evento se registra y con QUÉ significado.
// El repositorio decide cómo enviarlo.

import '../entities/user_profile.dart';
import '../repositories/analytics_repository.dart';

class CreateUserProfileUseCase {
  final AnalyticsRepository repository;
  CreateUserProfileUseCase(this.repository);

// recibe el userprofile ya creado (validado) y lo manda al repositorio para que lo guarde en la base de datos. 
 Future<void> call(UserProfile profile) {
    // Regla de negocio de flujo
    if (profile.firebaseId != null) {
      throw StateError('User already registered');
    }

    return repository.createUserProfile(profile);
  }
}

//Registrar un evento de productividad
class TrackProductivityUseCase {
  final AnalyticsRepository repository;
  TrackProductivityUseCase(this.repository);

//1. Se decide el nombre del evento: Hola_mundo
//2. Se construye el payload
//3. Se delega al repositorio
  Future<void> call() {
    return repository.trackProductivityEvent('Hola_mundo', {
      'years_mobile_experience': 8,
      'years_flutter_experience': 5,
      'published_apps': 12,
    });
  }
}

// Caso de uso que representa una acción de negocio:
// "sincronizar datos externos".
// El dominio no sabe de Firebase o REST.
class SyncDataUseCase {
  final AnalyticsRepository repository;
  SyncDataUseCase(this.repository);

  Future<List<String>> call() => repository.syncExternalData();
}
