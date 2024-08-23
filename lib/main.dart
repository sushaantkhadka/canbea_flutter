import 'package:canbea_flutter/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyB40uyKA6DndX8fR7R7YCN36WxzuGQHNLc",
            authDomain: "canbe-a.firebaseapp.com",
            projectId: "canbe-a",
            storageBucket: "canbe-a.appspot.com",
            messagingSenderId: "931896274434",
            appId: "1:931896274434:web:8d5d111aa68b7f1439011b",
            measurementId: "G-250Y2SZ247"));
  } else {
    Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
