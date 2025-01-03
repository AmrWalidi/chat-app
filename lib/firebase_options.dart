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
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCJL4alN5aiaVizHRwM7FEEizpiCMAezFc',
    appId: '1:40691385529:web:3802aaf12dc40a9ba24768',
    messagingSenderId: '40691385529',
    projectId: 'chatapp-ab5c3',
    authDomain: 'chatapp-ab5c3.firebaseapp.com',
    storageBucket: 'chatapp-ab5c3.firebasestorage.app',
  );
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB-fUECme_lk0b7b2w0b1XHKUIKzBMi4BQ',
    appId: '1:40691385529:android:f1a0bc774ea3ac61a24768',
    messagingSenderId: '40691385529',
    projectId: 'chatapp-ab5c3',
    storageBucket: 'chatapp-ab5c3.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBj2mbgfnNIr6Eb_jSZtppvEO3aUvC-298',
    appId: '1:40691385529:ios:f6809fe9588b4d0ba24768',
    messagingSenderId: '40691385529',
    projectId: 'chatapp-ab5c3',
    storageBucket: 'chatapp-ab5c3.firebasestorage.app',
    iosBundleId: 'com.example.chatApp',
  );
}