import 'package:chatapp/appel/pages/CallAccept/accept_call_page.dart';
import 'package:chatapp/messages/pages/message_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../messages/controller/controller_chat.dart';
import '../widgets/header.dart';
import 'people.dart';

class CallList extends ConsumerStatefulWidget {
  const CallList({super.key});

  @override
  ConsumerState<CallList> createState() => _CallListState();
}

class _CallListState extends ConsumerState<CallList> {

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
          title: Text('Appels'),
          backgroundColor: Color(0xff5E2B9F),
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
                Expanded(
                  child: StreamBuilder<List<dynamic>>(
        stream: ref.watch(chatControllerProvider).getAllAppels(),
        builder: (_, snapshot) {
          if ( snapshot.connectionState != ConnectionState.active) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
            if(snapshot.hasData){
              if(snapshot.data!.length>0){

              
          return   ListView.builder(
            itemCount: snapshot.data!.length ,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final data = snapshot.data![index];
              return ListTile(
                
                leading: CircleAvatar(
              backgroundImage: userImage(data['user'].profileImageUrl!) ,
            ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${data['user'].prenom} ${data['user'].nom}'),
                    // Text(
                    //   DateFormat.Hm().format(lastMessageData.timeSent),
                    //   style: TextStyle(
                    //     fontSize: 13,
                    //     color: context.theme.greyColor,
                    //   ),
                    // ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    'Appel',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                
              );
            },
          );
              }else{
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Center(
                        child: Text('Aucun appel effectué'),
                      ),
                    )
                  ],
                );
              }  }
            else{
          return Center(child: Text("Veuillez attendre"),);
        }
        },
      ),
                 )
                
              ],
            ),
          )),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff5E2B9F),
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
