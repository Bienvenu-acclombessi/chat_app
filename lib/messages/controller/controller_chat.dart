import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../commun/enumeration/message_type.dart';
import '../../commun/models/lastMessagemodel.dart';
import '../../commun/models/messageModel.dart';
import '../../commun/models/userModel.dart';
import 'chat_repository.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
 FirebaseStorage _storage= FirebaseStorage.instance;
 
  ChatController({required this.chatRepository, required this.ref});
   
 
  Future<String> uploadFile(file) async{
    Reference reference=_storage.ref().child('imageMessage/${DateTime.now()}.png');
 UploadTask uploadTask= reference.putFile(file);
 TaskSnapshot taskSnapshot=await uploadTask;
 return await taskSnapshot.ref.getDownloadURL();
  }
  Future<String> uploadAudioFile(file) async{
    Reference reference=_storage.ref().child('AudioMessage/${DateTime.now()}.m4a');
 UploadTask uploadTask= reference.putFile(file);
 TaskSnapshot taskSnapshot=await uploadTask;
 return await taskSnapshot.ref.getDownloadURL();
  }
  Stream<List<MessageModel>> getAllOneToOneMessage(String receiverId) {
    return chatRepository.getAllOneToOneMessage(receiverId);
  }
  Stream<List<dynamic>> getAllAppel() {
    return chatRepository.getAllAppel();
  }
  Stream<List<dynamic>> getAllAppels() {
    return chatRepository.getAllAppels();
  }
  Stream<List<dynamic>> getAllAppelsCours() {
    return chatRepository.getAllAppelsCours();
  }
  Stream<List<dynamic>> getAllContacts() {
    return chatRepository.getAllContacts();
  }
  
  Stream<List<dynamic>> getAllContactsNoGroup(groupId) {
    return chatRepository.getAllContactsNoGroup(groupId);
  }
  
  Stream<List<UserModel>> getAllUser() {
    return chatRepository.getAllUser();
  }
  Future<List<UserModel>> getAllUsers() {
    return chatRepository.getAllUsers();
  }
  Stream<List<dynamic>> getAllLastMessageList() {
    return chatRepository.getAllLastMessageList();
  }
Future<UserModel?> getCurrentUserInfo() async {
    UserModel? user;
    final userInfo =
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get();

    if (userInfo.data() == null) return user;
    user = UserModel.fromMap(userInfo.data()!);
    return user;
  }
  void sendTextMessage({
    required BuildContext context,
    required String textMessage,
    required String receiverId,
  }) {
    getCurrentUserInfo().then(
          (value) => chatRepository.sendTextMessage(
            context: context,
            textMessage: textMessage,
            receiverId: receiverId,
            senderId: value!.uid,
          ),
        );
  }
  void sendImageMessage({
    required BuildContext context,
    required String textMessage,
    required String receiverId,
    required String urlImage
  }) {
    getCurrentUserInfo().then(
          (value) => chatRepository.sendImageMessage(
            context: context,
            textMessage: textMessage,
            receiverId: receiverId,
            senderId: value!.uid,
            urlImage: urlImage
          ),
        );
  }
  
  void sendAudioMessage({
    required BuildContext context,
    required String textMessage,
    required String receiverId,
    required String urlImage
  }) {
    getCurrentUserInfo().then(
          (value) => chatRepository.sendFileMessage(
            context: context,
            textMessage: textMessage,
            receiverId: receiverId,
            senderId: value!.uid,
            urlImage: urlImage,
            messageType: MessageType.audio,
            filename: 'audio'
          ),
        );
  }

  
  void sendOtherMessage({
    required BuildContext context,
    required String textMessage,
    required String receiverId,
    required String urlImage,
    required String filename
  }) {
    getCurrentUserInfo().then(
          (value) => chatRepository.sendFileMessage(
            context: context,
            textMessage: textMessage,
            receiverId: receiverId,
            senderId: value!.uid,
            urlImage: urlImage,
            messageType: MessageType.other,
            filename: filename
          ),
        );
  }
}
