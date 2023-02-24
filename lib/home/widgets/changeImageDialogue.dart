
import 'dart:io';

import 'package:chatapp/auth/auth_repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';



class ChangeImageDialogue {
  User? user;
  WidgetRef ref;
 ChangeImageDialogue({this.user,required this.ref});

  //Pour visualiser la boite des dialogues

  void showImageMessageDialog(BuildContext context,ImageSource source)async {
    XFile? _pickedfile = await ImagePicker().pickImage(source: source);
    if(_pickedfile!=null){
File _file=File(_pickedfile.path);
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
          
            Wrap(
              children: [
                TextButton(onPressed: ()=>Navigator.of(context).pop(),child: const Text('ANNULLER') ),
                ElevatedButton(onPressed: ()=>onSubmit(context,_file), child: const Text('Publier') )
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
  void onSubmit(context,file)async{
    
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Row(children: [
      const Expanded(child: Text('Modification en cours')),
      const CircularProgressIndicator(color: Colors.white,)
    ],)),
  );
      
      String _carUrlImg = await ref.read(authProvider).uploadFile(file);
      ref.read(authProvider).updatePhotoProfile(uid: user!.uid,link: _carUrlImg);
    }
  
}
