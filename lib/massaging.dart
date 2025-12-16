import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Massaging extends StatefulWidget {
  const Massaging({super.key});

  @override
  State<Massaging> createState() => _MassagingState();
}

class _MassagingState extends State<Massaging> {
      // في حال كان الإشعار يأتي والمستخدم داخل فالتطبيق
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   if (message.notification != null) {
    //     print("=================================================");
    //     print(message.notification!.title);
    //     print(message.notification!.body);
    //     print("=================================================");
    //   }
    // });
  getToken() async {
    String? mytoken = await FirebaseMessaging.instance.getToken();
    print("==========================================================");
    print(mytoken);
  }

  chatReqPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  @override
  void initState() {
    chatReqPermission();
        // في حال كان الإشعار يأتي والمستخدم داخل فالتطبيق
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   if (message.notification != null) {
    //     print("=================================================");
    //     print(message.notification!.title);
    //     print(message.notification!.body);
    //     print("=================================================");
    //   }
    // });
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Massaging")));
  }
}
