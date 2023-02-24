import 'package:chatapp/commun/colors/colors.dart';
import 'package:chatapp/service/wrapper.dart';
import 'package:chatapp/welcome/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  bool existe=false;
  @override
  void initState() {
    super.initState();
     wrapperwelcom();
  }

  
   wrapperwelcom() async{
    final prefs = await SharedPreferences.getInstance();
   final exist= prefs.getInt('exist');
   if(exist==null ){
    
    Future.delayed(const Duration(seconds: 4)).then((value) =>
        Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (context) => const Onboarding())));
   }else{
 setState(() {
  
    Future.delayed(const Duration(seconds: 4)).then((value) =>
        Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (context) => const Wrapper())));
 });
   }
   
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: all,
      body: SafeArea(
        child: Stack(children: [
          const Center(
            child: Text(
              "ChatApp",
              style: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.bold, color: white),
            ),
          ),
          Positioned(
              left: 20.h,
              right: 20.h,
              bottom: 100.h,
              child: const SpinKitSpinningLines(
                color: white,
                size: 50,
              ))
        ]),
      ),
    );
  }
}
