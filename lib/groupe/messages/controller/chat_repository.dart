
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:uuid/uuid.dart';

import '../../../commun/enumeration/message_type.dart';
import '../../../commun/models/lastMessagemodel.dart';
import '../../../commun/models/messageModel.dart';
import '../../../commun/models/userModel.dart';

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
   FirebaseStorage _storage= FirebaseStorage.instance;
   
  ChatRepository({required this.firestore, required this.auth});
 

  Future<String> uploadFile(file) async{
    Reference reference=_storage.ref().child('imageMessage/${DateTime.now()}.png');
 UploadTask uploadTask= reference.putFile(file);
 TaskSnapshot taskSnapshot=await uploadTask;
 return await taskSnapshot.ref.getDownloadURL();
  }//Les contacts

   


  Stream<List<dynamic>> getAllOneToOneMessage(String groupId) {
    return firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('timeSent',descending: true)
        .snapshots()
        .asyncMap((event) async{
      List<dynamic> messages = [];
      for (var message in event.docs) {
   final  SenderData = await firestore
            .collection('users')
            .doc(message.get('senderId'))
            .get();
        messages.add({
         'message': MessageModel.fromMap(message.data()),
        'sender':  UserModel.fromMap(SenderData.data()!)
        });
      }
      return messages;
    });
  }
  

  Stream<List<dynamic>> getAllLastMessageList() {
    return firestore
        .collection('groups')
        .orderBy('timeSent',descending: true)
        .snapshots()
        .asyncMap((event) async {
      List<dynamic> contacts = [];
      for (var document in event.docs) {
        final lastMessage = LastMessageModel.fromMap(document.data());
        final userData = await firestore
            .collection('users')
            .doc(lastMessage.contactId)
            .get();
        final user = UserModel.fromMap(userData.data()!);
        contacts.add(
          {
          'last' : LastMessageModel(
            contactId: lastMessage.contactId,
            timeSent: lastMessage.timeSent,
            lastMessage: lastMessage.lastMessage,
          ),
         'user' : user
          }
        );
      }
      return contacts;
    });
  }

  void sendTextMessage({
    required BuildContext context,
    required String textMessage,
    required String receiverId,
    required String senderId,
  }) async {
    try {
      final timeSent = DateTime.now();
     //  final receiverData = UserModel.fromMap(receiverDataMap.data()!);
      final textMessageId = const Uuid().v1();

      saveToMessageCollection(
        receiverId: receiverId,
        textMessage: textMessage,
        timeSent: timeSent,
        textMessageId: textMessageId,
        messageType: MessageType.text,
      );

      saveAsLastMessage(
        senderUserData: senderId,
        groupId: receiverId,
        lastMessage: textMessage,
        timeSent: timeSent,
        receiverId: receiverId,
        messageType: MessageType.text,
      );
    } catch (e) {
     // showAlertDialog(context: context, message: e.toString());
    }
  }

  void saveToMessageCollection({
    required String receiverId,
    required String textMessage,
    required DateTime timeSent,
    required String textMessageId,
    String? urlImage ,
    String? filename,
   // required String senderUsername,
   // required String receiverUsername,
    required MessageType messageType,
  }) async {
    var message ;
    if(messageType==MessageType.text){
    message=MessageModel(
      senderId: auth.currentUser!.uid,
      receiverId: receiverId,
      textMessage: textMessage,
      type: MessageType.text,
      timeSent: timeSent,
      messageId: textMessageId,
      isSeen: false,
      urlImage: urlImage,
      filename: filename
    );

    }else {
       
    message=MessageModel(
      senderId: auth.currentUser!.uid,
      receiverId: receiverId,
      textMessage: textMessage,
      type: messageType,
      timeSent: timeSent,
      messageId: textMessageId,
      isSeen: false,
      urlImage: urlImage,
      filename: filename
    );
       
    }
     
    // sender
    await firestore
        .collection('groups')
        .doc(receiverId)
        .collection('messages')
        .doc(textMessageId)
        .set(message.toMap());
  }

  void saveAsLastMessage({
    required String senderUserData,
    required String groupId,
    required String lastMessage,
    required DateTime timeSent,
    required String receiverId,
    required MessageType messageType
  }) async {
    final lastMessageConvertsender= (messageType==MessageType.text) ? lastMessage : messageForType(messageType);
    final lastGroup={
       'recentMessage': lastMessageConvertsender,
         'recentMessageSender' : senderUserData,
         'timeSent': timeSent
    };
    await firestore
        .collection('groups')
        .doc(receiverId)
        .set(lastGroup,SetOptions(merge: true));
  }

  


  //Envoie d'image

  void sendImageMessage({
    required BuildContext context,
    required String textMessage,
     required String urlImage,
    required String receiverId,
    required String senderId,
  }) async {
    try {
      final timeSent = DateTime.now();
     final textMessageId = const Uuid().v1();


      saveToMessageCollection(
        receiverId: receiverId,
        textMessage: textMessage,
        urlImage: urlImage,
        timeSent: timeSent,
        textMessageId: textMessageId,
        messageType: MessageType.image,
      );

      saveAsLastMessage(
        senderUserData: senderId,
        groupId: receiverId,
        lastMessage: textMessage,
        timeSent: timeSent,
        receiverId: receiverId,
        messageType: MessageType.image,
      );
    } catch (e) {
     // showAlertDialog(context: context, message: e.toString());
    }
  }
  
  void sendFileMessage({
    required BuildContext context,
    required String textMessage,
     required String urlImage,
    required String receiverId,
    required String senderId,
    required MessageType messageType,
    required String filename
  }) async {
    try {
      final timeSent = DateTime.now();
      final receiverDataMap =
          await firestore.collection('users').doc(receiverId).get();
    //  final receiverData = UserModel.fromMap(receiverDataMap.data()!);
      final textMessageId = const Uuid().v1();


      saveToMessageCollection(
        receiverId: receiverId,
        textMessage: textMessage,
        urlImage: urlImage,
        timeSent: timeSent,
        textMessageId: textMessageId,
        messageType: messageType,
        filename: filename
      );

      saveAsLastMessage(
        senderUserData: senderId,
        groupId: receiverId,
        lastMessage: textMessage,
        timeSent: timeSent,
        receiverId: receiverId,
        messageType: messageType,
      );
    } catch (e) {
     // showAlertDialog(context: context, message: e.toString());
    }
  }
  
  String messageForType(MessageType msgt){
    if(msgt==MessageType.image){
      return "A envoyé une image";
    }
    else if(msgt==MessageType.audio){
     return "A envoyé un audio";
    }
    else if(msgt==MessageType.video){
      return "A envoyé une video";
    }
    return "A envoyé un fichier";
  }

  String messageForReceiverType(MessageType msgt){
    if(msgt==MessageType.image){
      return "Vous a  envoyé une image";
    }
    else if(msgt==MessageType.audio){
     return "Vous a  envoyé un audio";
    }
    else if(msgt==MessageType.video){
      return "Vous a  envoyé une video";
    }
    return "Vous a  envoyé un fichier";
  }
}
