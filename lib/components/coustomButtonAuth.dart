import 'package:flutter/material.dart';

class CoustomButtonAuth extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  const CoustomButtonAuth({super.key, this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        height: 40,
        minWidth: 150,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: const Color.fromARGB(255, 0, 10, 99),
        textColor: Colors.white,
        onPressed: onPressed,
        child: Text(title, style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class CoustomButtonUpload extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final bool isSelected;
  const CoustomButtonUpload({super.key, this.onPressed, required this.title, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        height: 35,
        minWidth: 200,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: isSelected ? const Color.fromARGB(255, 0, 10, 99) : Colors.lightBlue,
        textColor: Colors.white,
        onPressed: onPressed,
        child: Text(title, style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
