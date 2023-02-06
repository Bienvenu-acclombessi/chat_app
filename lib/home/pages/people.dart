import 'package:chatapp/commun/models/userModel.dart';
import 'package:chatapp/messages/pages/message_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../messages/controller/controller_chat.dart';
import '../widgets/header.dart';

class People extends ConsumerStatefulWidget {
  const People({super.key});

  @override
  ConsumerState<People> createState() => _PeopleState();
}

class _PeopleState extends ConsumerState<People> {

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
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Nouveau message'),
          backgroundColor: Color(0xff5E2B9F),
        ),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SafeArea(

              child: SizedBox(
            width: width,
            height: height,
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: StreamBuilder<List<UserModel>>(
        stream: ref.watch(chatControllerProvider).getAllUser(),
        builder: (_, snapshot) {
          if ( snapshot.connectionState != ConnectionState.active) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
            if(snapshot.hasData){
          return ListView.builder(
            itemCount: snapshot.data!.length ,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final user = snapshot.data![index];
              return ListTile(
                 leading: CircleAvatar(
              backgroundImage: userImage(user.profileImageUrl!) ,
            ),
                onTap: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatRoom(user: user) ));
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${user.prenom} ${user.nom}'),
                    // Text(
                    //   DateFormat.Hm().format(lastMessageData.timeSent),
                    //   style: TextStyle(
                    //     fontSize: 13,
                    //     color: context.theme.greyColor,
                    //   ),
                    // ),
                  ],
                ),
                
              );
            },
          );
            }
            else{
          return Center(child: Text("Veuillez attendre"),);
        }
        },
      ),
                 )
                
              ],
            ),
          )),
        ));
  }
}
