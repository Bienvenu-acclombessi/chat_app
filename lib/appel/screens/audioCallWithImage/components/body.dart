import 'package:chatapp/appel/screens/dialScreen/dial_screen.dart';

import '../../../components/rounded_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _localVideoRenderer = RTCVideoRenderer();

  void initRenderers() async {
    await _localVideoRenderer.initialize();
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
    _getUserMedia();
    super.initState();
  }

  @override
void dispose() async {
    await _localVideoRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        RTCVideoView(
          _localVideoRenderer,mirror: true,
          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          ),
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
                  "Bienvenu ACCLOMBE",
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
                      press: () {},
                      iconSrc: "assets/icons/Icon Mic.svg",
                    ),
                    RoundedButton(
                      press: () {},
                      iconSrc: "assets/icons/Icon Video.svg",
                    ),

                    RoundedButton(
                      press: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>DialScreen()));
                        _localVideoRenderer.dispose();
                      },
                      color: kRedColor,
                      iconColor: Colors.white,
                      iconSrc: "assets/icons/call_end.svg",
                    ),
                    RoundedButton(
                      press: () {},
                      iconSrc: "assets/icons/Icon Volume.svg",
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
            child: RTCVideoView(
          _localVideoRenderer,mirror: true,
          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          ),
        ),
          ))
      ],
    );
  }
}
