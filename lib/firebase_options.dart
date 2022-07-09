// TODO: comment to self -- API KEY IN FIREBASE ARE TO BE TREATED LIKE A USERNAME, RATHER THAN A PWD

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
    apiKey: 'AIzaSyCCUTvFEyi9NtjVsrv25ky8b_XsesHyO7s',
    appId: '1:215223102915:android:d5e4df779e3a98dcd3a176',
    messagingSenderId: '215223102915',
    projectId: 'integratedplanner',
    storageBucket: 'integratedplanner.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD-v3he2j0f2WSsT26VSbwAt-anrOTYIp0',
    appId: '1:215223102915:ios:f1e5e0e95890c903d3a176',
    messagingSenderId: '215223102915',
    projectId: 'integratedplanner',
    storageBucket: 'integratedplanner.appspot.com',
    androidClientId: '215223102915-ulponesmmr70vaqva9p9cshg28qc5el2.apps.googleusercontent.com',
    iosClientId: '215223102915-fvemmrmarfb24sap2vv367rjhgurk1cc.apps.googleusercontent.com',
    iosBundleId: 'com.example.integratedPlanner',
  );
}
