import 'package:flutter/material.dart';
import 'package:flutter_uid_input_test/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';

// NOTE:
// - 設定済み
//   - https://firebase.flutter.dev/docs/messaging/ios-integration#configuring-your-app
// - 未設定
//   - https://firebase.flutter.dev/docs/messaging/ios-integration#linking-apns-with-fcm-ios

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase初期化処理
  // - https://firebase.flutter.dev/docs/overview#initializing-flutterfire
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}
