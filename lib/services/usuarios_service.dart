import 'package:http/http.dart' as http;

import 'package:chat/models/models.dart';

import 'package:chat/services/services.dart';

import 'package:chat/global/environment.dart';


class UsuariosService{

  final uri = Uri.parse('${Environment.apiUrl}/usuarios');
  Future<List<Usuario>> getUsuarios() async {

    try {
      

    final resp = await http.get(uri,
      headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      }
    );

    final usuariosResponse = usuariosResponseFromJson(resp.body);
    return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  
  }



}