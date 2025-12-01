import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasecourse/components/coustomButtonAuth.dart';
import 'package:firebasecourse/components/coustomLogoAuth.dart';
import 'package:firebasecourse/components/textFormField.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Form(
              key: formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 8),
                  Coustomlogoauth(),
                  Container(height: 20),
                  ListTile(
                    title: Text(
                      "SignUp",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        height: 1.8,
                      ),
                    ),
                    subtitle: Text(
                      "SignUp To Continue Using The App",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Container(height: 20),
                  Text(
                    "User Name",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(height: 10),
                  CustomeTextForm(
                    hintText: 'Entre Your User Name',
                    mycontroller: username,
                    validator: (val) {
                      if (val == "") {
                        return "Empty text";
                      }
                    },
                  ),
                  Container(height: 20),
                  Text(
                    "Email",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(height: 10),
                  CustomeTextForm(
                    hintText: 'Entre Your Email',
                    mycontroller: email,
                    validator: (val) {
                      if (val == "") {
                        return "Empty text";
                      }
                    },
                  ),
                  Container(height: 10),
                  Text(
                    "Password",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(height: 10),
                  CustomeTextForm(
                    hintText: 'Entre Your Password',
                    mycontroller: password,
                    validator: (val) {
                      if (val == "") {
                        return "Empty text";
                      }
                    },
                  ),
                  Container(height: 20),
                  Text(
                    "Confirm Password",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(height: 10),
                  CustomeTextForm(
                    hintText: 'Entre Your Password',
                    mycontroller: password,
                    validator: (val) {
                      if (val == "") {
                        return "Empty text";
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(height: 20),
            CoustomButtonAuth(
              title: "SignUp",
              onPressed: () async {
                if (formState.currentState!.validate()) {
                  try {
                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                          email: email.text,
                          password: password.text,
                        );
                    FirebaseAuth.instance.currentUser!.sendEmailVerification();
                    Navigator.of(context).pushReplacementNamed("login");
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print(
                        '=================================The password provided is too weak.',
                      );
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        title: "weak-password",
                        desc: "The password provided is too weak.",
                        btnOkOnPress: () {},
                      ).show();
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        title: "email-already-in-use",
                        desc: "The account already exists for that email.",
                        btnOkOnPress: () {},
                      ).show();
                    }
                  } catch (e) {
                    print(e);
                  }
                }
              },
            ),
            Container(height: 20),
            InkWell(
              child: Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "You Have Any Account ? "),
                      TextSpan(
                        text: "Log In",
                        style: TextStyle(
                          color: Colors.cyan,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed("login");
              },
            ),
          ],
        ),
      ),
    );
  }
}
