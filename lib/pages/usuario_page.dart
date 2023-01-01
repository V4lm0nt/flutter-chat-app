
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat/models/usuario.dart';

import 'package:chat/services/services.dart';


class UsuarioPage extends StatefulWidget {
  const UsuarioPage({super.key});

  @override
  State<UsuarioPage> createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {

    final usuarioService = UsuariosService();
    final RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<Usuario> usuarios = [];

  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }
  //lista de usuarios hardcodeada
  //final usuarios=[
  //  Usuario(email: 'test1@test.com', nombre: 'Ivana Juarez', online: true, uid: '1'),
  //  Usuario(email: 'test2@test.com', nombre: 'Nombre Apellido', online: false, uid: '2'),
  //  Usuario(email: 'test3@test.com', nombre: 'Nombre Apellido', online: true, uid: '3'),
  //];


  @override
  Widget build(BuildContext context) {

  final authService = Provider.of<AuthService>(context).usuario;
  final socketService = Provider.of<SocketService>(context);

    return Scaffold(
    
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text(authService.nombre, style: const TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        leading: IconButton(    
          icon: const Icon(Icons.exit_to_app), color: Colors.black87,
          onPressed: (){
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child:  socketService.socket.connected
                    ? const Icon(Icons.check_circle, color: Colors.blue) 
                    : const Icon(Icons.offline_bolt, color: Colors.red) 
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: const WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue,),
          waterDropColor: Colors.blue,
        ),
        child: _usuariosListView(),
      )
   );
  }

  ListView _usuariosListView() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, i) => _usuarioListTile(usuarios[i]), 
      separatorBuilder: (_, i) => const Divider(thickness: 1), 
      itemCount: usuarios.length
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
                              title: Text(usuario.nombre),
                              subtitle: Text(usuario.email),
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue[100],
                                foregroundColor: Colors.white,
                                child: Text(usuario.nombre.substring(0,2)),
                              ),
                              trailing: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: usuario.online ? Colors.green[400] : Colors.red,
                                    borderRadius: BorderRadius.circular(100)
                                  ),
                                ),
                              onTap: (){
                                final chatService = Provider.of<ChatService>(context, listen: false);
                                chatService.usuarioPara = usuario;

                                Navigator.pushNamed(context, 'chat');


                              },
                            );
  }

  _cargarUsuarios()async{
    

    usuarios = await usuarioService.getUsuarios();
    setState(() {});
    //await Future.delayed( const Duration(milliseconds: 1000));
    
    _refreshController.refreshCompleted();

  
  }

}