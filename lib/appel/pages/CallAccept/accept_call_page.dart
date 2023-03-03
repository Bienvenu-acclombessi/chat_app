import 'package:chatapp/commun/colors/colors.dart';
import 'package:chatapp/commun/models/userModel.dart';

import '../../constants.dart';
import 'package:flutter/material.dart';

import '../../size_config.dart';
import 'components/body2.dart';

class AcceptCallScreen extends StatelessWidget {
  final String callId;
  final String roomId;
  final UserModel user;
  final String type;

   const AcceptCallScreen({super.key, required this.callId, required this.roomId,required this.user,required this.type});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: all,
      body: Body(callId:callId,roomId:roomId,user:user,type:type),
    );
  }
}
