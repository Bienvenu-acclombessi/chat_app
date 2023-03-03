import 'package:chatapp/appel/logiques/countup.dart';
import 'package:chatapp/appel/logiques/signaling.dart';
import 'package:chatapp/commun/models/userModel.dart';
import 'package:chatapp/service/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../components/rounded_button.dart';
import '../../../constants.dart';
import '../../../logiques/suivre_call.dart';
import '../../../size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:chatapp/appel/logiques/calltype.dart';
import '../audio_page_call.dart';

class Body extends StatefulWidget {
  CallType callType;
  final String? callId;
  final String? roomId;
  final UserModel user;

  Body(
      {super.key,
      required this.callId,
      required this.callType,
      required this.roomId,
      required this.user});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _localVideoRenderer = RTCVideoRenderer();
  Signaling signaling = Signaling();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool start = false;
  String? roomId;
  String? callId;
  void initRenderers() async {
    await _localVideoRenderer.initialize();
    _remoteRenderer.initialize();
    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {
        start = true;
      });
    });
    signaling.openUserMedia(_localVideoRenderer, _remoteRenderer);
    if (widget.callType == CallType.calling) {
      roomId = await signaling.createRoom(_remoteRenderer);
      ChatAppel(
              firestore: FirebaseFirestore.instance,
              auth: FirebaseAuth.instance)
          .addCall(roomId!, widget.user.uid, 'audio')
          .then((value) {
        callId = value;
      });

      print("roomID: $roomId");
      FirebaseFirestore.instance
          .collection('appel_cours')
          .doc(callId)
          .snapshots()
          .asyncMap((event) {
        if (event.get('etat') == 2) {
          if (callId != null) {
            signaling.hangUp(_localVideoRenderer);
          }
          _localVideoRenderer.dispose();
          _remoteRenderer.dispose();

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Wrapper()));
        }
      });
    } else {
      callId = widget.callId;
      roomId = widget.roomId;
      await FirebaseFirestore.instance.collection('appel_cours').doc(widget.callId).update({'etat': 1}); //accepter
       
      await signaling.joinRoom(
        roomId!,
        _remoteRenderer,
      );
      

      FirebaseFirestore.instance
          .collection('appel_cours')
          .doc(callId)
          .snapshots()
          .asyncMap((event) {
        if (event.get('etat') == 2) {
          if (callId != null) {
            signaling.hangUp(_localVideoRenderer);
          }
          _localVideoRenderer.dispose();
          _remoteRenderer.dispose();

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Wrapper()));
        }
      });
    }
  }

  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      }
    };

    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localVideoRenderer.srcObject = stream;
  }

  @override
  void initState() {
    initRenderers();

    super.initState();
  }

  @override
  void dispose() async {
    await _localVideoRenderer.dispose();
    await _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${widget.user.prenom} ${widget.user.nom}",
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.white),
              ),
              start
                  ? Countup()
                  : Text(
                      "Appel audio en cours",
                      style: TextStyle(color: Colors.white60),
                    ),
              Spacer(),
              VerticalSpacing(),
              RoundedButton(
                press: () async {
                  if (callId != null) {
                    await FirebaseFirestore.instance
                        .collection('appel_cours')
                        .doc(callId)
                        .update({'etat': 2}); //Terminer
                    signaling.hangUp(_localVideoRenderer);
                  }
                  _localVideoRenderer.dispose();
                  _remoteRenderer.dispose();

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Wrapper()));
                },
                color: kRedColor,
                iconColor: Colors.white,
                iconSrc: "assets/icons/call_end.svg",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
