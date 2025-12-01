import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebasecourse/components/coustomButtonAuth.dart';
import 'package:firebasecourse/components/textFormFieldAdd.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EditCategories extends StatefulWidget {
  final String docid;
  final String oldName;
  const EditCategories({super.key, required this.docid, required this.oldName});

  @override
  State<EditCategories> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<EditCategories> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController clob = TextEditingController();
  CollectionReference nameclob = FirebaseFirestore.instance.collection(
    'nameclob',
  );
  bool isLoding = false;

  editClop(BuildContext context) async {
    if (formState.currentState!.validate()) {
      try {
        setState(() => isLoding = true);

        // أرسل الحقل الصحيح هنا (مثال: "nameteam")
        await nameclob.doc(widget.docid).set({
          "nameteam": clob.text.trim(),
        }, SetOptions(merge: true));

        setState(() => isLoding = false);

        // اعمل pop مع نتيجة تُشير إلى نجاح التعديل
        Navigator.of(context).pop(true);
      } catch (e) {
        setState(() => isLoding = false);
        print("ERROR $e");
        // يمكن إظهار رسالة خطأ للمستخدم هنا
      }
    }
  }

  @override
  void dispose() {
    clob.dispose();
    super.dispose();
  }

  @override
  void initState() {
    clob.text = widget.oldName;
    super.initState();
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
                        if (val == "") {
                          return "Not Empty";
                        }
                      },
                    ),
                  ),
                  CoustomButtonAuth(
                    title: "Save",
                    onPressed: () {
                      editClop(context);
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
