import 'package:chatapp/commun/models/userModel.dart';
import 'package:chatapp/commun/widgets/error_page.dart';
import 'package:chatapp/home/widgets/user_circle.dart';
import 'package:chatapp/home/widgets/user_message_listile.dart';
import 'package:chatapp/messages/pages/message_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chatapp/messages/controller/controller_chat.dart';

class LastMessageList extends ConsumerStatefulWidget {
  const LastMessageList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LastMessageListState();
}

class _LastMessageListState extends ConsumerState<LastMessageList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<dynamic>>(
        stream: ref.watch(chatControllerProvider).getAllLastMessageList(),
        builder: (_, snapshot) {
          if (snapshot.connectionState != ConnectionState.active) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
          if (snapshot.hasData) {
            if(snapshot.data!.length==0)
            {
    return ErrorPage(url_image:'assets/images/chat_no_found.png',texte:'Veuillez créer une nouvelle discussion ');
           
            }else
            return ListView.builder(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final data = snapshot.data![index];
                final lastMessageData = data['last'];
                return UserMessageListile(
                    nouveau:data['nouveau'],
                    user: data['user'], lastMessage: lastMessageData);
              },
            );
          } else {
            return ErrorPage(url_image:'assets/images/chat_no_found.png',texte:'Vous n\'avez effectué(e) aucun appel ');
             
          }
        },
      ),
    );
  }
}
