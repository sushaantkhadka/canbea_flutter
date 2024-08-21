import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:teamchat/pages/home_page.dart';
 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAx5PnCFkbRnI_Y-NgfBR7qTUoL1RELEFs",
            authDomain: "teamchat-2038f.firebaseapp.com",
            projectId: "teamchat-2038f",
            storageBucket: "teamchat-2038f.appspot.com",
            messagingSenderId: "637872687540",
            appId: "1:637872687540:web:18f5544cc5be1ca4a10ae1",
            measurementId: "G-E7PRBBYD80"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
