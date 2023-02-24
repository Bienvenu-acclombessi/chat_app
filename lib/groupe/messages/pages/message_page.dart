import 'package:chatapp/commun/colors/colors.dart';
import 'package:chatapp/commun/models/groupModel.dart';
import 'package:chatapp/commun/models/userModel.dart';
import '../../pages/group_info.dart';
import '../widgets/messages_list_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/widget_envoie.dart';

class ChatRoom extends StatefulWidget {
  final GroupModel group;
  const ChatRoom({super.key, required this.group});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
  
}

class _ChatRoomState extends State<ChatRoom> {
  Widget userImage(String url){
    if(url.isNotEmpty)
    {
      return  CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(url) ,
            )
      
       ;
    }else{
      return  CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Text(
              widget.group.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: primary, fontWeight: FontWeight.w500),
            ),
          );
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
            userImage(widget.group.groupIcon) ,
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.group.groupName),
                Text(
                  '+ ${widget.group.members.length} Membres',
                  style: TextStyle(color: Color(0xffD9D9D9), fontSize: 14),
                )
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>GroupInfo(group:widget.group,)));
              },
              icon: Icon(
                Icons.info,
                color: Colors.white,
                size: 20,
              )),
        ],
      ),
      backgroundColor: primary,
      body: Column(
        children: [
          //detail du chat
         ChatDetail(group: widget.group),
        //  fin detail 
        Consumer(builder: (BuildContext context, WidgetRef ref, Widget? chil) {
          return(MessageSender(
                    groupId: widget.group.groupId,
                    ref: ref,
                  ));
        })
                  
        ],
      ),
    );
  }
}
