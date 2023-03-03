import 'package:chatapp/appel/pages/audioCall/audio_page_call.dart';
import 'package:chatapp/appel/pages/videoCall/video_page_call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/appel/logiques/calltype.dart';

import 'package:permission_handler/permission_handler.dart';
import '../../../../commun/models/userModel.dart';
import '../../../components/dial_user_pic.dart';
import '../../../components/rounded_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:flutter/material.dart';

import 'dial_button.dart';

class Body extends StatefulWidget {
  final String callId;
  final String roomId;
  final UserModel user;
  final String type;

  const Body(
      {super.key,
      required this.callId,
      required this.roomId,
      required this.user,
      required this.type});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VerticalSpacing(),
              DialUserPic(image: "assets/images/calling_face.png"),
              VerticalSpacing(),
              Text(
                "${widget.user.prenom} ${widget.user.nom}",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.white),
              ),
              Text(
                "Appel ${widget.type} en cours…",
                style: TextStyle(color: Colors.white60),
              ),
              Spacer(),
              VerticalSpacing(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RoundedButton(
                    iconSrc: "assets/icons/call_end.svg",
                    press: () async {
                      await FirebaseFirestore.instance
                          .collection('appel_cours')
                          .doc(widget.callId)
                          .update({'etat': -1});
                    },
                    color: kRedColor,
                    iconColor: Colors.white,
                  ),
                  RoundedButton(
                    iconSrc: "assets/icons/call_end.svg",
                    press: () async {
                      if (widget.type.compareTo('audio') == -1) {
                        if (await Permission.microphone.request().isGranted) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AudioPageCall(
                                      callType: CallType.calling,
                                      user: widget.user)));
                        }
                      } else {
                        if (await Permission.camera.request().isGranted) {
                          if (await Permission.microphone.request().isGranted) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VideoPageCall(
                                        callId: widget.callId,
                                        roomId: widget.roomId,
                                        user: widget.user,
                                        callType: CallType.accepted)));
                          }
                        }
                      }
                    },
                    color: Colors.green,
                    iconColor: Colors.white,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
