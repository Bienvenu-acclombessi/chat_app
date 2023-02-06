import 'package:chatapp/commun/models/groupModel.dart';
import 'package:chatapp/commun/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final groupRepositoryProvider = Provider((ref) {
  return DatabaseService();
});
class DatabaseService {
  DatabaseService();

  // reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");
final  uid=FirebaseAuth.instance.currentUser!.uid;
  

  // getting user data


  // get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  // creating a group
  Future createGroup(String id, String groupName,List<dynamic> members) async {
    final GroupModel groupe= GroupModel(
      groupName:groupName,
      groupIcon: "",
      admin: uid,
      members: [],
      groupId: "",
      recentMessage: "",
      recentMessageSender: ""
       );
       if(members.isNotEmpty){
    DocumentReference groupDocumentReference = await groupCollection.add(groupe.toMap());
    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(members),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion([groupDocumentReference.id])
    });
       }else{
     
       }
  }
  addUserToGroup(groupId,List members)async{
   await groupCollection.doc(groupId).update(
    {
      "members": FieldValue.arrayUnion(members)
    }
   );
   for(var userId in members){
    await userCollection.doc(userId).update({
      "groups":
          FieldValue.arrayUnion([groupId])
    });
   }
  }

  // getting the chats
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future<UserModel> getGroupAdmin(String groupId) async {
    DocumentSnapshot documentSnapshot  =await groupCollection.doc(groupId).get();
    final userSnapshot= await FirebaseFirestore.instance.collection('users').doc(documentSnapshot['admin']).get();
    final user=UserModel.fromMap(userSnapshot.data()!);
    return user;
  }

  // get group members
  getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }
//Obtenir les membres du groupe
   Stream<List<dynamic>> getAllMembers(groupId) {
   return groupCollection
        .doc(groupId)
        .snapshots()
        .asyncMap((event) async {
      List<dynamic> contacts = [];
      for (var document in event.get('members')) {
        final userData = await FirebaseFirestore.instance.collection('users').doc(document)
            .get();
        final user = UserModel.fromMap(userData.data()!);
        contacts.add(user);
      }
      return contacts;
    });
   }

   //Obtenir ses groupes
    Stream<List<dynamic>> getMygroups() {
   return FirebaseFirestore.instance.collection('users')
        .doc(uid)
        .snapshots()
        .asyncMap((event) async {
      List<dynamic> contacts = [];
      for (var document in event.get('groups')) {
        final groupData = await FirebaseFirestore.instance.collection('groups').doc(document)
            .get();
            if(groupData.data()!=null){

        final group= GroupModel.fromMap(groupData.data()!);
        contacts.add(group);

            }      }
      return contacts;
    });
   }

  // search
  searchByName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  // function -> bool
  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  // toggling the group join/exit
  Future toggleGroupJoin(String groupId) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join
    if (groups.contains(groupId)) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove([groupId])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove([uid])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion([groupId])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion([uid])
      });
    }
  }

  // send message
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }
}
