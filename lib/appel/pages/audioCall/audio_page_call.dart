import 'package:chatapp/commun/colors/colors.dart';
import 'package:flutter/material.dart';

import '../../../commun/models/userModel.dart';
import '../../size_config.dart';
import 'component/body.dart';
import 'package:chatapp/appel/logiques/calltype.dart';
class AudioPageCall extends StatelessWidget {
  CallType callType;
  final String? callId;
  final String? roomId;
  final UserModel user;

    AudioPageCall({super.key,  this.callId, required this.callType, this.roomId,required this.user});
  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: all,
      body: Body(callId:callId,roomId:roomId,user:user,callType:callType),
    );
  }
}
