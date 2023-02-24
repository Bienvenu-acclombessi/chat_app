
import 'package:chatapp/commun/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/groupe/pages/home_page.dart';
import 'package:chatapp/home/pages/call.dart';
import 'package:chatapp/home/pages/contacts.dart';
import 'home.dart';
import 'more.dart';


List itemsTab = [
  {"icon": Icons.home, "size": 28.0},
  {"icon": Icons.people, "size": 22.0},
  {"icon": Icons.person_rounded, "size": 25.0},
  {"icon": Icons.call, "size": 22.0},
  {"icon": Icons.more_horiz, "size": 40.0},
];
class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int activeTab = 0;
   int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
      MyHome(),
    HomeGroup(),
     ContactList(),
     CallList(),
     MorePage()
  ];
 
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      bottomNavigationBar: getFooter(),
      body: _widgetOptions.elementAt(_selectedIndex)
    );
  }


  Widget getBody() {
    return SafeArea(
      child: IndexedStack(
        index: activeTab,
        children: [
          MyHome(),
          Center(
            child: Text("data"),
          ),
          Center(
            child: Text("data"),
          ),
          CallList(),
          MorePage()
        ],
      ),
    );
  }

  Widget getFooter() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
          color: white,
          border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2)))),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
              itemsTab.length,
              (index) => IconButton(
                  onPressed: () {
                    setState(() {
                     _selectedIndex=index;
                    });
                  },
                  icon: Icon(
                    itemsTab[index]['icon'],
                    size: itemsTab[index]['size'],
                    color:  _selectedIndex == index ? all : black,
                  ))),
        ),
      ),
    );
  }
}
