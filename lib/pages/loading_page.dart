
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:chat/pages/pages.dart';

import 'package:chat/services/services.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return const Center(
          child: Text('Espere...'),
           );
        },
        
      ),
   );
  }

  Future checkLoginState(BuildContext context)async{

    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);
    final navigator = Navigator.of(context);
    final autenticado = await authService.isLoggedIn();
    
    if (autenticado){
      socketService.connect();
      navigator.pushReplacement(
        PageRouteBuilder(
        pageBuilder: (_,__,___)=> const UsuarioPage(),
        transitionDuration: const Duration(milliseconds: 0)
        )
      );
    
    }else{
      navigator.pushReplacement( 
        PageRouteBuilder(
        pageBuilder: (_,__,___)=> const LoginPage(),
        transitionDuration: const Duration(milliseconds: 0)
        )
      );
    
    }
  
  }
}