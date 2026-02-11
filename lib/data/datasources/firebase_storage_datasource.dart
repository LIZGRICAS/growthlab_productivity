import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageDataSource {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads bytes to the given [path] and returns the download URL.
  Future<String> uploadBytes(String path, Uint8List bytes, {String? contentType}) async {
    final ref = _storage.ref().child(path);
    final metadata = SettableMetadata(contentType: contentType);
    final task = await ref.putData(bytes, metadata);
    return await task.ref.getDownloadURL();
  }

  /// Helper to get an existing file's download URL.
  Future<String> getDownloadUrl(String path) async {
    final ref = _storage.ref().child(path);
    return await ref.getDownloadURL();
  }
}


