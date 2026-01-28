import '../../domain/entities/app_config.dart';
import '../../domain/entities/user_profile.dart';

class FirebaseDataSource {
  Future<String> saveToFirestore(UserProfile user) async {
    // Simula la persistencia en la colección 'users'
    await Future.delayed(const Duration(milliseconds: 1000));
    return 'fs_doc_${user.identity}';
  }

  Future<AppConfig> getRemoteConfig() async {
    // Simula la obtención de parámetros de Firebase Remote Config
    await Future.delayed(const Duration(milliseconds: 300));
    return const AppConfig(
      enablePremium: true, 
      activeCampaign: 'Growth_Sprint_2025',
      syncThreshold: 7,
    );
  }
}
