import 'package:flutter/material.dart';

class tow extends StatefulWidget {
  const tow({super.key});

  @override
  State<tow> createState() => _towState();
}

class _towState extends State<tow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("firebase install"),),
      body: ListView(
        children: [
          Text("Abo alzeed", style: TextStyle(fontSize: 50),)
        ],
      ),
    );
  }
}