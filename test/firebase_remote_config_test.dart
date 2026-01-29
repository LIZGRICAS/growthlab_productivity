import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:growthlab_productivity/data/datasources/firebase_datasource.dart';
import 'package:growthlab_productivity/domain/entities.dart';

class MockRemoteConfig extends Mock implements FirebaseRemoteConfig {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  late MockRemoteConfig mockRemote;
  late MockFirebaseFirestore mockFirestore;
  late FirebaseDataSource ds;

  setUpAll(() {
    registerFallbackValue(RemoteConfigSettings(fetchTimeout: const Duration(seconds: 1), minimumFetchInterval: const Duration(seconds: 1)));
  });

  setUp(() {
    mockRemote = MockRemoteConfig();
    mockFirestore = MockFirebaseFirestore();
    ds = FirebaseDataSource(remoteConfig: mockRemote, firestore: mockFirestore);
  });

  test('getRemoteConfig returns AppConfig from remote values', () async {
    when(() => mockRemote.setConfigSettings(any())).thenAnswer((_) async {});
    when(() => mockRemote.setDefaults(any())).thenAnswer((_) async {});
    when(() => mockRemote.fetchAndActivate()).thenAnswer((_) async => true);
    when(() => mockRemote.getBool('enable_premium')).thenReturn(true);
    when(() => mockRemote.getString('active_campaign')).thenReturn('CampaignX');

    final cfg = await ds.getRemoteConfig();

    expect(cfg, const AppConfig(enablePremium: true, activeCampaign: 'CampaignX'));

    verify(() => mockRemote.setConfigSettings(any())).called(1);
    verify(() => mockRemote.setDefaults(any())).called(1);
    verify(() => mockRemote.fetchAndActivate()).called(1);
  });

  test('getRemoteConfig falls back to safe defaults on exception', () async {
    when(() => mockRemote.setConfigSettings(any())).thenThrow(Exception('boom'));

    final cfg = await ds.getRemoteConfig();

    expect(cfg, const AppConfig(enablePremium: false, activeCampaign: 'None'));
  });
}
