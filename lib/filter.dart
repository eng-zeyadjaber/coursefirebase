import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Filter extends StatefulWidget {
  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  File? file;
  getImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? imagePlayer = await picker.pickImage(
      source: ImageSource.camera,
    );
    // Capture a photo.
    // final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    file = File(imagePlayer!.path);
    setState(() {});
  }

  final Stream<QuerySnapshot> playersStream = FirebaseFirestore.instance
      .collection('players')
      .snapshots();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filter")),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 1, 19, 78),
        child: Icon(Icons.add, color: Colors.lightBlue),
        onPressed: () {
          CollectionReference player = FirebaseFirestore.instance.collection(
            'players',
          );
          DocumentReference player1 = FirebaseFirestore.instance
              .collection("players")
              .doc("1");
          DocumentReference player2 = FirebaseFirestore.instance
              .collection("players")
              .doc("2");
          WriteBatch batch = FirebaseFirestore.instance.batch();
          batch.set(player1, {
            "Name": "savic",
            "Num": 22,
            "Country": "serbia",
            "market value": 30,
          });
          batch.set(player2, {
            "Name": "malcom",
            "Num": 10,
            "Country": "Brasile",
            "market value": 15,
          });
          batch.delete(player2);
          batch.commit();
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil("Filter", (route) => false);
        },
      ),
      body: Container(
        child: StreamBuilder(
          stream: playersStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> player) {
            if (player.hasError) {
              return Text("ERROR");
            }
            if (player.connectionState == ConnectionState.waiting) {
              return Text("Loding ...");
            }
            return ListView.builder(
              itemCount: player.data!.docs.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    DocumentReference documentReference = FirebaseFirestore
                        .instance
                        .collection('players')
                        .doc(player.data!.docs[i].id);
                    FirebaseFirestore.instance.runTransaction((
                      transaction,
                    ) async {
                      DocumentSnapshot snapshot = await transaction.get(
                        documentReference,
                      );
                      if (snapshot.exists) {
                        var snapshotData = snapshot.data();
                        if (snapshotData is Map<String, dynamic>) {
                          int marketValue = snapshotData["market value"] + 5;
                          transaction.update(documentReference, {
                            "market value": marketValue,
                          });
                        }
                      }
                    });
                  },
                  child: Card(
                    child: ListTile(
                      subtitle: Text(
                        "market value : ${player.data!.docs[i]['market value']}M",
                      ),
                      leading: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(player.data!.docs[i]['Country']),
                          IconButton(
                            icon: Icon(Icons.camera_alt, color: Colors.blue),
                            onPressed: () {
                              getImage();
                            },
                          ),
                        ],
                      ),

                      title: Text(
                        player.data!.docs[i]['Name'],
                        style: TextStyle(fontSize: 30),
                      ),
                      trailing: Text("Num : ${player.data!.docs[i]['Num']}"),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
