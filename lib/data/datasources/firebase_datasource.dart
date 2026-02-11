// Dependencia directa del SDK de Firebase
// Infraestructura pura, persistir y leer datos desde Firebase
// No debe subir más arriba en capas el modelo lo sigue conservando el dominio
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/entities/app_config.dart';

class FirebaseDataSource {

  //Inyección de dependencias para facilitar pruebas unitarias y evitar acoplamiento directo al SDK de Firebase. Permite pasar instancias mock o fake durante las pruebas.
  final FirebaseFirestore _firestore;
  final FirebaseRemoteConfig _remoteConfig;

  FirebaseDataSource({FirebaseFirestore? firestore, FirebaseRemoteConfig? remoteConfig})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance;

//El DataSource consume Entities - UserProfile
  Future<String> saveToFirestore(UserProfile user) async {
    //Traduce Entities → formato Firebase
    try {
      //recibe modelo de entidad, lo traduce a formato Firebase (Map) y lo guarda en Firestore. Devuelve el ID del documento creado.
      final docRef = await _firestore.collection('users').add({
        'name': user.name,
        'identity': user.identity,
        'email': user.email,
        'phone': user.phone,
        if (user.dob != null) 'dob': user.dob,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      throw Exception('Firestore save failed: $e');
    }
  }

// conecta Firebase Remote Config con Domain. El Use Case decide qué keys pedir, el DataSource se encarga de la lógica de conexión con Firebase Remote Config, manejo de errores y fallback a valores seguros. El Use Case no sabe nada de Firebase, solo sabe que tiene un repositorio que le permite obtener la configuración remota. El DataSource traduce el formato de datos de Firebase a la entidad AppConfig del dominio.
  Future<AppConfig> getRemoteConfig() async {
    //Define timeouts, fallback y valores por defecto para evitar que fallos en la conexión a Firebase rompan la app. Traduce el formato de datos de Firebase a la entidad AppConfig del dominio.
    try {
      //1. Descarga configuración de Firebase Remote Config con timeouts y valores por defecto seguros para evitar que fallos en la conexión rompan la app.
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ));
      // 2. Activa valores, Valores predeterminados seguros en caso de que la búsqueda falle o falten claves
      await _remoteConfig.setDefaults(<String, dynamic>{
        'enable_premium': false,
        'active_campaign': 'None',
      });

      await _remoteConfig.fetchAndActivate();

      final enablePremium = _remoteConfig.getBool('enable_premium');
      final activeCampaign = _remoteConfig.getString('active_campaign');
      final int syncThreshold = _remoteConfig.getInt('sync_threshold');

    //3. Actualiza estado interno o devuelve una entidad del dominio con la configuración obtenida, garantizando que siempre se devuelven valores seguros incluso si la conexión a Firebase falla.
      return AppConfig(
        enablePremium: enablePremium,
        activeCampaign: activeCampaign.isNotEmpty ? activeCampaign : 'None',
        syncThreshold: syncThreshold,
      );
    } catch (e) {
      // Fallback to safe defaults
      return const AppConfig(enablePremium: false, activeCampaign: 'None', syncThreshold: 0);
    }
  }
}
//flujo, descarga datos de Firebase Remote Config, maneja errores y devuelve una entidad del dominio con valores seguros en caso de fallo. El Use Case solo coordina la llamada al repositorio, no tiene lógica de negocio ni sabe nada de Firebase. El DataSource se encarga de toda la lógica de conexión con Firebase, manejo de errores y traducción de datos a entidades del dominio.
// Garantiza valores seguros
// Evita nulls
// Hace la app estable offline