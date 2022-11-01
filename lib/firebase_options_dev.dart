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
      apiKey: 'AIzaSyAp0ULUS8jVhHCKRv55xupk8aGe1TWjfAE',
      authDomain: 'memz-ae633.firebaseapp.com',
      projectId: 'memz-ae633',
      storageBucket: 'memz-ae633.appspot.com',
      messagingSenderId: '801051530454',
      appId: '1:801051530454:web:ea38b970cb4b9ef177e577',
      measurementId: 'G-2LJY3DWS8Z'
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCBpOCTJvcgHSO1-XDhmGNJ-paLHAAratM',
    appId: '1:132381301913:android:2897b20e4406c6ad1eec08',
    messagingSenderId: '132381301913',
    projectId: 'flutterfire-samples',
    storageBucket: 'flutterfire-samples.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAEBMy45SJ5YLmsBMaI6ReLJYsaSfvlywU',
    appId: '1:801051530454:ios:2091a95c8c36848477e577',
    messagingSenderId: '132381301913',
    projectId: 'memz-ae633',
    storageBucket: 'memz-ae633.appspot.com',
    androidClientId: '132381301913-5o1p8r5cr7hbmet7bjtltnk3hiv2eife.apps.googleusercontent.com',
    iosClientId:
        '801051530454-g8ankemrhg0uul9brrls0e2o926ic310.apps.googleusercontent.com',
    iosBundleId: 'com.example.memz',
  );
}