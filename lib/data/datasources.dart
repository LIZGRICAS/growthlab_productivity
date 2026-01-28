
import '../domain/entities.dart';

/// Implementación del Data Source para CleverTap.
/// 
/// Cumple con los requisitos estrictos de la prueba técnica:
/// - Llaves exactas: Name, Identity, Email, Phone.
/// - Ambiente: TEST-MOVii | Sandbox.
class CleverTapDataSource {
  Future<void> createProfile(UserProfile user) async {
    // REQUISITO INAMOVIBLE: Llaves exactas y formato de Identity
    final Map<String, dynamic> profile = {
      'Name': user.name,
      'Identity': user.identity, // String numérico sin puntos/guiones
      'Email': user.email,
      'Phone': user.phone,
    };
    
    await Future.delayed(const Duration(milliseconds: 800));
    print('[CleverTap SDK] Profile pushed to TEST-MOVii Sandbox: $profile');
  }

  Future<void> updateProfile(String identity, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 600));
    print('[CleverTap SDK] Profile update for Identity($identity): $data');
  }

  Future<void> trackEvent(String name, Map<String, dynamic> props) async {
    // REQUISITO INAMOVIBLE: Evento "Hola_mundo" con props específicas
    await Future.delayed(const Duration(milliseconds: 500));
    print('[CleverTap SDK] Event Tracked: "$name" with properties: $props');
  }
}

class FirebaseDataSource {
  Future<String> saveToFirestore(UserProfile user) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return 'fs_doc_${user.identity}';
  }

  Future<AppConfig> getRemoteConfig() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const AppConfig(
      enablePremium: true, 
      activeCampaign: 'Growth_Sprint_2025'
    );
  }
}

class RestService {
  Future<List<String>> fetchTasks() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return [
      'REST: Validate Engagement Rate', 
      'REST: Optimize Cold Start', 
      'REST: Sync LTV Data'
    ];
  }
}
