import 'package:chatapp/groupe/pages/home_page.dart';
import 'package:chatapp/home/pages/call.dart';
import 'package:chatapp/home/pages/contacts.dart';
import 'package:flutter/material.dart';

import 'home.dart';


class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int currentIndex = 0;
  final List screens = [
    const MyHome(),
    const CallList(),
    const ContactList(),
    const HomeGroup(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const MyHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(bucket: bucket, child: currentScreen),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: const Color(0xff5E2B9F),
      //   child: const Icon(Icons.online_prediction),
      //   onPressed: () {},
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const MyHome();
                        currentIndex = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          color: currentIndex == 0
                              ? const Color(0xff5E2B9F)
                              : Colors.black,
                        ),
                        Text(
                          "Home",
                          style: TextStyle(
                            color: currentIndex == 0
                                ? const Color(0xff5E2B9F)
                                : Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const CallList();
                        currentIndex = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.call,
                          color: currentIndex == 1
                              ? const Color(0xff5E2B9F)
                              : Colors.black,
                        ),
                        Text(
                          "Appel",
                          style: TextStyle(
                            color: currentIndex == 1
                                ? const Color(0xff5E2B9F)
                                : Colors.black,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const ContactList();
                        currentIndex = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color: currentIndex == 2
                              ? const Color(0xff5E2B9F)
                              : Colors.black,
                        ),
                        Text(
                          "Contact",
                          style: TextStyle(
                            color: currentIndex == 2
                                ? const Color(0xff5E2B9F)
                                : Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const HomeGroup();
                        currentIndex = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people,
                          color: currentIndex == 3
                              ? const Color(0xff5E2B9F)
                              : Colors.black,
                        ),
                        Text(
                          "Groupe",
                          style: TextStyle(
                            color: currentIndex == 3
                                ? const Color(0xff5E2B9F)
                                : Colors.black,
                          ),
                        )
                      ],
                    ),
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
