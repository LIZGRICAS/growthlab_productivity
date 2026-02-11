//Solo ejecuta llamadas técnicas directas al `clevertap_plugin` oficial.

// Usa la API del complemento cuando está disponible;
//detecta errores de la plataforma y vuelve a un breve retraso + registro para mantener un comportamiento determinista en las pruebas/CI.
import 'dart:developer' as developer;
import 'typed_clevertap.dart';
import '../../domain/entities/user_profile.dart';


class CleverTapDataSource {

  // Convierte Entities → Map (transformación de datos específica de la plataforma por fuera del dominio Traduce a formato CleverTap).
  Future<void> onUserLogin(UserProfile profile) async {
    final Map<String, dynamic> profileMap = {
      'Name': profile.name,
      'Identity': profile.identity,
      'Email': profile.email,
      'Phone': profile.phone,
    };

    try {
      //Llama al wrapper tipado que utiliza MethodChannel de clevertap para llegar al complemento con estabilidad.
      await TypedCleverTap.onUserLogin(profileMap);
    } catch (e) {
      // Evita crash en QA / CI y permite que la app siga viva
      await Future.delayed(const Duration(milliseconds: 800));
      developer.log('[CleverTapDataSource] onUserLogin fallback: $profileMap — $e', name: 'CleverTapDataSource', error: e);
    }
  }

  // Ayuda para diagnósticos, Pruebas manuales, Saltarse Entity (solo aquí) para llamar con un tipo de formato de perfil sin procesar en el dominio. Útil para pruebas, depuración y compatibilidad con versiones anteriores del complemento que podrían no admitir el formato de perfil completo.
  Future<void> onUserLoginFromMap(Map<String, dynamic> profileMap) async {
    try {
      await TypedCleverTap.onUserLogin(profileMap);
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 800));
      developer.log('[CleverTapDataSource] onUserLoginFromMap fallback: $profileMap — $e', name: 'CleverTapDataSource', error: e);
    }
  }

  Future<void> profilePush(String identity, Map<String, dynamic> attributes) async {
    final Map<String, dynamic> attrs = Map.of(attributes);
    attrs['Identity'] = identity;

    // Recibe identity separada
    // Adjunta Identity como CleverTap requiere
    // No muta el Map original

    try {
      // Prueba las API de perfil comunes utilizadas en todas las versiones del complemento.
      // Utiliza wrapper tipado que invoca el complemento de la plataforma a través de MethodChannel.
      // Push incremental
      // No login completo
      await TypedCleverTap.profilePush(attrs);
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 600));
      developer.log('[CleverTapDataSource] profilePush fallback: $attrs — $e', name: 'CleverTapDataSource', error: e);
    }
  }

  Future<void> trackEvent(String name, Map<String, dynamic> properties) async {
// Evento técnico - Solo ejecuta llamadas técnicas que coordina-decide el repositorio
// Payload ya decidido en Use Case
// Infraestructura pura
    try {
      await TypedCleverTap.recordEvent(name, properties);
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 500));
      developer.log('[CleverTapDataSource] trackEvent fallback: $name $properties — $e', name: 'CleverTapDataSource', error: e);
    }
  }
  
  
  Future<void> trackError(
    String name,
    String message,
    Map<String, dynamic> properties,
  ) async {
    // CleverTap no tiene "errores" como concepto fuerte,
    // así que se modela como evento especial.
    await trackEvent(
      name,
      {
        'error_message': message,
        ...properties,
      },
    );
  }
}
