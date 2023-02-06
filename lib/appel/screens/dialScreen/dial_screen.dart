import '../../constants.dart';
import 'package:flutter/material.dart';

import '../../size_config.dart';
import 'components/body2.dart';

class DialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kBackgoundColor,
      body: Body(),
    );
  }
}
