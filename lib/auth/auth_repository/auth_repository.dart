import 'package:chatapp/commun/models/userModel.dart';
import 'package:chatapp/service/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final userconnect = StreamProvider((ref) => AuthService().user);
final authProvider= Provider((ref) => AuthService());
class AuthService {
  
   FirebaseStorage _storage= FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> signUp({
    required String email,
    required String password,
    required String nom,
    required String prenom,
    required context
  }) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
 final user=UserModel(nom: nom, prenom: prenom, email: email, uid: value.user!.uid, active: true, lastSeen: DateTime.now().millisecondsSinceEpoch);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(value.user!.uid)
            .set(user.toMap()).then((add_success) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Wrapper()));
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The password provided is too weak.')),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cet email existe deja')),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signIn(String emailAddress, String password, context) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: emailAddress, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('No user found for that mail',style: TextStyle(color:Colors.white),)),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Mot de passe incorect',style: TextStyle(color:Colors.white),)),
        );
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> get user => _auth.authStateChanges();
  bool userp() {
    if (user == null) {
      return false;
    } else {
      return true;
    }
  }



Stream<UserModel> getUser({required String uid}) {
  return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
}
  Stream<UserModel> getUserPresenceStatus({required String uid}) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }


  //La presence de l'utilisateur
  
  void updateUserPresence() {
    Map<String, dynamic> online = {
      'active': true,
      'lastSeen': DateTime.now().millisecondsSinceEpoch,
    };
    Map<String, dynamic> offline = {
      'active': false,
      'lastSeen': DateTime.now().millisecondsSinceEpoch,
    };

    final connectedCollection = FirebaseFirestore.instance.collection('connected');

  }
  Future<String> uploadFile(file) async{
    Reference reference=_storage.ref().child('imageProfil/${DateTime.now()}.png');
 UploadTask uploadTask= reference.putFile(file);
 TaskSnapshot taskSnapshot=await uploadTask;
 return await taskSnapshot.ref.getDownloadURL();
  }
  updatePhotoProfile({ required String uid, required String  link})async{
  await  FirebaseFirestore.instance.collection('users').doc(uid).update({
        "profileImageUrl": link
    });
  }
   updateProfile({required context, required String uid, required String  nom,required String  prenom,required String  email})async{
  await  FirebaseFirestore.instance.collection('users').doc(uid).update({
        "nom": nom,
        "prenom": prenom,
        "email" : email
    }).then((value) {
ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text('Mise à jour effectuer avce succès',style: TextStyle(color:Colors.white),)),
        );
    }).catchError((){
ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Une erreur s\'est produite ',style: TextStyle(color:Colors.white),)),
        );
    });
    
  }
     updatePassword({  required context,required String  nouveauPassword})async{
  await  FirebaseAuth.instance.currentUser!.updatePassword(nouveauPassword).then((value) {
ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text('Mise à jour effectuer avce succès',style: TextStyle(color:Colors.white),)),
        );
    }).catchError((){
ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Une erreur s\'est produite ',style: TextStyle(color:Colors.white),)),
        );
    });
    ;
  }
}
