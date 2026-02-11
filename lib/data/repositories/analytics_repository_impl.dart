//Implementa el contrato que el dominio exige para cumplir con los casos de uso definidos. Esta implementación se encarga de interactuar con las fuentes de datos concretas (como CleverTap, Firebase, REST APIs, etc.) para realizar las operaciones necesarias. El repositorio actúa como un puente entre el dominio y las fuentes de datos, traduciendo las llamadas del dominio a las operaciones específicas de cada fuente de datos. El repositorio no debe contener lógica de negocio, solo debe coordinar las llamadas a las fuentes de datos y manejar la transformación de datos si es necesario.
//Aquí aparece toda la infraestructura
import '../../domain/entities/user_profile.dart';
import 'dart:typed_data';
import '../../domain/repositories/analytics_repository.dart';
import '../datasources/clevertap_datasource.dart';
import '../datasources/firebase_datasource.dart';
import '../datasources/firebase_storage_datasource.dart';
import '../datasources/rest_datasource.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  //Inyección de dependencias
  final CleverTapDataSource cleverTap; //Reponsabilidad: Analytics / perfiles
  final FirebaseDataSource firebase;   //Responsabilidad: Firestore / base de datos - persistencia
  final FirebaseStorageDataSource storage; //Responsabilidad: Almacenamiento de archivos 
  final RestDataSource rest;            //Responsabilidad: Llamadas REST / APIs externas - datos externos

  AnalyticsRepositoryImpl({
    required this.cleverTap,
    required this.firebase,
    required this.storage,
    required this.rest,
  });


  @override
  Future<void> createUserProfile(UserProfile profile) async {
    await cleverTap.onUserLogin(profile);
    await firebase.saveToFirestore(profile);
  }
// 🔍 Flujo exacto:
// 1. Recibe una Entity válida
// 2. Envía el perfil a CleverTap
// 3. Persiste el perfil en Firestore
// 📌 Observación importante:
// Una sola acción de negocio
// Dos infraestructuras distintas

  @override
  Future<void> updateProfileAttributes(String identity, Map<String, dynamic> attributes) async {
    await cleverTap.profilePush(identity, attributes);
  }
// 🔍 Flujo
// Se actualiza SOLO en CleverTap
// No toca Firebase
// 📌 Decisión de negocio implícita:
// “Estos atributos son solo de analytics”

  @override
  Future<void> trackProductivityEvent(String name, Map<String, dynamic> properties) async {
    await cleverTap.trackEvent(name, properties);
  }
//Evento puramente analítico, no persistente. No toca Firebase, solo CleverTap. El repositorio se encarga de construir el payload y enviarlo a CleverTap, el usecase solo decide el nombre del evento y delega al repositorio para que construya el payload y lo envie a CleverTap. El usecase no tiene logica de negocio, solo coordina la llamada al repositorio. El usecase no sabe nada de CleverTap, solo sabe que tiene un repositorio que le permite trackear eventos de productividad.
  
    @override
  Future<void> trackErrorEvent(
    String name,
    String message,
    Map<String, dynamic> properties,
  ) async {
    await cleverTap.trackError(
      name,
      message,
      properties,
    );
  }

  @override
  Future<String> uploadProfilePhoto(String identity, List<int> bytes, {String? contentType}) async {
    final path = 'profiles/$identity/profile_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final url = await storage.uploadBytes(path, Uint8List.fromList(bytes), contentType: contentType ?? 'image/jpeg');
    return url;
  }
// 🔍 Flujo
// 1. Construye path (decisión técnica)
// 2. Sube binarios
// 3. Devuelve URL pública
// 📌 El dominio pidió:
// “Sube una foto y dame una referencia”
// 📌 El repositorio decide cómo.

  @override
  Future<List<String>> syncExternalData() async {
    // REQUISITO SENIOR: Simulación de latencia de 7 segundos para sincronización pesada
    await Future.delayed(const Duration(seconds: 7));
    return await rest.fetchExternalTasks();
  }
// Simulación de carga pesada
// Delegación a REST
// Retorno de resultados
// 📌 Esto alimenta diagnostics_page.

}

// Esta clase cumple la promesa del dominio
// Es el único lugar donde:
// se combinan múltiples fuentes
// se decide a qué servicio llamar
// Solo responde a pedidos del dominio