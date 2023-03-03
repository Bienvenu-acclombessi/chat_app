import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:chatapp/service/essai.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatapp/welcome/splashscreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'package:chatapp/commun/colors/colors.dart';
import 'service/notification/demarrage.dart';


Future<void> main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();
  await notification_demarrage();
 await Firebase.initializeApp();

  runApp( ProviderScope(
  child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
   MyApp( {
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
       return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chatapp',
      theme: ThemeData(
        primaryColor:primary,
      ),
     // home: HomePage()
      home: const SplashScreen(),
      
    )
    );
    
  }
}
