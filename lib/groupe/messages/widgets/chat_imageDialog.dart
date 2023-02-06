
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/controller_chat.dart';


class ChatImageDialog {
  User? user;
  WidgetRef ref;
  String groupId;
  String othermessage;
  ChatImageDialog({this.user,required this.ref,required this.groupId, required this.othermessage});

  //Pour visualiser la boite des dialogues

  void showImageMessageDialog(BuildContext context,ImageSource source)async {
    XFile? _pickedfile = await ImagePicker().pickImage(source: source);
    if(_pickedfile!=null){
File _file=File(_pickedfile.path);
  final _keyForm= GlobalKey<FormState>();
  final messageController= new TextEditingController();
  messageController.text=othermessage;
  
  String _formError ='Veuillez remplir ce champs';
  showDialog(context: context, builder:  (BuildContext context){
return SimpleDialog(
  contentPadding: EdgeInsets.zero,
  children: [
    Container(
      height: MediaQuery.of(context).size.height*0.25,
      margin: const EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: Colors.grey,
        image: DecorationImage(image: FileImage(_file) ,fit:  BoxFit.cover),
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Form(
            key: _keyForm,
            child: TextFormField(
              maxLength: 20,
              controller: messageController,
              decoration: const InputDecoration(
                hintText: 'Votre message',
                border: OutlineInputBorder(),
              ),
            )),
            Wrap(
              children: [
                TextButton(onPressed: ()=>Navigator.of(context).pop(),child: const Text('ANNULLER') ),
                ElevatedButton(onPressed: ()=>onSubmit(context,_keyForm,_file,groupId,messageController), child: const Text('Publier') )
              ],
            )
        ],
      ),
    )
  ],
);
  } );
    }else{
Navigator.of(context).pop();
    }
  
  }
  void onSubmit(context,keyForm,file,groupId,messageController)async{
    
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Row(children: [
      const Expanded(child: Text('Envoie en cours')),
      const CircularProgressIndicator(color: Colors.white,)
    ],)),
  );
      
      String _carUrlImg = await ref.read(chatControllerProvider).uploadFile(file);
      ref.read(chatControllerProvider).sendImageMessage(
            context: context,
            textMessage: messageController.text,
            receiverId: groupId,
            urlImage: _carUrlImg
          );
    }
  
}
