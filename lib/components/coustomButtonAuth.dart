import 'package:flutter/material.dart';

class CoustomButtonAuth extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  const CoustomButtonAuth({super.key, this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 40,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(20),
      ),
      color: const Color.fromARGB(255, 0, 10, 99),
      textColor: Colors.white,
      onPressed: onPressed,
      child: Text(title),
    );
  }
}
