import 'package:flutter/cupertino.dart';
import 'package:chatapp/service/wrapper.dart';
import 'package:chatapp/commun/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: all,
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Column(
        children: [
          Container(
            width: size.width,
            height: size.height < 600 ? 350.h : 450.h,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/full_image.png"),
                    fit: BoxFit.cover)),
          ),
          Expanded(
              child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 30, top: 20, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Text(
                      "Trouvez tes meilleurs potes ",
                      style: TextStyle(
                          fontSize: 25.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Commencez une nouvelle discussion,une nouvelle amitié,une nouvelle aventure ... sur chatApp",
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: (size.width - 100) / 2,
                          height: 50.h,
                          decoration: BoxDecoration(
                              color: all,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: TextButton(
                              onPressed: () async{
                                final prefs = await SharedPreferences.getInstance();
      prefs.setInt('exist', 1);
                                                Navigator.of(context).pushReplacement(CupertinoPageRoute(
                    builder: (context) => const Wrapper()));
            
                              },
                              child: Text(
                                "Demarrer",
                                style: TextStyle(fontSize: 15.sp, color: white),
                              ),
                            ),
                          ),
                        ),
                        Container(
                            width: (size.width - 100) / 5,
                            height: 10.h,
                            decoration: BoxDecoration(
                                color: all,
                                borderRadius: BorderRadius.circular(30))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
