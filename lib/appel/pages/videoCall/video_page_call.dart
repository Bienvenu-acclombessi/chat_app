import 'package:chatapp/appel/logiques/calltype.dart';
import 'package:flutter/material.dart';

import '../../../commun/models/userModel.dart';
import '../../size_config.dart';
import 'components/body.dart';



class VideoPageCall extends StatelessWidget {
  CallType callType;
  final String? callId;
  final String? roomId;
  final UserModel user;

    VideoPageCall({super.key,  this.callId, required this.callType, this.roomId,required this.user});
  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(callId:callId,roomId:roomId,user:user,callType:callType),
    );
  }
}
