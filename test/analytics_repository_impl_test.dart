// ignore_for_file: missing_implementations

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:growthlab_productivity/data/repositories/analytics_repository_impl.dart';
import 'package:growthlab_productivity/data/datasources/clevertap_datasource.dart';
import 'package:growthlab_productivity/data/datasources/firebase_datasource.dart';
import 'package:growthlab_productivity/data/datasources/firebase_storage_datasource.dart';
import 'package:growthlab_productivity/data/datasources/rest_datasource.dart';
import 'package:growthlab_productivity/domain/entities.dart';

class MockCleverTap extends Mock implements CleverTapDataSource {}
class MockFirebaseDS extends Mock implements FirebaseDataSource {}
class MockStorageDS extends Mock implements FirebaseStorageDataSource {}
class MockRestDS extends Mock implements RestDataSource {}

void main() {
  late MockCleverTap mockCleverTap;
  late MockFirebaseDS mockFirebase;
  late MockStorageDS mockStorage;
  late MockRestDS mockRest;
  late AnalyticsRepositoryImpl repo;

  setUp(() {
    mockCleverTap = MockCleverTap();
    mockFirebase = MockFirebaseDS();
    mockStorage = MockStorageDS();
    mockRest = MockRestDS();

    repo = AnalyticsRepositoryImpl(
      cleverTap: mockCleverTap,
      firebase: mockFirebase,
      storage: mockStorage,
      rest: mockRest,
    );
  });

  setUpAll(() {
    registerFallbackValue(const UserProfile(name: 'X', identity: '0', email: 'x@x.com', phone: '0'));
    registerFallbackValue(Uint8List.fromList([]));
  });

  test('createUserProfile calls cleverTap and firestore', () async {
    final profile = const UserProfile(
      name: 'Test',
      identity: '123',
      email: 'a@b.com',
      phone: '555',
    );

    when(() => mockCleverTap.onUserLogin(any())).thenAnswer((_) async {});
    when(() => mockFirebase.saveToFirestore(any())).thenAnswer((_) async => 'doc-1');

    await repo.createUserProfile(profile);

    verify(() => mockCleverTap.onUserLogin(profile)).called(1);
    verify(() => mockFirebase.saveToFirestore(profile)).called(1);
  });

  test('uploadProfilePhoto returns download URL', () async {
    when(() => mockStorage.uploadBytes(any(), any(), contentType: any(named: 'contentType')))
      .thenAnswer((_) async => 'https://storage.example/photo.jpg');

    final url = await repo.uploadProfilePhoto('id-1', [1,2,3]);

    expect(url, 'https://storage.example/photo.jpg');
    verify(() => mockStorage.uploadBytes(any(), any(), contentType: any(named: 'contentType'))).called(1);
  });

  test('syncExternalData returns list from rest datasource', () async {
    when(() => mockRest.fetchExternalTasks()).thenAnswer((_) async => ['a','b']);

    final results = await repo.syncExternalData();

    expect(results, ['a','b']);
    verify(() => mockRest.fetchExternalTasks()).called(1);
  });
}
