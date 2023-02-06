import 'dart:io';

import 'package:chatapp/commun/models/groupModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:path_provider/path_provider.dart';

import '../../../commun/enumeration/message_type.dart';
import '../../../commun/models/userModel.dart';
import '../controller/controller_chat.dart';

import 'package:just_audio/just_audio.dart';

import '../widgets/j_audio_widget.dart';
import '../widgets/widget_envoie.dart';

final isMessageIconEnabledp = Provider.family((ref, etat) => etat);

class ChatDetail extends ConsumerStatefulWidget {
  final GroupModel group;
  const ChatDetail(
      {super.key,  required this.group});
  @override
  ConsumerState<ChatDetail> createState() =>
      _ChatDetailState(group);
}

class _ChatDetailState extends ConsumerState<ChatDetail> {
  final GroupModel group;
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  //Audio variable
  late Response response;
  var dio = Dio();
  final AudioPlayer _justAudioPlayer = AudioPlayer();
  late Directory _downloadsDirectory;

  /// Some Integer Value Initialized
  late double _currAudioPlayingTime;
  int _lastAudioPlayingIndex = 0;

  double _audioPlayingSpeed = 1.0;
  int index = 0;

  /// Audio Playing Time Related
  String _totalDuration = '0:00';
  String _loadingTime = '0:00';

  double _chatBoxHeight = 0.0;

  String _hintText = "Type Here...";

  /// For Audio Player
  IconData _iconData = Icons.play_arrow_rounded;

  //jeu variable
  final _textController = new TextEditingController();
  _ChatDetailState( this.group);
  @override
  void initState() {
    super.initState();
  }

  bool isSender(String friend) {
    return friend == currentUserId;
  }

  Alignment getAlignement(String friend) {
    if (friend == currentUserId) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }
  ImageProvider<Object>? userImage(String url){
    if(url.isNotEmpty)
    {
      return NetworkImage(url) ;
    }else{
      return const AssetImage('assets/images/userImage.png') ;
    }
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Expanded(
      child: StreamBuilder(
          stream: ref.watch(chatControllerProvider).getAllOneToOneMessage(group.groupId),
          builder: ((context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Une erreur s'est produite"),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text("Chargement de vos messages", style: TextStyle(color: Colors.white)),
                    ),
                    CircularProgressIndicator(
                      color: Colors.white
                    )
                  ],
                );
            }
            if (snapshot.hasData) {
              var data;
              return   Container(
                padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: const BoxDecoration(
                  color: Color(0xffD9D9D9),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                child: ListView.builder(
                              reverse: true,
                              itemCount: snapshot.data!.length,
                              shrinkWrap: true,
                              itemBuilder: (_, index) {
                                final message = snapshot.data?[index];
                      bool isMe = message['message'].senderId == FirebaseAuth.instance.currentUser!.uid;
                      return Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: isMe
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (!isMe)
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundImage:userImage(message['sender'].profileImageUrl!),
                                    ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                      padding: const EdgeInsets.all(10),
                                      constraints: BoxConstraints(
                                          maxWidth: width * 0.7),
                                      decoration: BoxDecoration(
                                          color: isMe
                                              ? const Color(0xff5E2B9F)
                                              : const Color.fromARGB(
                                                  255, 195, 142, 231),
                                          borderRadius: BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(16),
                                              topRight:
                                                  const Radius.circular(16),
                                              bottomLeft: Radius.circular(
                                                  isMe ? 12 : 0),
                                              bottomRight: Radius.circular(
                                                  isMe ? 0 : 12))),
                                      child: Column(
                                        children: [
                                          if ((message['message'].type == MessageType.image))
                                        Image.network(message['message'].urlImage),
                                      if ((message['message'].type ==
                                          MessageType.audio)) //afficheur
                                        ChatAudio(
                                          index: '$index',
                                          justAudioPlayer: _justAudioPlayer,
                                          urlAudio: message['message'].urlImage,
                                        ),
                                      if ((message['message'].type == MessageType.other))
                                        Row(children: [
                                          IconButton(
                                              onPressed: () async {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Row(
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                              'Telechargement en cours')),
                                                      CircularProgressIndicator(
                                                        color: Colors.white,
                                                      )
                                                    ],
                                                  )),
                                                );
                                                _downloadsDirectory =
                                                    await getApplicationDocumentsDirectory();
                                                response = await dio.download(
                                                    message['message'].urlImage,
                                                    '${_downloadsDirectory.path}/${message['message'].filename}');
                                              ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Row(
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                              'Telecharger dans ${_downloadsDirectory.path}/${message['message'].filename}')),
                                                     
                                                    ],
                                                  )),
                                                );
                                              },
                                              icon: Icon(Icons.download,
                                                  color: isSender(message['message']
                                                          .senderId
                                                          .toString())
                                                      ? Colors.white
                                                      : Colors.black)),
                                          Expanded(
                                            child: Text(
                                              '${message['message'].filename}',
                                              style: TextStyle(
                                                  color: isSender(message['message']
                                                          .senderId
                                                          .toString())
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                          )
                                        ]),
                                        Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(message['message'].textMessage,
                                                style: TextStyle(
                                                    color: isMe
                                                        ? Colors.white
                                                        : Colors.black),
                                                maxLines: 100,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          )
                                        ],
                                      ),
                                      
                                        ],
                                      )
                                      ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment: isMe
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    if (!isMe)
                                      const SizedBox(
                                        width: 40,
                                      ),
                                    const Icon(
                                      Icons.done_all,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text('${message['message'].timeSent}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ));
                                
                              }),
              ));
            } else {
              return Center(
                child: Text("Veuillez attendre"),
              );
            }
          })),
    );
  }
  //fonction de audio
}


