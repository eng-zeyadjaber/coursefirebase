import 'dart:ffi';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebasecourse/categories/edit.dart';
import 'package:firebasecourse/infoClop/add.dart';
import 'package:firebasecourse/infoClop/edit.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ViewInfoClop extends StatefulWidget {
  final String clopId;
  const ViewInfoClop({super.key, required this.clopId});

  @override
  State<ViewInfoClop> createState() => _HomepageState();
}

class _HomepageState extends State<ViewInfoClop> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoding = true;
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("nameclob")
        .doc(widget.clopId)
        .collection("Legend")
        .get();

    await Future.delayed(Duration(seconds: 1));
    data = querySnapshot.docs; // استبدال بدلاً من الإضافة
    isLoding = false;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 2, 29, 117),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddInfo(docid: widget.clopId),
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.lightBlue),
      ),
      appBar: AppBar(
        title: Text("Legend Clop"),
        actions: [
          IconButton(
            onPressed: () async {
              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();
              await FirebaseAuth.instance.signOut();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil("login", (route) => false);
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: WillPopScope(
        child: isLoding == true
            ? Center(child: CircularProgressIndicator(color: Colors.lightBlue))
            : GridView.builder(
                itemCount: data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 160,
                ),
                itemBuilder: (context, i) {
                  return InkWell(
                    onLongPress: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.question,
                        title: "delete",
                        desc: "Are you sure about deleting it?.",
                        btnCancelOnPress: () async {},
                        btnOkText: "Delete",
                        btnOkOnPress: () async {
                          await FirebaseFirestore.instance
                              .collection("nameclob")
                              .doc(widget.clopId)
                              .collection("Legend")
                              .doc(data[i].id)
                              .delete();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ViewInfoClop(clopId: widget.clopId),
                            ),
                          );
                        },
                      ).show();
                    },
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditInfo(
                            infodocid: data[i].id,
                            legendDoId: widget.clopId,
                            value: data[i]["nameteam"],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [Text("${data[i]["nameteam"]}")],
                        ),
                      ),
                    ),
                  );
                },
              ),
        onWillPop: () {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil("homepage", (route) => false);
          return Future.value(false);
        },
      ),
    );
  }
}
