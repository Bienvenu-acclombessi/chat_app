
import 'package:chatapp/commun/colors/colors.dart';
import 'package:chatapp/commun/models/userModel.dart';
import 'package:chatapp/home/widgets/user_circle.dart';
import 'package:chatapp/messages/pages/message_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContactListile extends StatefulWidget {
  UserModel user;
   ContactListile({super.key,required this.user});

  @override
  State<ContactListile> createState() => _ContactListileState();
}

class _ContactListileState extends State<ContactListile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
                onTap: () {
                  
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatRoom(user: widget.user) ));
                },
                leading: UserAvatar(user: widget.user),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${widget.user.prenom} ${widget.user.nom}',style:TextStyle(fontWeight:FontWeight.bold,fontSize: 15),overflow: TextOverflow.visible,),
                    // Text(
                    //   DateFormat.Hm().format(lastMessageData.timeSent),
                    //   style: TextStyle(
                    //     fontSize: 13,
                    //     color: context.theme.greyColor,
                    //   ),
                    // ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    'En ligne',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                trailing: SizedBox(
                  width: 79,
                  child: Row(
                    children: [
                      Expanded(child: IconButton(onPressed: (){
                        
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatRoom(user: widget.user) ));
                      },
                      color: primary, 
                      icon: Icon(Icons.message))),
                       Expanded(child: IconButton(onPressed: (){
                        
                      },
                      color: primary, 
                      icon: Icon(Icons.call))),
                    
                    ],
                  ),
                ),
              );
  }
}
