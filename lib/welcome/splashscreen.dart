import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:chatapp/welcome/welcome.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3)).then((value) =>
        Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (context) => const Description())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff5E2B9F),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Image(image: AssetImage("assets/images/logo_couleur.jpg")),
          SizedBox(
            height: 50,
          ),
          SpinKitSpinningLines(
            color: Colors.white,
            size: 50,
          )
        ],
      ),
    );
  }
}
