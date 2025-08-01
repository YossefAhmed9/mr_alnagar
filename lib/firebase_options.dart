// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyCCWARrjdz-k8JfsD4kwCCfnGSWouzc_pQ',
    appId: '1:226156872841:web:a578c6c2e0c39959d53258',
    messagingSenderId: '226156872841',
    projectId: 'nagar-5f94a',
    authDomain: 'nagar-5f94a.firebaseapp.com',
    storageBucket: 'nagar-5f94a.firebasestorage.app',
    measurementId: 'G-7WH4PPH78M',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBdxfpsXT41CAx9eMclGD0MYR_7Sjvfuiw',
    appId: '1:226156872841:android:4009261642df8297d53258',
    messagingSenderId: '226156872841',
    projectId: 'nagar-5f94a',
    storageBucket: 'nagar-5f94a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBaYqePlYkGFQoRIAyXBEmew_NaIWPz7C4',
    appId: '1:226156872841:ios:dc8d1d517908031bd53258',
    messagingSenderId: '226156872841',
    projectId: 'nagar-5f94a',
    storageBucket: 'nagar-5f94a.firebasestorage.app',
    iosBundleId: 'com.mralnagar.app.mrAlnagar',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBaYqePlYkGFQoRIAyXBEmew_NaIWPz7C4',
    appId: '1:226156872841:ios:dc8d1d517908031bd53258',
    messagingSenderId: '226156872841',
    projectId: 'nagar-5f94a',
    storageBucket: 'nagar-5f94a.firebasestorage.app',
    iosBundleId: 'com.mralnagar.app.mrAlnagar',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCCWARrjdz-k8JfsD4kwCCfnGSWouzc_pQ',
    appId: '1:226156872841:web:4213a6692bb53fb5d53258',
    messagingSenderId: '226156872841',
    projectId: 'nagar-5f94a',
    authDomain: 'nagar-5f94a.firebaseapp.com',
    storageBucket: 'nagar-5f94a.firebasestorage.app',
    measurementId: 'G-NE9CTY3R1Q',
  );
}
