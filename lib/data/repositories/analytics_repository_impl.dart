import '../../domain/entities.dart';
import 'dart:typed_data';
import '../../domain/repositories/analytics_repository.dart';
import '../datasources/clevertap_datasource.dart';
import '../datasources/firebase_datasource.dart';
import '../datasources/firebase_storage_datasource.dart';
import '../datasources/rest_datasource.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final CleverTapDataSource cleverTap;
  final FirebaseDataSource firebase;
  final FirebaseStorageDataSource storage;
  final RestDataSource rest;

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

  @override
  Future<void> updateProfileAttributes(String identity, Map<String, dynamic> attributes) async {
    await cleverTap.profilePush(identity, attributes);
  }

  @override
  Future<void> trackProductivityEvent(String name, Map<String, dynamic> properties) async {
    await cleverTap.trackEvent(name, properties);
  }

  @override
  Future<String> uploadProfilePhoto(String identity, List<int> bytes, {String? contentType}) async {
    final path = 'profiles/$identity/profile_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final url = await storage.uploadBytes(path, Uint8List.fromList(bytes), contentType: contentType ?? 'image/jpeg');
    return url;
  }

  @override
  Future<List<String>> syncExternalData() async {
    // REQUISITO SENIOR: Simulación de latencia de 7 segundos para sincronización pesada
    await Future.delayed(const Duration(seconds: 7));
    return await rest.fetchExternalTasks();
  }
}
