
import 'package:chatapp/commun/models/groupModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:uuid/uuid.dart';

import '../../commun/enumeration/message_type.dart';
import '../../commun/models/lastMessagemodel.dart';
import '../../commun/models/messageModel.dart';
import '../../commun/models/userModel.dart';

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
  }
   Stream<List<UserModel>> getAllUser() {
   return firestore
        .collection('users')
        .where('uid',isNotEqualTo: auth.currentUser!.uid)
        .snapshots()
        .map((event) {
      List<UserModel> users = [];
      for (var user in event.docs) {
        users.add(UserModel.fromMap(user.data()));
      }
      return users;
    });
   }
   Future<List<UserModel>> getAllUsers() {
   return firestore
        .collection('users')
        .where('uid',isNotEqualTo: auth.currentUser!.uid)
        .get()
        .then((event) {
      List<UserModel> users = [];
      for (var user in event.docs) {
        users.add(UserModel.fromMap(user.data()));
      }
      return users;
    });
   }

   Stream<List<dynamic>> getAllAppels(){
   return firestore
        .collection('appel_cours')
        .where('members',arrayContains: auth.currentUser!.uid)
        .where('etat', isEqualTo: 2)
        .snapshots()
        .asyncMap((event) async{
      List<dynamic> appels = [];
      for (var call in event.docs) {
           final userData = await firestore
            .collection('users')
            .doc(call.get('callerId'))
            .get();
            final req={'callId': call.id,'user': UserModel.fromMap(userData.data()!),'roomId': call.get('roomId'),'type':call.get('type') };
         appels.add(req);
      }
      return appels;
    });
   
   }
   Stream<List<dynamic>> getAllAppelsCours() {
   return firestore
        .collection('appel_cours')
        .where('id_receiver',isEqualTo: auth.currentUser!.uid)
        .where('etat', isEqualTo: 0)
        .snapshots()
        .asyncMap((event) async{
      List<dynamic> appels = [];
      for (var call in event.docs) {
           final userData = await firestore
            .collection('users')
            .doc(call.get('callerId'))
            .get();
            final req={'callId': call.id,'user': UserModel.fromMap(userData.data()!),'roomId': call.get('roomId'),'type':call.get('type') };
         appels.add(req);
      }
      return appels;
    });
   }
   //Les contacts

   Stream<List<dynamic>> getAllContacts() {
   return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
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
        contacts.add(user);
      }
      return contacts;
    });
   }


   Stream<List<dynamic>> getAllContactAvatar() {
   return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
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
        contacts.add(user);
      }
      return contacts;
    });
   }
   Stream<List<dynamic>> getAllContactsNoGroup(groupId) {
   return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<dynamic> contacts = [];
      for (var document in event.docs) {
        final lastMessage = LastMessageModel.fromMap(document.data());
        await firestore
              .collection('groups')
              .doc(groupId)
              .get().then((groupe)async{
                final gr=GroupModel.fromMap(groupe.data()!);

                 if(!gr.members.contains(lastMessage.contactId)){
                    
        final userData = await firestore
            .collection('users')
            .doc(lastMessage.contactId)
            .get();
        final user = UserModel.fromMap(userData.data()!);
        contacts.add(user);
                 }
              });
      }
      return contacts;
    });
   }

  Stream<List<MessageModel>> getAllOneToOneMessage(String receiverId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('timeSent',descending: true)
        .snapshots()
        .map((event) {
      List<MessageModel> messages = [];
      for (var message in event.docs) {
        messages.add(MessageModel.fromMap(message.data()));
      }

      return messages;
    });
  }
  
  Stream<List<dynamic>> getAllAppel() {
    return firestore
        .collection('rooms')
        .snapshots()
        .map((event) {
      List<dynamic> messages = [];
      for (var message in event.docs) {
        messages.add({'id':message.id});
      }
      return messages;
    });
  }

  Stream<List<dynamic>> getAllLastMessageList() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
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
        final int nouveau=await nbrVue(user.uid);
        contacts.add(
          {
          'last' : LastMessageModel(
            contactId: lastMessage.contactId,
            timeSent: lastMessage.timeSent,
            lastMessage: lastMessage.lastMessage,
          ),
         'user' : user,
         'nouveau': nouveau
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
      final receiverDataMap =
          await firestore.collection('users').doc(receiverId).get();
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
        receiverUserData: receiverId,
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
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .doc(textMessageId)
        .set(message.toMap());

    // receiver
    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(textMessageId)
        .set(message.toMap());
  }

  void saveAsLastMessage({
    required String senderUserData,
    required String receiverUserData,
    required String lastMessage,
    required DateTime timeSent,
    required String receiverId,
    required MessageType messageType
  }) async {
    final lastMessageConvertsender= (messageType==MessageType.text) ? lastMessage : messageForReceiverType(messageType);
    final receiverLastMessage = LastMessageModel(
      contactId: senderUserData,
      timeSent: timeSent,
      lastMessage: lastMessageConvertsender,
    );

    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(receiverLastMessage.toMap());
 final lastMessageConvertrecever= (messageType==MessageType.text) ? lastMessage : messageForType(messageType);
   
    final senderLastMessage = LastMessageModel(
      contactId: receiverUserData,
      timeSent: timeSent,
      lastMessage: lastMessageConvertrecever,
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .set(senderLastMessage.toMap());
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
        messageType: MessageType.image,
      );

      saveAsLastMessage(
        senderUserData: senderId,
        receiverUserData: receiverId,
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
        receiverUserData: receiverId,
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
      return "Vous avez envoyé une image";
    }
    else if(msgt==MessageType.audio){
     return "Vous avez envoyé un audio";
    }
    else if(msgt==MessageType.video){
      return "Vous avez envoyé une video";
    }
    return "Vous avez envoyé un fichier";
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

  void marqueVue(String receiverId)async{
         
    // sender
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .where('isSeen',isEqualTo: false)
        .where('senderId',isEqualTo: receiverId)
        .get()
        .then((messages) async{
            for(var message in messages.docs)
            {
           firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .doc(message.id)
        .update({
          "isSeen":true
        });

            }
        });
    // receiver
    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .where('isSeen',isEqualTo: false)
        .where('senderId',isEqualTo: receiverId)
        .get()
        
        .then((messages) async{
            for(var message in messages.docs)
            {
           firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(message.id)
        .update({
          "isSeen":true
        });

            }
        });
  }
  Future<int> nbrVue(String receiverId)async{
    // sender
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .where('isSeen',isEqualTo: false)
        .get()
        .then((value){
            return value.size;
        });


    return 0;
  }
}
