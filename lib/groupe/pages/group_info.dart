import 'package:chatapp/commun/models/groupModel.dart';
import 'package:chatapp/groupe/widgets/addUserWidget.dart';
import 'package:chatapp/service/wrapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../commun/models/userModel.dart';
import '../pages/home_page.dart';
import '../service/database_service.dart';
import '../widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInfo extends StatefulWidget {
  final GroupModel group;
  const GroupInfo(
      {Key? key,
      required this.group})
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  UserModel? admin;
  
  bool loadAdmin=false;
  @override
  void initState() {
    adminList();
    super.initState();
  }
ImageProvider<Object>? userImage(String url){
    if(url.isNotEmpty)
    {
      return NetworkImage(url) ;
    }else{
      return const AssetImage('assets/images/userImage.png') ;
    }
  }
 adminList() async{
    admin= await DatabaseService().getGroupAdmin(widget.group.groupId);
    if(admin!.uid.isNotEmpty){
      setState(() {
        loadAdmin=true;
      });
    }
      }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("${widget.group.groupName}"),
        actions: [
          IconButton(
              onPressed: () {
              
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).primaryColor.withOpacity(0.2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        widget.group.groupName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    
                  ],
                ),
              ),
           widget.group.admin==FirebaseAuth.instance.currentUser!.uid ?   Container(
                    child: ListTile(

                 leading: Icon(Icons.add,color: Theme.of(context).primaryColor,),  
                 title: Text('Ajouter un contact'),
                 onTap: () {
                   AddUserDialog(groupId: widget.group.groupId).showAddUserDialog(context);
                 },     ),
              ) : SizedBox(),
              Container(
                    child: ListTile(
                 leading: Icon(Icons.exit_to_app_sharp,color: Colors.red,),  
                 title: Text('Quitter le groupe'),     
                 onTap: () {
                     showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Exit"),
                        content:
                            const Text("T es sur de quitter "),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              DatabaseService()
                                  .toggleGroupJoin(
                                      widget.group.groupId)
                                  .whenComplete(() {
                                nextScreenReplace(context, const Wrapper());
                              });
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      );
                    });
                 },
                    ),
              ),
              SizedBox(height: 10,),
               Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).primaryColor.withOpacity(0.2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   Text('Administrateur')
                  ],
                ),
              ),
              SizedBox(height: 5,),
              loadAdmin ? ListTile(
                 leading: CircleAvatar(
              backgroundImage: userImage(admin!.profileImageUrl!),
              
                 ),
                 title: Row(children: [Expanded(child: Text('${admin!.prenom} ${admin!.nom}'))],),
              ) : Text('Aucun administrateur'),
              SizedBox(height: 12,),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).primaryColor.withOpacity(0.2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   Text('Tous les membres')
                  ],
                ),
              ),
               memberList(),
            ],
          ),
        ),
      ),
    );
  }



  memberList() {
    return Consumer(builder: (context,WidgetRef ref, child){

    return StreamBuilder(
      stream: ref.watch(groupRepositoryProvider).getAllMembers(widget.group.groupId),
      builder: (context, AsyncSnapshot snapshot){
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            if (snapshot.data.length != 0) {
             
              return ListView.builder(
                itemCount: snapshot.data.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final user=snapshot.data[index];
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: userImage(user!.profileImageUrl!),
                    
                      ),
                      title: Text('${user.prenom} ${user.nom}'),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("NO MEMBERS"),
              );
            }
          } else {
            return const Center(
              child: Text("NO MEMBERS"),
            );
          }
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ));
        }
      },
    );

    });  }

    //administrateur
     

}
