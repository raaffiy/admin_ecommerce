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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfuephiez4vOO3TfkCtheSfv7wy3tDlGI',
    appId: '1:32680173842:android:cf7accbce7cf08b976d3cb',
    messagingSenderId: '32680173842',
    projectId: 'ecommerce-flutter-d7c41',
    storageBucket: 'ecommerce-flutter-d7c41.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCNYlPqKEnHEEHvi81Zt0CGwXQ_50RoyQ4',
    appId: '1:32680173842:ios:8b5780e4b5f6123e76d3cb',
    messagingSenderId: '32680173842',
    projectId: 'ecommerce-flutter-d7c41',
    storageBucket: 'ecommerce-flutter-d7c41.appspot.com',
    androidClientId: '32680173842-bv1gv1scajole5hnaj3f2eaed174e7fd.apps.googleusercontent.com',
    iosClientId: '32680173842-6k0spkb8o8g3u6e513rpu6bvep2f5fki.apps.googleusercontent.com',
    iosBundleId: 'com.example.admin',
  );
}
