import 'package:flutter/material.dart';


class CustomLogo extends StatelessWidget {

  final AssetImage image;
  final String title; 

  const CustomLogo({super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(top: 50),//original 50
      child: Column(
        children:  [
          Image(image: image),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontSize: 30),)
        ],
      ),
    );
  }
}