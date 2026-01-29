// GENERATED FILE (TEMPLATE)
// This file is a placeholder for `flutterfire` generated Firebase options.
// Run `flutterfire configure` to generate a real `firebase_options.dart` with
// your project's Firebase configuration values.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    if (Platform.isAndroid) {
      return android;
    }
    if (Platform.isIOS) {
      return ios;
    }
    if (Platform.isMacOS) {
      return macos;
    }
    if (Platform.isWindows) {
      return windows;
    }
    if (Platform.isLinux) {
      return linux;
    }

    throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
  }

  // Web placeholder

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD1iJIhn2yrNWMlRqHC9ANkcQOKP4oqQO4',
    appId: '1:358277570595:web:05814e9fa9d1d7a9a0d196',
    messagingSenderId: '358277570595',
    projectId: 'appweb-54b05',
    authDomain: 'appweb-54b05.firebaseapp.com',
    storageBucket: 'appweb-54b05.firebasestorage.app',
  );

  // Web (configured from provided Firebase project)

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCfBE-LiPt-SxsHgeRBR4aou03AGBfEQrc',
    appId: '1:358277570595:android:3cf2c10e1031c3a4a0d196',
    messagingSenderId: '358277570595',
    projectId: 'appweb-54b05',
    storageBucket: 'appweb-54b05.firebasestorage.app',
  );

  // Android placeholder

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDWSmTkIM8bJqr0yppgy1zD0BNQv7__1k4',
    appId: '1:358277570595:ios:0ca625155ab66e2aa0d196',
    messagingSenderId: '358277570595',
    projectId: 'appweb-54b05',
    storageBucket: 'appweb-54b05.firebasestorage.app',
    iosBundleId: 'com.example.growthlabProductivity',
  );

  // iOS placeholder

  // macOS placeholder
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
    iosBundleId: 'YOUR_MACOS_BUNDLE_ID',
  );

  // Windows placeholder
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  );

  // Linux placeholder
  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  );
}

// NOTE:
// Replace the placeholder strings above or run `flutterfire configure`.
// Example:
//   dart pub global activate flutterfire_cli
//   flutterfire configure --project="<project-id>"