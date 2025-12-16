import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasecourse/components/coustomButtonAuth.dart';
import 'package:firebasecourse/components/textFormFieldAdd.dart';
import 'package:firebasecourse/infoClop/view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddInfo extends StatefulWidget {
  final String docid;
  const AddInfo({super.key, required this.docid});

  @override
  State<AddInfo> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AddInfo> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController Legend = TextEditingController();
  File? file;
  String? url;
  bool isLoding = false;

  addlegend(BuildContext context) async {
    CollectionReference legend = FirebaseFirestore.instance
        .collection('nameclob')
        .doc(widget.docid)
        .collection("Legend");
    isLoding = true;
    setState(() {});
    return legend
        .add({"nameteam": Legend.text, "url" : url ?? "none"})
        .then((value) {
          print("Clop Added");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ViewInfoClop(clopId: widget.docid),
            ),
          );
        })
        .catchError((error) {
          print("Failed to add Clop: $e");
        })
        .whenComplete(() {
          isLoding = false;
          setState(() {});
        });
  }

  getImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? imagePlayer = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (imagePlayer != null) {
      file = File(imagePlayer!.path);
    }
    var imagename = basename(imagePlayer!.path);
    var storplayer = FirebaseStorage.instance.ref(imagename);
    await storplayer.putFile(file!);
    url = await storplayer.getDownloadURL();
    // Capture a photo.
    // final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  @override
  void dispose() {
    Legend.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Info")),
      body: Form(
        key: formState,
        child: isLoding
            ? Center(child: CircularProgressIndicator(color: Colors.lightBlue))
            : Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    child: CustomeTextFormAdd(
                      hintText: "enter Legend Clob",
                      mycontroller: Legend,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return "Not Empty";
                        }
                        return null;
                      },
                    ),
                  ),
                  CoustomButtonUpload(
                    title: "Upload Image",
                    isSelected: url == null ? false : true,
                    onPressed: () async {
                      await getImage();
                    },
                  ),
                  CoustomButtonAuth(
                    title: "Add",
                    onPressed: () {
                      addlegend(context);
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
