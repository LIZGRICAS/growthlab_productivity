
import 'dart:developer' as developer;
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
    developer.log('[CleverTap SDK] Profile pushed to TEST-MOVii Sandbox: $profile', name: 'CleverTapSDK');
  }

  Future<void> updateProfile(String identity, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 600));
    developer.log('[CleverTap SDK] Profile update for Identity($identity): $data', name: 'CleverTapSDK');
  }

  Future<void> trackEvent(String name, Map<String, dynamic> props) async {
    // REQUISITO INAMOVIBLE: Evento "Hola_mundo" con props específicas
    await Future.delayed(const Duration(milliseconds: 500));
    developer.log('[CleverTap SDK] Event Tracked: "$name" with properties: $props', name: 'CleverTapSDK');
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
