
import 'package:chatapp/commun/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../logiques/signaling.dart';
enum CallType { calling, accepted, ringing }

class AppelVideo extends StatefulWidget {
  final CallType callType;
  final String? roomId;
  final UserModel user;
  const AppelVideo({super.key,required this.callType,this.roomId,required this.user});

  @override
  State<AppelVideo> createState() => _AppelVideoState();
}

class _AppelVideoState extends State<AppelVideo> {
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}