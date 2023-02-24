import 'package:chatapp/appel/pages/audioCall/audio_page_call.dart';
import 'package:chatapp/appel/pages/videoCall/video_page_call.dart';
import 'package:chatapp/commun/colors/colors.dart';
import 'package:chatapp/commun/models/userModel.dart';
import 'package:chatapp/home/pages/profil.dart';
import 'package:chatapp/messages/widgets/messages_list_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:chatapp/appel/logiques/calltype.dart';
import '../widgets/widget_envoie.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key, required this.user});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
  final UserModel user;
}

class _ChatRoomState extends State<ChatRoom> {
  ImageProvider<Object>? userImage(String url){
    if(url.isNotEmpty)
    {
      return NetworkImage(widget.user.profileImageUrl!) ;
    }else{
      return const AssetImage('assets/images/userImage.png') ;
    }
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: primary,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            InkWell(
              onTap: () {
             //   Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage(user: widget.user)));
              },
              child: CircleAvatar(
                radius: 30,
                backgroundImage: userImage(widget.user.profileImageUrl!) ,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.user.prenom),
                const Text(
                  'Online',
                  style: TextStyle(color: Color(0xffD9D9D9), fontSize: 14),
                )
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () async{
                if (await Permission.camera.request().isGranted) {
                          if (await Permission.microphone.request().isGranted) {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AudioPageCall(callType: CallType.calling , user: widget.user)));
        
}
}
              },
              icon: Icon(
                Icons.videocam,
                color: Colors.white,
                size: 20,
              )),
          IconButton(
              onPressed: () async{
                       if (await Permission.camera.request().isGranted) {
                          if (await Permission.microphone.request().isGranted) {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoPageCall(callType: CallType.calling , user: widget.user)));
        
}
}
              },
              icon: const Icon(
                Icons.call,
                color: Colors.white,
                size: 20,
              ))
        ],
      ),
      backgroundColor: primary ,
      body: Column(
        children: [
          //detail du chat
         ChatDetail(user: widget.user),
        //  fin detail 
        Consumer(builder: (BuildContext context, WidgetRef ref, Widget? chil) {
          return(MessageSender(
                    friendUid: widget.user.uid,
                    ref: ref,
                  ));
        })
                  
        ],
      ),
    );
  }
}
