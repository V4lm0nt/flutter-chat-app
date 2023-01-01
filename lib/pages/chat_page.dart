// ignore_for_file: avoid_print

import 'dart:io';

import 'package:chat/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat/models/mensajes_response.dart';
import 'package:chat/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

  final _textContoller = TextEditingController();

  final _focusNode = FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  final List<ChatMessage> _messages=[];

  bool _estaEscribiendo = false;


  @override
  void initState() {
    super.initState();
    chatService   = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService   = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial( chatService.usuarioPara.uid );


  }

  void _cargarHistorial(String usuarioID)async{
  
    List<Mensaje> chat = await chatService.getChat(usuarioID);
    //print(chat);
    final history = chat.map((m) => ChatMessage(
      texto: m.mensaje, 
      uid: m.de, 
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 0))..forward()
    ));
    //print(history);
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic payload){
  

    ChatMessage message = ChatMessage(
      texto: payload['mensaje'], 
      uid: payload['de'], 
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 300))
    );
    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }



  @override
  Widget build(BuildContext context) {

  final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 1,
        centerTitle: true,
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              maxRadius: 14,
              child: Text(usuarioPara.nombre.substring(0,2), style: const TextStyle(fontSize: 12),),
            ),
            const SizedBox(height: 3,),
            Text(usuarioPara.nombre, style: const TextStyle(color: Colors.black87, fontSize: 12))
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(0),
        child: Column(
          children: [
            
            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, i)=> _messages[i],
                reverse: true,
              )
            ),
            const Divider(height: 1,),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )

          ],
        ),
      ),
    );
  }

  Widget _inputChat(){

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(

                controller: _textContoller,

                onSubmitted: _handleSubmit,

                onChanged: (String text){
                  
                   setState(() {
                     if(text.trim().isNotEmpty){
                      _estaEscribiendo = true;
                   }else{

                    _estaEscribiendo=false;
                   }  
                   });

                },

                decoration: const InputDecoration.collapsed(
                  hintText: 'Enviar mensaje'
                ),
                
                focusNode: _focusNode,

              )
            ),
            Container(
              child: Platform.isIOS
                    ? CupertinoButton(
                        onPressed: _estaEscribiendo
                                      ? () => _handleSubmit(_textContoller.text.trim())
                                      : null, 
                        child: const Text('Enviar'), 
                      )
                    : Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: IconTheme(
                          data: IconThemeData(
                            color: Colors.blue[400]  
                          ),
                          child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onPressed: _estaEscribiendo
                                      ? () => _handleSubmit(_textContoller.text.trim())
                                      : null, 
                            icon: const Icon(Icons.send)
                          )
                        ),
                      )  
            ),

          ],
        ),
      )
    );

  }


  _handleSubmit(String texto){
    if(texto.isEmpty) return;
    _textContoller.clear();
    _focusNode.requestFocus();
    final newMessage = ChatMessage(
      uid: authService.usuario.uid,
      texto: texto, 
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() { _estaEscribiendo=false; });

    socketService.emit('mensaje-personal', {
      'de'     : authService.usuario.uid,
      'para'   : chatService.usuarioPara.uid,
      'mensaje': texto
    });

  }


  @override
  void dispose() {

    for(ChatMessage message in _messages){
    
      message.animationController.dispose();

    }
    socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}