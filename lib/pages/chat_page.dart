// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat/widgets/widgets.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

  final _textContoller = TextEditingController();

  final _focusNode = FocusNode();

  final List<ChatMessage> _messages=[];

  bool _estaEscribiendo = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
              child: const Text('Te', style: TextStyle(fontSize: 12),),
            ),
            const SizedBox(height: 3,),
            const Text('Ivana Trading', style: TextStyle(color: Colors.black87, fontSize: 12))
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
                  //TODO: cuando hay un valor para poder enviar el mensaje
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
    print(texto);
    _textContoller.clear();
    _focusNode.requestFocus();
    final newMessage = ChatMessage(
      uid: '123',
      texto: texto, 
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _estaEscribiendo=false;
    });

  }


  @override
  void dispose() {
    // TODO: off del socket

    for(ChatMessage message in _messages){
    
      message.animationController.dispose();

    }

    super.dispose();
  }
}