import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:chat/models/usuario.dart';


class UsuarioPage extends StatefulWidget {
  const UsuarioPage({super.key});

  @override
  State<UsuarioPage> createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {

   final RefreshController _refreshController = RefreshController(initialRefresh: false);



  final usuarios=[
    Usuario(email: 'juarezivana22@gmail.com', nombre: 'Ivana Juarez', online: true, uid: '1'),
    Usuario(email: 'soii.franco97@hotmail.com', nombre: 'Franco Piola', online: false, uid: '2'),
    Usuario(email: 'ivanatrading@gmail.com', nombre: 'Ivana Trading', online: true, uid: '3'),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: const Text('CryptoGirl', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        leading: IconButton(    
          icon: const Icon(Icons.exit_to_app), color: Colors.black87,
          onPressed: (){},
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Icon(Icons.check_circle, color: Colors.green[400],),
            //child: const Icon(Icons.offline_bolt, color: Colors.red,),         
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
                                backgroundColor: Colors.green[100],
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
                            );
  }

  _cargarUsuarios()async{

    await Future.delayed( const Duration(milliseconds: 1000));
    
    _refreshController.refreshCompleted();

  
  }

}