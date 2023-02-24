import 'package:chatapp/commun/models/lastMessagemodel.dart';
import 'package:chatapp/commun/models/userModel.dart';
import 'package:chatapp/home/widgets/user_circle.dart';
import 'package:chatapp/messages/pages/message_page.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/commun/colors/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class UserMessageListile extends StatefulWidget {
  UserModel user;
  LastMessageModel lastMessage;
  int? nouveau;
  UserMessageListile({super.key,required  this.user , required this.lastMessage,this.nouveau});
  @override
  State<UserMessageListile> createState() => _UserMessageListileState();
}

class _UserMessageListileState extends State<UserMessageListile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
       onTap: () {
                  
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatRoom(user: widget.user) ));
                },
      child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.2,
                                  child:  ListTile(
                                    leading: UserAvatar(user: widget.user),
                                    title: Text("${widget.user.nom} ${widget.user.prenom}",maxLines: 1,style:TextStyle(fontWeight:FontWeight.bold)),
                                    subtitle:  Text("${widget.lastMessage.lastMessage}"),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Column(
                                    children: [
                                 widget.nouveau!>0 ?     CircleAvatar(
                                        backgroundColor: all,
                                        foregroundColor: white,
                                        radius: 10,
                                        child: Text(
                                          "${widget.nouveau!}",
                                          style: TextStyle(
                                              fontSize: 15.r,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ):SizedBox(),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Text(
                                        "${formattingDateMessage(widget.lastMessage.timeSent)}",
                                        style: TextStyle(
                                            fontSize: 11.r,
                                            color: Colors.black38,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
    );
  }
  
   String formattingDateMessage(date) {
    initializeDateFormatting('fr', null);
    DateTime? dateTime = date;
    DateFormat dateFormat = DateFormat.Hm('fr');
    return dateFormat.format(dateTime ?? DateTime.now());
  }
}

