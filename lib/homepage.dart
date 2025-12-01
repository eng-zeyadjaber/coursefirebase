import 'dart:ffi';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebasecourse/categories/edit.dart';
import 'package:firebasecourse/infoClop/view.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoding = true;
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("nameclob")
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
          Navigator.of(context).pushNamed("addcategory");
        },
        child: Icon(Icons.add, color: Colors.lightBlue),
      ),
      appBar: AppBar(
        title: Text("Choose team"),
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
      body: isLoding == true
          ? Center(child: CircularProgressIndicator(color: Colors.lightBlue))
          : GridView.builder(
              itemCount: data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 160,
              ),
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ViewInfoClop(clopId: data[i].id),
                      ),
                    );
                  },
                  onLongPress: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      title: "Choose",
                      desc: "Choose what you want.",
                      btnCancelText: " delete",
                      btnCancelOnPress: () async {
                        await FirebaseFirestore.instance
                            .collection("nameclob")
                            .doc(data[i].id)
                            .delete();
                        Navigator.of(context).pushReplacementNamed("homepage");
                      },
                      btnOkText: "Edit",
                      btnOkOnPress: () async {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditCategories(
                              docid: data[i].id,
                              oldName: data[i]["nameteam"],
                            ),
                          ),
                        );

                        if (result == true) {
                          // أنظف القائمة ثم أعد جلب البيانات
                          data.clear();
                          setState(() => isLoding = true);
                          await getData();
                        }
                      },
                    ).show();
                  },
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Image.network(
                            "https://i.pinimg.com/736x/31/5a/63/315a6337729ca3ab4e890a46f7daa677.jpg",
                            height: 100,
                          ),
                          Text("${data[i]["nameteam"]}"),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
