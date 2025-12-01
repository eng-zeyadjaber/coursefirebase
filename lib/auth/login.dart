import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasecourse/components/coustomButtonAuth.dart';
import 'package:firebasecourse/components/coustomLogoAuth.dart';
import 'package:firebasecourse/components/textFormField.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoding = false;

  // google short sign in
  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushNamedAndRemoveUntil("homepage", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoding
          ? Center(child: CircularProgressIndicator(color: Colors.lightBlue))
          : Container(
              padding: EdgeInsets.all(20),
              child: ListView(
                children: [
                  SizedBox(height: 50),
                  Coustomlogoauth(),
                  SizedBox(height: 20),

                  // Login Title
                  Form(
                    key: formState,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        CustomeTextForm(
                          hintText: "Enter Your Email",
                          mycontroller: email,
                          validator: (val) {
                            if (val == "") {
                              return "Empty text";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),

                        // Password
                        Text(
                          "Password",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        CustomeTextForm(
                          hintText: "Enter Your Password",
                          mycontroller: password,
                          validator: (val) {
                            if (val == "") {
                              return "Empty text";
                            }
                            return null;
                          },
                        ),
                        InkWell(
                          onTap: () async {
                            if (email.text == "") {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                title: "email",
                                desc: "input your email.",
                                btnOkOnPress: () {},
                              ).show();
                              return;
                            }
                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email.text);
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                title: "PasswordReset",
                                desc: "go to gmail for PasswordReset.",
                                btnOkOnPress: () {},
                              ).show();
                            } catch (e) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                title: "email warning",
                                desc: "input access email.",
                                btnOkOnPress: () {},
                              ).show();
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 20, bottom: 20),
                            alignment: Alignment.topRight,
                            child: Text(
                              "forget password ?",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),

                        // Login Button
                        CoustomButtonAuth(
                          title: "Login",
                          onPressed: () async {
                            // validate form
                            if (!formState.currentState!.validate()) {
                              print("Form not valid");
                              return;
                            }

                            setState(() {
                              isLoding = true;
                            });

                            try {
                              // استخدم trim() لتجنب مسافات زائدة
                              final userCredential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                    email: email.text.trim(),
                                    password: password.text,
                                  );

                              // تحقق من التحقق من البريد
                              if (userCredential.user != null &&
                                  userCredential.user!.emailVerified) {
                                // النجاح: انتقل للصفحة الرئيسية
                                if (!mounted) return;
                                Navigator.of(
                                  context,
                                ).pushReplacementNamed("homepage");
                              } else {
                                // أوقف اللودينغ قبل عرض الحوار
                                setState(() {
                                  isLoding = false;
                                });

                                // أرسل رسالة التحقق إن لم تكن مُرسلة
                                try {
                                  await FirebaseAuth.instance.currentUser
                                      ?.sendEmailVerification();
                                } catch (_) {}

                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.warning,
                                  title: "Email not verified",
                                  desc:
                                      "Please check your email to verify your account.",
                                  btnOkOnPress: () {},
                                ).show();
                              }
                            } on FirebaseAuthException catch (e) {
                              // أوقف اللودينغ فور وقوع الخطأ
                              setState(() {
                                isLoding = false;
                              });

                              // اطبع الكود لتتمكن من معرفة نوع الخطأ أثناء التطوير
                              print("FirebaseAuthException code: ${e.code}");

                              String title = "Authentication error";
                              String desc =
                                  "An error occurred. Please try again.";

                              if (e.code == 'user-not-found') {
                                title = "Email not found";
                                desc =
                                    "No user found with that email. Please register first.";
                              } else if (e.code == 'wrong-password') {
                                title = "Wrong password";
                                desc = "The password you entered is incorrect.";
                              } else if (e.code == 'invalid-email') {
                                title = "Invalid email";
                                desc = "Please enter a valid email address.";
                              } else {
                                // رسالة عامة تُظهر الكود لمساعدتك أثناء التطوير
                                desc = "${e.message} (code: ${e.code})";
                              }

                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                title: title,
                                desc: desc,
                                btnOkOnPress: () {},
                              ).show();
                            } catch (e) {
                              // أي استثناء آخر غير متوقع — أوقف اللودينغ وعرّض حوارًا عاماً
                              setState(() {
                                isLoding = false;
                              });
                              print("Unhandled exception: $e");

                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                title: "Error",
                                desc:
                                    "An unexpected error occurred. Please try again.",
                                btnOkOnPress: () {},
                              ).show();
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google Button
                      InkWell(
                        onTap: () {
                          signInWithGoogle();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 80,
                          height: 80,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(70),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(70),
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
                          alignment: Alignment.center,
                          width: 80,
                          height: 80,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(70),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: Image.network(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9hXn-P60-OkWc_keJl5LAElTIUy6H52Xoew&s",
                              fit: BoxFit.contain,
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
