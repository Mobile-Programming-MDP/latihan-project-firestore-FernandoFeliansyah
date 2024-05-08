// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDb0jUmMF1eZMabxOJveUkqpIIKy00LNXE',
    appId: '1:128085105264:web:b3d77b89006557c83fb2b5',
    messagingSenderId: '128085105264',
    projectId: 'notes-97287',
    authDomain: 'notes-97287.firebaseapp.com',
    storageBucket: 'notes-97287.appspot.com',
    measurementId: 'G-76LXLZR7NT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyARB2vHIzXX6DjJimMxf1UpgFlWkO4GUfw',
    appId: '1:128085105264:android:4d6d9dbe27a66bf43fb2b5',
    messagingSenderId: '128085105264',
    projectId: 'notes-97287',
    storageBucket: 'notes-97287.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDJF_7LWS-sreTa1pHnFBLnbMdI8XMvgzY',
    appId: '1:128085105264:ios:79532ec638a0cf0a3fb2b5',
    messagingSenderId: '128085105264',
    projectId: 'notes-97287',
    storageBucket: 'notes-97287.appspot.com',
    iosBundleId: 'com.example.notes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDJF_7LWS-sreTa1pHnFBLnbMdI8XMvgzY',
    appId: '1:128085105264:ios:1c398b27dcd3c5cc3fb2b5',
    messagingSenderId: '128085105264',
    projectId: 'notes-97287',
    storageBucket: 'notes-97287.appspot.com',
    iosBundleId: 'com.example.notes.RunnerTests',
  );
}