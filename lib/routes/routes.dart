import 'package:chat/pages/pages.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> appRoutes ={

  'loading'  : (_)=> const LoadingPage(),
  'register' : (_)=> const RegisterPage(),
  'login'    : (_)=> const LoginPage(),
  'usuario'  : (_)=> const UsuarioPage(),
  'chat'     : (_)=> const ChatPage(),

};