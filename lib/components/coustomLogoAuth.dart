import 'package:flutter/material.dart';

class Coustomlogoauth extends StatelessWidget {
  const Coustomlogoauth({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
            "https://i.pinimg.com/736x/31/5a/63/315a6337729ca3ab4e890a46f7daa677.jpg",
            height: 70,
            width: 70,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
