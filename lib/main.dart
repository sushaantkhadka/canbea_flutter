import 'package:canbea_flutter/helper/helper_function.dart';
import 'package:canbea_flutter/pages/auth/login_page.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunction.getUserLoggedInStauts().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: _isSignedIn ? const HomePage() : const LoginPage(),
    );
  }
}
