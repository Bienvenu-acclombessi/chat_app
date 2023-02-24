import 'package:chatapp/commun/models/userModel.dart';
import 'package:chatapp/home/widgets/user_circle.dart';
import 'package:chatapp/messages/pages/message_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chatapp/messages/controller/controller_chat.dart';

class UserOnline extends ConsumerStatefulWidget {
  const UserOnline({super.key});

  @override
  ConsumerState<UserOnline> createState() => _UserOnlineState();
}

class _UserOnlineState extends ConsumerState<UserOnline> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
          height: 100,  
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
            scrollDirection : Axis.horizontal,
            itemCount: snapshot.data!.length ,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final user = snapshot.data![index];
              return GestureDetector(
                onTap: (){
Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatRoom(user: user) ));
        
                },
                child: Container(
                  margin: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      UserAvatar(user: user),
                      Text("${user.prenom}",overflow: TextOverflow.ellipsis,)
                    ],
                  ),
                ),
              );
                
            },
          );
            }
            else{
          return SizedBox();
        }
        },
      ),
                 );
  }
}

