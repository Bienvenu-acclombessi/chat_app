
import 'package:chatapp/commun/models/groupModel.dart';
import 'package:chatapp/groupe/messages/pages/message_page.dart';
import 'package:chatapp/groupe/messages/widgets/messages_list_widget.dart';
import 'package:chatapp/groupe/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../pages/chat_page.dart';

class GroupTile extends StatefulWidget {
  final GroupModel group;
  const GroupTile(
      {Key? key, required this.group})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
   Widget GroupImage(String url){
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
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.group.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          );
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            ChatRoom(
              group: widget.group,
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: ListTile(
          leading: GroupImage(widget.group.groupIcon),
          title: Text(
            widget.group.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            
            widget.group.recentMessage,
            maxLines: 1,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
