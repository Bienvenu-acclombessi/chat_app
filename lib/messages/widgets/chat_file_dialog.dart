
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/controller_chat.dart';


class ChatFileDialog {
  WidgetRef ref;
  String friendUid;
  String othermessage;
  ChatFileDialog({required this.ref,required this.friendUid, required this.othermessage});

  //Pour visualiser la boite des dialogues

  void showFileMessageDialog(BuildContext context)async {

    // XFile? _pickedfile = await ImagePicker().pickImage(source: source);
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File? _file;
    String? filename;
if (result != null) {
 _file = File(result.files.single.path!);
 filename = result.files.single.name;
 
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
      child:  Text('$filename'),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: Colors.grey,
       ),
    ),
   
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
         
            Wrap(
              children: [
                TextButton(onPressed: ()=>Navigator.of(context).pop(),child: const Text('ANNULLER') ),
                ElevatedButton(onPressed: ()=>onSubmit(context,_keyForm,_file,friendUid,messageController,filename), child: const Text('Envoyer') )
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
  void onSubmit(context,keyForm,file,friendUid,messageController,filename)async{
    
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Row(children: [
      const Expanded(child: Text('Envoie en cours')),
      const CircularProgressIndicator(color: Colors.white,)
    ],)),
  );
      
      String _carUrlImg = await ref.read(chatControllerProvider).uploadFile(file);
      ref.read(chatControllerProvider).sendOtherMessage(
            context: context,
            textMessage: messageController.text,
            receiverId: friendUid,
            urlImage: _carUrlImg,
            filename: filename
          );
    }
  
}


