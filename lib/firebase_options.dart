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
    apiKey: 'AIzaSyAx5PnCFkbRnI_Y-NgfBR7qTUoL1RELEFs',
    appId: '1:637872687540:web:18f5544cc5be1ca4a10ae1',
    messagingSenderId: '637872687540',
    projectId: 'teamchat-2038f',
    authDomain: 'teamchat-2038f.firebaseapp.com',
    storageBucket: 'teamchat-2038f.appspot.com',
    measurementId: 'G-E7PRBBYD80',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDhaGmeOh52c5_OqVtADGZzlceCwD9E0kY',
    appId: '1:637872687540:android:1743e39128f1d128a10ae1',
    messagingSenderId: '637872687540',
    projectId: 'teamchat-2038f',
    storageBucket: 'teamchat-2038f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDqVuZ7VRJZUDbcC8NRbSo407nK7rJtJlc',
    appId: '1:637872687540:ios:24e6135e325e2c2fa10ae1',
    messagingSenderId: '637872687540',
    projectId: 'teamchat-2038f',
    storageBucket: 'teamchat-2038f.appspot.com',
    iosBundleId: 'com.example.teamchat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDqVuZ7VRJZUDbcC8NRbSo407nK7rJtJlc',
    appId: '1:637872687540:ios:24e6135e325e2c2fa10ae1',
    messagingSenderId: '637872687540',
    projectId: 'teamchat-2038f',
    storageBucket: 'teamchat-2038f.appspot.com',
    iosBundleId: 'com.example.teamchat',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAx5PnCFkbRnI_Y-NgfBR7qTUoL1RELEFs',
    appId: '1:637872687540:web:bf281ac9f2956f82a10ae1',
    messagingSenderId: '637872687540',
    projectId: 'teamchat-2038f',
    authDomain: 'teamchat-2038f.firebaseapp.com',
    storageBucket: 'teamchat-2038f.appspot.com',
    measurementId: 'G-4E0BNZXVH1',
  );
}
