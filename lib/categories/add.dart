import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebasecourse/components/coustomButtonAuth.dart';
import 'package:firebasecourse/components/textFormFieldAdd.dart';
import 'package:flutter/material.dart';

class AddCategories extends StatefulWidget {
  const AddCategories({super.key});

  @override
  State<AddCategories> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AddCategories> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController clob = TextEditingController();
  CollectionReference nameclob = FirebaseFirestore.instance.collection(
    'nameclob',
  );
  bool isLoding = false;

  addClop(BuildContext context) async {
    isLoding = true;
    setState(() {});
    return nameclob
        .add({
          "nameteam": clob.text,
          "id": FirebaseAuth.instance.currentUser!.uid,
        })
        .then((value) {
          print("Clop Added");
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil("homepage", (route) => false);
        })
        .catchError((error) {
          print("Failed to add Clop: $e");
        })
        .whenComplete(() {
          isLoding = false;
          setState(() {});
        });
  }

  @override
  void dispose() {
    clob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Category")),
      body: Form(
        key: formState,
        child: isLoding
            ? Center(child: CircularProgressIndicator(color: Colors.lightBlue))
            : Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    child: CustomeTextFormAdd(
                      hintText: "enter your clob",
                      mycontroller: clob,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return "Not Empty";
                        }
                        return null;
                      },
                    ),
                  ),
                  CoustomButtonAuth(
                    title: "Add",
                    onPressed: () {
                      addClop(context);
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
