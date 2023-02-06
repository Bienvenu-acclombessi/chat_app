import '../../../components/dial_user_pic.dart';
import '../../../components/rounded_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:flutter/material.dart';

import 'dial_button.dart';

class Body extends StatefulWidget {
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
                "Anna williams",
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    !.copyWith(color: Colors.white),
              ),
              Text(
                "Appel en cours…",
                style: TextStyle(color: Colors.white60),
              ),
             Spacer(),
              
             VerticalSpacing(),
              RoundedButton(
                iconSrc: "assets/icons/call_end.svg",
                press: () {},
                color: kRedColor,
                iconColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
