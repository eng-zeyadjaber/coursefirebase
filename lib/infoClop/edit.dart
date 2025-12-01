import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebasecourse/components/coustomButtonAuth.dart';
import 'package:firebasecourse/components/textFormFieldAdd.dart';
import 'package:firebasecourse/infoClop/view.dart';
import 'package:flutter/material.dart';

class EditInfo extends StatefulWidget {
  final String infodocid;
  final String legendDoId;
  final String value;
  const EditInfo({
    super.key,
    required this.infodocid,
    required this.legendDoId,
    required this.value,
  });

  @override
  State<EditInfo> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<EditInfo> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController Legend = TextEditingController();

  bool isLoding = false;

  editlegend() async {
    // مرجع المجموعة الفرعية داخل المستند الخاص بالـ clop
    final CollectionReference legendColl = FirebaseFirestore.instance
        .collection('nameclob')
        .doc(widget.legendDoId)
        .collection('Legend');

    // تحقق من صحة النموذج أولاً
    if (!formState.currentState!.validate()) {
      return;
    }

    try {
      // تشغيل حالة اللودينج
      setState(() => isLoding = true);

      // تحديث الحقل الموجود في المستند المحدد
      await legendColl.doc(widget.infodocid).update({
        "nameteam": Legend.text.trim(),
      });

      print("Legend Updated");

      // الرجوع/الانتقال لصفحة العرض بعد التعديل
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ViewInfoClop(clopId: widget.legendDoId),
        ),
      );
    } catch (e) {
      // طباعة/معالجة الخطأ
      print("Failed to update Legend: $e");
      // هنا يمكنك إظهار رسالة خطأ للمستخدم إن رغبت
    } finally {
      // إيقاف اللودينج مهما كانت النتيجة
      setState(() => isLoding = false);
    }
  }

  @override
  void initState() {
    Legend.text = widget.value;
    super.initState();
  }

  @override
  void dispose() {
    Legend.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Info")),
      body: Form(
        key: formState,
        child: isLoding
            ? Center(child: CircularProgressIndicator(color: Colors.lightBlue))
            : Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    child: CustomeTextFormAdd(
                      hintText: "Edit Legend Clob",
                      mycontroller: Legend,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return "Not Empty";
                        }
                        return null;
                      },
                    ),
                  ),
                  CoustomButtonAuth(
                    title: "Edit",
                    onPressed: () {
                      editlegend();
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
