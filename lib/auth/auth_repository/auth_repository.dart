import 'package:chatapp/commun/models/userModel.dart';
import 'package:chatapp/service/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final userconnect = StreamProvider((ref) => AuthService().user);

class AuthService {
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
          SnackBar(content: Text('No user found for that mail')),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mot de passe incorect')),
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
}
