// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import 'package:chat/models/models.dart';

import 'package:chat/global/environment.dart';

class AuthService with ChangeNotifier{

  late Usuario usuario;
  bool _autenticando = false;

  // Create storage
  final _storage = const FlutterSecureStorage();

  bool get autenticando => _autenticando;
  set autenticando (bool valor){
    _autenticando = valor;
    notifyListeners();
  }

  //Getters del token de forma estática
  static Future<String?> getToken() async{

    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    
    return token;
  
  }

  static Future<void> deleteToken() async{

    const storage = FlutterSecureStorage();
    storage.delete(key: 'token');
  
  }


  Future<bool> login(String email, String password) async {

    autenticando = true;

    final data = {
      "email":email,
      "password": password
    };

    final uri = Uri.parse('${Environment.apiUrl}/login');
    final resp = await http.post(uri,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );
    
     print(resp.body);
    autenticando = false;
    
    if(resp.statusCode == 200){
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      //guardar el token
      await _guardarToken(loginResponse.token);

      return true;
    }else{
    
      return false;
    }


  }

  Future register(String nombre, String email, String password) async {

    autenticando = true;

    final data = {
      "nombre": nombre,
      "email": email,
      "password": password
    };

    final uri = Uri.parse('${Environment.apiUrl}/login/new');
    final resp = await http.post(uri,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );
    
     //print(resp.body);
    autenticando = false;
    
    if(resp.statusCode == 200){
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      //guardar el token
      await _guardarToken(loginResponse.token);

      return true;
    }else{
    
      final respBody = jsonDecode(resp.body);
      print(respBody['msg']); 
      return respBody['msg'];

    }


  }

  Future<bool> isLoggedIn()async{
  
    final token = await _storage.read(key: 'token');

    final uri = Uri.parse('${Environment.apiUrl}/login/renew');
    final resp = await http.get(uri,
      headers: {
      'Content-Type': 'application/json', 
      'x-token': token.toString()
      }
    );
    
     print(resp.body);
    
    if(resp.statusCode == 200){
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      //guardar el token
      await _guardarToken(loginResponse.token);

      return true;
    }else{
    
      logout();
      return false;
    }

  
  
  }


  Future _guardarToken(String token) async {
    // Write value
    return await _storage.write(key: 'token', value: token);
  }

  Future logout()async{
    // Delete value
    return await _storage.delete(key: 'token');
  
  }

}