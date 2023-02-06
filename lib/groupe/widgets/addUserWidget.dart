import 'dart:io';

import 'package:chatapp/groupe/service/database_service.dart';
import 'package:chatapp/messages/controller/controller_chat.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../commun/models/userModel.dart';

class AddUserWidget extends ConsumerStatefulWidget {
  String groupId;
  AddUserWidget({super.key, required this.groupId});

  @override
  ConsumerState<AddUserWidget> createState() => _AddUserWidgetState();
}

class _AddUserWidgetState extends ConsumerState<AddUserWidget> {
  List<String> members=[];
   List<UserModel> membersView=[];
   addOrRemove(UserModel user){
    if(members.contains(user.uid)){
                     setState((){
                        members.remove(user.uid);
                        membersView.remove(user);
                        print(membersView);
                      });
                      }else{
                         setState((){
                        members.add(user.uid);
                        membersView.add(user);
                      });
                      }
   }
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.zero,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.8,
          margin: const EdgeInsets.all(0.0),
          child: SingleChildScrollView(
              child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 3,horizontal: 3),
                height: 60,
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                child:  ListView.builder(
                      scrollDirection : Axis.horizontal,
                      itemCount: membersView.length,
                      itemBuilder: (context,index){
                        final cUser=membersView[index];
                        return GestureDetector(
                          onTap: (){
                           addOrRemove(cUser);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: CircleAvatar(
                              backgroundImage: userImage(cUser.profileImageUrl!),
                            ),
                          ),
                        );
                      } )
                  
              ),
              SizedBox(
                height: 10,
              ),
              Text('Choisissez les contacts'),
              SizedBox(
                height: 10,
              ),
              ContactList()
            ],
          )),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: Colors.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Wrap(
                children: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('ANNULLER',)),
                 members.isNotEmpty ? ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
                      onPressed: () => onSubmit(context, members,widget.groupId),
                      child: const Text('AJOUTER')): SizedBox()
                ],
              )
            ],
          ),
        )
      ],
    );
  }

//Image choose
  ImageProvider<Object>? userImage(String url) {
    if (url.isNotEmpty) {
      return NetworkImage(url);
    } else {
      return const AssetImage('assets/images/userImage.png');
    }
  }

//Contact liste
  ContactList() {
      return StreamBuilder<List<dynamic>>(
        stream: ref.watch(chatControllerProvider).getAllContactsNoGroup(widget.groupId),
        builder: (_, snapshot) {
          if (snapshot.connectionState != ConnectionState.active) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data!.length > 0) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final data = snapshot.data![index];
                  return ListTile(
                    selectedColor: Theme.of(context).primaryColor.withOpacity(0.6),
                    selected: members.contains(data!.uid),
                    onTap: (){
                      if(!members.contains(data!.uid)){
                      setState((){
                        members.add(data!.uid);
                        membersView.add(data!);
                      });
                      }
                    },
                    
                    leading: CircleAvatar(
                      backgroundImage: userImage(data!.profileImageUrl!),
                    ),
                    title: Text('${data.prenom} ${data.nom}'),
                    trailing: members.contains(data!.uid) ? IconButton(onPressed: (){
                      
                    }, icon: Icon(Icons.check_box_sharp,color: Theme.of(context).primaryColor),) : SizedBox(),
                  );
                },
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Center(
                      child: Text('Vous n\'avez aucun contact disponible pour ce groupe',textAlign: TextAlign.center,),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Center(
                      child: Text('Veuillez ajouter des amis '),
                    ),
                  ),
                ],
              );
            }
          } else {
            return Center(
              child: Text("Veuillez attendre"),
            );
          }
        },
      );
  }

  void onSubmit(context, List members,groupId) async {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Row(
        children: [
          const Expanded(child: Text('Envoie en cours')),
          const CircularProgressIndicator(
            color: Colors.white,
          )
        ],
      )),
    );
   await DatabaseService().addUserToGroup(groupId, members);
  }
}

class AddUserDialog {
  String groupId;
  AddUserDialog({required this.groupId});

  //Pour visualiser la boite des dialogues

  void showAddUserDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddUserWidget(groupId: groupId);
        });
  }
}
