import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../domain/entities.dart';

class FirebaseDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseRemoteConfig _remoteConfig;

  FirebaseDataSource({FirebaseFirestore? firestore, FirebaseRemoteConfig? remoteConfig})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance;

  Future<String> saveToFirestore(UserProfile user) async {
    try {
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

  Future<AppConfig> getRemoteConfig() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ));
      // Safe defaults in case fetch fails or keys are missing
      await _remoteConfig.setDefaults(<String, dynamic>{
        'enable_premium': false,
        'active_campaign': 'None',
      });
      await _remoteConfig.fetchAndActivate();

      final enablePremium = _remoteConfig.getBool('enable_premium');
      final activeCampaign = _remoteConfig.getString('active_campaign');

      return AppConfig(
        enablePremium: enablePremium,
        activeCampaign: activeCampaign.isNotEmpty ? activeCampaign : 'None',
      );
    } catch (e) {
      // Fallback to safe defaults
      return const AppConfig(enablePremium: false, activeCampaign: 'None');
    }
  }
}
