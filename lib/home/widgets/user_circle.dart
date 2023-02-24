import 'package:chatapp/commun/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/commun/colors/colors.dart';


class UserAvatar extends StatefulWidget {
  UserModel user;
  UserAvatar({super.key, required this.user});

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {

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
    return  CircleAvatar(
      backgroundColor: all,
      foregroundColor: white,
      backgroundImage: userImage(widget.user.profileImageUrl!),
      radius: 25,
    );
  }
}
