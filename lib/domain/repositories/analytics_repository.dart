
// Define el contrato central del dominio. No dice cómo, solo qué.
// El repositorio conoce Entities
// Define qué necesita el dominio del mundo exterior.
// No define cómo, ni con qué tecnología.
import '../entities/user_profile.dart';

// el usecase decide el evento y el repositorio se encarga de construir el payload y enviarlo a la plataforma de analitica. El usecase no decide el payload, solo decide el evento y delega al repositorio para que construya el payload y lo envie a la plataforma de analitica. El usecase no tiene logica de negocio, solo coordina la llamada al repositorio. El usecase no sabe nada de la plataforma de analitica, solo sabe que tiene un repositorio que le permite trackear eventos de productividad. El usecase no tiene logica de negocio, solo coordina la llamada al repositorio. El usecase no sabe nada de la plataforma de analitica, solo sabe que tiene un repositorio que le permite trackear eventos de productividad.
abstract class AnalyticsRepository {
  //Crear un perfil de usuario
  Future<void> createUserProfile(UserProfile profile);
  //Actualizar atributos del perfil de usuario
  Future<void> updateProfileAttributes(String identity, Map<String, dynamic> attributes);
  //Registrar un evento de productividad
  Future<void> trackProductivityEvent(String name, Map<String, dynamic> properties);
  //Registrar un evento de error
  Future<void> trackErrorEvent(String name, String message, Map<String, dynamic> properties);
  //Registrar un evento de uso de una funcionalidad específica, Sincronizar datos y devolver trazas, muy útil para diagnostics_page, debugging,QA
  Future<List<String>> syncExternalData();
  //Subir una foto de perfil a un servicio de almacenamiento y obtener la URL de la foto
  Future<String> uploadProfilePhoto(String identity, List<int> bytes, {String? contentType});
}

// 📌 El repositorio NO valida reglas de negocio
// 📌 Solo cumple contratos