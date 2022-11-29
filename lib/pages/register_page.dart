// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'package:chat/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../helpers/mostrar_alerta.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
        
                CustomLogo(
                  image: AssetImage('assets/tag-logo.png'),
                  title: 'Register'
                ),
        
                _Form(),
        
                CustomLabels(
                  text1 : '¿Ya tienes una cuenta?', 
                  text2 : 'Acceder con tu cuenta',
                  ruta  : 'login',
                ),
        
                Text('Términos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w200)),
              ],
            ),
          ),
        ),
      )
   );
  }
}



class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {

  final nameCtrl  = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl  = TextEditingController();

  @override
  Widget build(BuildContext context) {

  final authService = Provider.of<AuthService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [

          CustomInput(
            icon: Icons.perm_identity_rounded, 
            placeHolder: 'Nombre', 
            keyboardType: TextInputType.text, 
            textController: nameCtrl, 
            isPassword: false,   
          ),
          
          CustomInput(
            icon: Icons.mail_outline, 
            placeHolder: 'Email', 
            keyboardType: TextInputType.emailAddress, 
            textController: emailCtrl, 
            isPassword: false,   
          ),
          CustomInput(
            icon: Icons.lock_outlined, 
            placeHolder: 'Password', 
            //keyboardType: TextInputType.text, 
            textController: passCtrl, 
            isPassword: true,   
          ),

          // TAREA crear botón
          BotonAzul(
          color: authService.autenticando ? Colors.grey : Colors.blue,
          texto: 'Registrarse', 
          onPressed: authService.autenticando ? null : () async {

              FocusScope.of(context).unfocus();
              final navigator = Navigator.of(context);
              final registerOk = await authService.register(nameCtrl.text.trim(),emailCtrl.text.trim(), passCtrl.text.trim());
              if(registerOk == true){
                //TODO: Conectar a nuestro socket server

                navigator.pushReplacementNamed( 'usuarios');
              
              }else{

                mostrarAlerta( context , 'Registro invalido', registerOk == null ? 'Complete todos los campos correctamente' : registerOk);
              
              }
              passCtrl.text = '';
              
          },)
          
        ],
      ),
    );
  }
}

