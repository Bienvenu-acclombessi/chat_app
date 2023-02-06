import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logiques/suivre_call.dart';

class CallLauncher extends ConsumerStatefulWidget {
  const CallLauncher({super.key});

  @override
  ConsumerState<CallLauncher> createState() => _CallLauncherState();
}

class _CallLauncherState extends ConsumerState<CallLauncher> {

addAppel(){
  ref.read(chatAppelProvider).addCall('id_room', FirebaseAuth.instance.currentUser!.uid, 'video');
}
 
@override
  void initState() {
    // TODO: implement initState
    addAppel(){
  ref.read(chatAppelProvider).addCall('id_room', FirebaseAuth.instance.currentUser!.uid, 'video');
}
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}