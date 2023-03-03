import 'package:chatapp/appel/pages/CallAccept/accept_call_page.dart';
import 'package:chatapp/commun/models/groupModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commun/models/userModel.dart';

final chatAppelProvider = Provider((ref) {
  return ChatAppel(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});
class ChatAppel {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
   FirebaseStorage _storage= FirebaseStorage.instance;
   
  ChatAppel({required this.firestore, required this.auth});

 Future<String> addCall(String id_room,String id_receiver,String type)async{
    var id;
 await firestore.collection('appel_cours')
                .add({
                  'roomId': id_room,
                  'id_receiver': id_receiver,
                  'callerId': auth.currentUser!.uid,
                  'etat': 0,
                  'type': type,
                  'members': [id_receiver,auth.currentUser!.uid],
                }).then((value) {
                   id=value.id;
                });
  return id;
  }
  
 void getNewCall(BuildContext context) async{
    firestore
        .collection('appel_cours')
        .where('id_receiver',isEqualTo: auth.currentUser!.uid)
        .where('etat', isEqualTo: 0)
        .snapshots()
        .asyncMap((event) async{
      for (var call in event.docs) {
           final userData = await firestore
            .collection('users')
            .doc(call.get('callerId'))
            .get();
            final req={'callId': call.id,'user': UserModel.fromMap(userData.data()!),'roomId': call.get('roomId'),'type':call.get('roomId') };
       
       Navigator.push(context,MaterialPageRoute(builder: (context)=>AcceptCallScreen(
                  callId: call.id,
                  roomId: call.get('roomId'),
                  user: UserModel.fromMap(userData.data()!),
                  type: call.get('type'))));
      }
      return ;
    });
   }
      
}
