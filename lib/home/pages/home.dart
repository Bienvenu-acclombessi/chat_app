import 'package:chatapp/auth/auth_repository/auth_repository.dart';
import 'package:chatapp/home/widgets/last_message_list.dart';
import 'package:chatapp/home/widgets/user_online.dart';
import 'package:chatapp/messages/pages/message_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chatapp/commun/colors/colors.dart';
import '../../messages/controller/controller_chat.dart';
import '../widgets/header.dart';
import 'people.dart';
import 'search_page.dart';

class MyHome extends ConsumerStatefulWidget {
  const MyHome({super.key});

  @override
  ConsumerState<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends ConsumerState<MyHome> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  ImageProvider<Object>? userImage(String url){
    if(url.isNotEmpty)
    {
      return NetworkImage(url) ;
    }else{
      return const AssetImage('assets/images/userImage.png') ;
    }
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: white,
          title: Text(
            "Messages",
            style: TextStyle(
                fontSize: 25.r, fontWeight: FontWeight.bold, color: black),
          ),
          actions: [
            Container(
                height: 25.h,
                width: 30.h,
                margin: const EdgeInsets.only(top: 10, bottom: 10, right: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: all),
                child: IconButton(
                    onPressed: () async{
  ref.read(chatControllerProvider).getAllUsers().then((users){
  Navigator.push(
                        context, MaterialPageRoute(builder: (context)=>SearchPage(data: users,))
                      );                
  });                    },
                    icon: const Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: white,
                    )))
          ],
        ),
        key: scaffoldKey,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SafeArea(
              child: SizedBox(
            width: width,
            height: height,
            child: Column(
              children: [
             //   Header(height: height),
                const SizedBox(
                  height: 15,
                ),
                UserOnline(),
                LastMessageList()
                
              ],
            ),
          )),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primary,
          child: Icon(Icons.add,color:Colors.white ),
          onPressed: (){
            Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => People() ));
          },
        )
        );
  }
}
