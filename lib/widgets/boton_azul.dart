import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {

  final String texto;
  final void Function()? onPressed;

  const BotonAzul({super.key, required this.texto, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
            style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            overlayColor: MaterialStateProperty.all(Colors.transparent), 
            ),
            onPressed: onPressed, 
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 55,
              decoration: const ShapeDecoration(
              color: Colors.blue,
              shape: StadiumBorder()),
              child: Text(texto, style: const TextStyle(color: Colors.white, fontSize: 17),),
            )
          );
  }
}