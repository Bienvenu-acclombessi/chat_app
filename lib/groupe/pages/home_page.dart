import 'package:chatapp/commun/colors/colors.dart';
import 'package:chatapp/commun/models/groupModel.dart';
import 'package:chatapp/groupe/pages/search_group.dart';
import 'package:chatapp/service/wrapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../auth/auth_repository/auth_repository.dart';
import '../pages/profile_page.dart';
import '../pages/search_page.dart';
import '../service/database_service.dart';
import '../widgets/group_tile.dart';
import '../widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeGroup extends StatefulWidget {
  const HomeGroup({Key? key}) : super(key: key);

  @override
  State<HomeGroup> createState() => _HomeGroupState();
}

class _HomeGroupState extends State<HomeGroup> {
  String userName = "";
  String email = "";
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";
  List<GroupModel> groupes=[];

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  // string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    
    // getting the list of snapshots in our stream
    await DatabaseService()
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
          elevation: 0.0,
          backgroundColor: white,
          title: Text(
            "Groupes",
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
                    onPressed: () {
                      Navigator.push(
                        context, MaterialPageRoute(builder: (context)=>SearchGroupPage(data: groupes,))
                      );
                    },
                    icon: const Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: white,
                    )))
          ],
        ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                "Créer un nouveau groupe",
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor),
                        )
                      : TextField(
                          onChanged: (val) {
                            setState(() {
                              groupName = val;
                            });
                          },
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Nom du groupe',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),)),
                        ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  child: const Text("ANNULER"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final List<dynamic> members=[FirebaseAuth.instance.currentUser!.uid];
                    if (groupName != "") {
                      setState(() {
                        _isLoading = true;
                      });
                      DatabaseService()
                          .createGroup(FirebaseAuth.instance.currentUser!.uid, groupName,members)
                          .whenComplete(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                      showSnackbar(
                          context, Colors.green, "Group created successfully.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  child: const Text("CREER"),
                )
              ],
            );
          }));
        });
  }

  groupList() {
   return Consumer(
      builder: (context, ref, child) { 
    return StreamBuilder(
      stream: ref.watch(groupRepositoryProvider).getMygroups(),
      builder: (context, AsyncSnapshot snapshot) {
        // make some checks
        
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text("Chargement de vos groupes", style: TextStyle(color: Colors.black)),
                    ),
                    CircularProgressIndicator(
                      color: Colors.black
                    )
                  ],
                );
            }
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            if (snapshot.data.length != 0) {
              return ListView.builder(
                itemCount: snapshot.data.length!,
                itemBuilder: (context, index) {
                  
                  int reverseIndex = snapshot.data.length - index - 1;
                  final group=snapshot.data[index];
                  groupes.add(group);
                  return GroupTile(group: group);
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          
            return noGroupWidget();
        }
      },
    );
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                popUpDialog(context);
              },
              child: Icon(
                Icons.add_circle,
                color: Colors.grey[700],
                size: 75,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Vous n'êtes dans aucun groupe.",
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
