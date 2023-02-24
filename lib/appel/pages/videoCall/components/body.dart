import 'package:chatapp/appel/logiques/signaling.dart';
import 'package:chatapp/commun/models/userModel.dart';
import 'package:chatapp/service/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatapp/appel/logiques/calltype.dart';
import '../../../components/rounded_button.dart';
import '../../../constants.dart';
import '../../../logiques/suivre_call.dart';
import '../../../size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../video_page_call.dart';

class Body extends StatefulWidget {
 CallType callType;
  final String? callId;
  final String? roomId;
  final UserModel user;

    Body({super.key, required this.callId, required this.callType, required this.roomId,required this.user});
  
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _localVideoRenderer = RTCVideoRenderer();
 Signaling signaling = Signaling();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool start=false;
   String? roomId;
   String? callId;
  void initRenderers() async {
    await _localVideoRenderer.initialize();
    _remoteRenderer.initialize();
    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {
        start=true;
      });
    });
     signaling.openUserMedia(_localVideoRenderer, _remoteRenderer);
         if (widget.callType == CallType.calling) {
      roomId = await signaling.createRoom(_remoteRenderer);
     ChatAppel(firestore: FirebaseFirestore.instance,auth: FirebaseAuth.instance ).addCall(roomId!, widget.user.uid, 'video').then((value){
      callId=value;
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

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Wrapper()));
        }
      });
    } else {
      callId= widget.callId;
      roomId = widget.roomId;
    await  signaling.joinRoom(
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
    return Stack(
      fit: StackFit.expand,
      children: [
       start ? RTCVideoView(
          _remoteRenderer,mirror: true,
          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          ) : RTCVideoView(
          _localVideoRenderer,mirror: true,
          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          ) ,
        // Image
        // Image.asset(
        //   "assets/images/full_image.png",
        //   fit: BoxFit.cover,
        // ),
        // Black Layer
        DecoratedBox(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.user.prenom } ${widget.user.nom }",
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      ?.copyWith(color: Colors.white),
                ),
                VerticalSpacing(of: 10),
                Text(
                  "Incoming 00:01".toUpperCase(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    
                    RoundedButton(
                      press: () async{

                       if(callId!=null)
                       {
                         await FirebaseFirestore.instance.collection('appel_cours').doc(callId).update({'etat': 2}); //Terminer
                                  signaling.hangUp(_localVideoRenderer);
                       }
                        _localVideoRenderer.dispose();
                         _remoteRenderer.dispose();

                        Navigator.push(context,MaterialPageRoute(builder: (context)=>Wrapper()));
                        
                      },
                      color: kRedColor,
                      iconColor: Colors.white,
                      iconSrc: "assets/icons/call_end.svg",
                    ),
                    
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.only(right:8.0),
            child: Container(
            width: 100,
            height: 250,
            child: start ? RTCVideoView(
          _localVideoRenderer,mirror: true,
          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          ) : SizedBox(),
        ),
          ))
      ],
    );
  }
}
