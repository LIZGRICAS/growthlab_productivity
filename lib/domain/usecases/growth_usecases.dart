
import '../entities/user_profile.dart';
import '../repositories/analytics_repository.dart';

class CreateUserProfileUseCase {
  final AnalyticsRepository repository;
  CreateUserProfileUseCase(this.repository);

  Future<void> call(UserProfile profile) => repository.createUserProfile(profile);
}

class TrackProductivityUseCase {
  final AnalyticsRepository repository;
  TrackProductivityUseCase(this.repository);

  Future<void> call() {
    return repository.trackProductivityEvent('Hola_mundo', {
      'years_mobile_experience': 8,
      'years_flutter_experience': 5,
      'published_apps': 12,
    });
  }
}

class SyncDataUseCase {
  final AnalyticsRepository repository;
  SyncDataUseCase(this.repository);

  Future<List<String>> call() => repository.syncExternalData();
}
