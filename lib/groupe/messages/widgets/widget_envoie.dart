
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_recorder/audio_encoder_type.dart';
import 'package:social_media_recorder/screen/social_media_recorder.dart';

import '../controller/controller_chat.dart';
import 'chat_file_dialog.dart';
import 'chat_imageDialog.dart';

class MessageSender extends StatefulWidget {
  final String groupId;
  final WidgetRef ref;
  const MessageSender({super.key,required this.groupId,required this.ref});

  @override
  State<MessageSender> createState() => _MessageSenderState();
}

class _MessageSenderState extends State<MessageSender> {
  
  final _textController = new TextEditingController();
  bool isMessageIconEnabled = false;
  void sendMessage(String msg) async {
    setState((){isMessageIconEnabled=false;});
    _textController.text = '';
    if (msg == '') return;
    widget.ref.read(chatControllerProvider).sendTextMessage(
          context: context,
          textMessage: msg,
          receiverId: widget.groupId,
        );

  }

  void sendAudioMessage(File fichier,BuildContext context) async {
    _textController.text = '';
     ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Row(children: [
      Expanded(child: Text('Audio en cours d\'envoie ')),
      CircularProgressIndicator(color: Colors.white,)
    ],)),
  );
    String audiopath =
        await widget.ref.read(chatControllerProvider).uploadAudioFile(fichier);
    print(audiopath);
    fichier.delete();
    widget.ref.read(chatControllerProvider).sendAudioMessage(
        context: context,
        textMessage: '',
        receiverId: widget.groupId,
        urlImage: audiopath);
  }
  @override
  Widget build(BuildContext context) {
    return 
                  Container(
                    color: Colors.grey[300],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _textController,
                                  maxLines: 4,
                                  minLines: 1,
                                  onChanged: (value) {
                                    value.isEmpty
                                        ? setState((){isMessageIconEnabled=false;})
                                        : setState((){isMessageIconEnabled=true;});
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Message',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.white,
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        style: BorderStyle.none,
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    prefixIcon: Material(
                                      color: Colors.transparent,
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.emoji_emotions_outlined),
                                      ),
                                    ),
                                    suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        RotatedBox(
                                          quarterTurns: 45,
                                          child: IconButton(
                                            
                                          focusColor: Color(0xff5E2B9F),
                                            onPressed: () => ChatFileDialog(
                                                  ref: widget.ref,
                                                  groupId: widget.groupId,
                                                  othermessage:
                                                      _textController.text)
                                              .showFileMessageDialog(
                                                  context),
                                            icon: Icon(Icons.attach_file),
                                          ),
                                        ),
                                        IconButton(
                                          hoverColor: Color(0xff5E2B9F),
                                          focusColor: Color(0xff5E2B9F),
                                          onPressed: () => ChatImageDialog(
                                                  ref: widget.ref,
                                                  groupId: widget.groupId,
                                                  othermessage:
                                                      _textController.text)
                                              .showImageMessageDialog(
                                                  context, ImageSource.gallery),
                                          icon: Icon(Icons.camera_alt_outlined),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              IconButton(
                                onPressed: () =>sendMessage(_textController.text),
                                icon: Icon(
                                  Icons.send_outlined

                                ),
                                color: Colors.white,
                              ),
                            ],
                          ),
                          const SizedBox(width: 5),
                    isMessageIconEnabled ? SizedBox() : Container(
                            padding:
                                const EdgeInsets.only(top: 10, left: 4, right: 6),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: SocialMediaRecorder(
                                radius: BorderRadius.circular(50) ,
                                backGroundColor: Colors.white,
                                recordIcon: Icon(
                                  Icons.mic_none_outlined,
                                  color: Color(0xff5E2B9F),
                                  size: 30,
                                ),
                                sendRequestFunction: (soundFile) async {
                                  //  _assetsAudioPlayer.open(
                                  //      Audio.file(soundFile.path),
                                  //  );
                                  if (soundFile.path == '') return;
                                  sendAudioMessage(soundFile,context);
                                  print("the current path is ${soundFile.path}");
                                 
                                },
                                encode: AudioEncoderType.AAC,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
  }
}
