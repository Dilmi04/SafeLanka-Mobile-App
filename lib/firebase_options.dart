import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAp2Rsf3n7hE8YZ6HFGsU8_xPQkjZQNcxc',
    appId: '1:886931493603:web:af46e42770364b676cebd6',
    messagingSenderId: '886931493603',
    projectId: 'safelanka-56cc6',
    authDomain: 'safelanka-56cc6.firebaseapp.com',
    storageBucket: 'safelanka-56cc6.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyANL9lvtjSMaun_fs0584tKHw8jP_ibbb8',
    appId: '1:886931493603:android:98cc00f1c17ab0886cebd6',
    messagingSenderId: '886931493603',
    projectId: 'safelanka-56cc6',
    storageBucket: 'safelanka-56cc6.firebasestorage.app',
  );
}
