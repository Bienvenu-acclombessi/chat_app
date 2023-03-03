import 'package:chatapp/appel/logiques/suivre_call.dart';
import 'package:chatapp/appel/pages/CallAccept/accept_call_page.dart';
import 'package:chatapp/auth/auth_repository/auth_repository.dart';
import 'package:chatapp/auth/pages/login2.dart';
import 'package:chatapp/commun/models/userModel.dart';
import 'package:chatapp/home/pages/route_app.dart';
import 'package:chatapp/messages/controller/controller_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Wrapper extends ConsumerWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final user = Provider.of<User?>(context);
    final _user = ref.watch(userconnect);
    if (_user.value != null) {
    ref.watch(chatAppelProvider).getNewCall(context);}
    if (_user.value == null) {
      return const Connexion();
    } else {
      return RootApp();
    }
  }
}
