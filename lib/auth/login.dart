import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasecourse/components/coustomButtonAuth.dart';
import 'package:firebasecourse/components/coustomLogoAuth.dart';
import 'package:firebasecourse/components/textFormField.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            SizedBox(height: 50),
            Coustomlogoauth(),
            SizedBox(height: 20),

            // Login Title
            ListTile(
              title: Text(
                "Login",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  height: 1.8,
                ),
              ),
              subtitle: Text(
                "Login To Continue Using The App",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: 20),

            // Email
            Text(
              "Email",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CustomeTextForm(hintText: "Enter Your Email", mycontroller: email),
            SizedBox(height: 10),

            // Password
            Text(
              "Password",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CustomeTextForm(
              hintText: "Enter Your Password",
              mycontroller: password,
            ),

            SizedBox(height: 20),

            // Login Button
            CoustomButtonAuth(
              title: "Login",
              onPressed: () async {
                final userEmail = email.text.trim();
                final userPass = password.text.trim();

                if (userEmail.isEmpty || userPass.isEmpty) {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    title: "Warning",
                    desc: "Please enter email and password.",
                    btnOkOnPress: () {},
                  ).show();
                  return;
                }

                try {
                  final credential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                        email: userEmail,
                        password: userPass,
                      );

                  Navigator.of(context).pushReplacementNamed("homepage");
                } on FirebaseAuthException catch (e) {
                  print("🔥 زب حمار = ${e.code}");

                  String message = "";

                  if (e.code == 'user-not-found') {
                    message = "No user found with this email.";
                  } else if (e.code == 'wrong-password') {
                    message = "Incorrect password. Please try again.";
                  } else if (e.code == 'invalid-email') {
                    message = "Email format is invalid.";
                  } else if (e.code == 'invalid-credential') {
                    message = "Incorrect email or password.";
                  } else {
                    message =
                        e.message ?? "An error occurred while logging in.";
                  }

                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    title: "Login Failed",
                    desc: message,
                    btnOkOnPress: () {},
                  ).show();
                } on FirebaseException catch (e) {
                  print("🔥 FirebaseException = ${e.message}");

                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    title: "Firebase Error",
                    desc: e.message ?? "Firebase internal error.",
                    btnOkOnPress: () {},
                  ).show();
                } catch (e) {
                  print("🔥 Unknown error = $e");

                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    title: "Error",
                    desc: "Something went wrong. Please try again.",
                    btnOkOnPress: () {},
                  ).show();
                }
              },
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Google Button
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1024px-Google_%22G%22_logo.svg.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 20),

                // Apple Button
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        "https://yt3.googleusercontent.com/s5hlNKKDDQWjFGzYNnh8UeOW2j2w6id-cZGx7GdAA3d5Fu7zEi7ZMXEyslysuQUKigXNxtAB=s900-c-k-c0x00ffffff-no-rj",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
            // Register
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed("signup");
              },
              child: Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "Don't Have Any Account ? "),
                      TextSpan(
                        text: "Register",
                        style: TextStyle(
                          color: Colors.cyan,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
