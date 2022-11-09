import 'package:flutter/material.dart';

class CustomLabels extends StatelessWidget {

  final String text1;
  final String text2;
  final String ruta;


  const CustomLabels({super.key, required this.text1, required this.text2, required this.ruta});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text1, style: const TextStyle(fontWeight: FontWeight.w300, color: Colors.black54, fontSize: 15)),
        const SizedBox(height: 10),
        GestureDetector(
        onTap: () => Navigator.pushReplacementNamed(context, ruta),
        child: Text(text2, style: TextStyle(color: Colors.blue[600], fontWeight: FontWeight.bold, fontSize: 18),))
      ],
    );
  }
}