import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasecourse/2-%20install.dart';
import 'package:firebasecourse/auth/login.dart';
import 'package:firebasecourse/auth/signup.dart';
import 'package:firebasecourse/categories/add.dart';
import 'package:firebasecourse/filter.dart';
import 'package:firebasecourse/homepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // // 🔥 تفعيل App Check للأندرويد فقط (وضع التطوير)
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.debug,
  // );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _myappState();
}

class _myappState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('============================= User is currently signed out!');
      } else {
        print('============================= User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 1, 19, 78),
          titleTextStyle: TextStyle(
            color: Colors.lightBlue,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.lightBlue),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Filter(),
          // (FirebaseAuth.instance.currentUser != null &&
          //     FirebaseAuth.instance.currentUser!.emailVerified)
          // ? Homepage()
          // : Login(),
      routes: {
        "login": (context) => Login(),
        "signup": (context) => SignUp(),
        "homepage": (context) => Homepage(),
        "addcategory": (context) => AddCategories(),
        "Filter": (context) => Filter(),
      },
    );
  }
}
