import 'package:chatapp/auth/auth_repository/auth_repository.dart';
import 'package:chatapp/commun/colors/colors.dart';
import 'package:chatapp/commun/models/userModel.dart';
import 'package:chatapp/home/widgets/changeImageDialogue.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'profil.dart';

class MorePage extends ConsumerStatefulWidget {
  const MorePage({super.key});

  @override
  ConsumerState<MorePage> createState() => _MorePageState();
}

class _MorePageState extends ConsumerState<MorePage> {
 final currentUser =FirebaseAuth.instance.currentUser;
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
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      
        title: Text(
          "Profil",
          style: Theme.of(context).textTheme.headline5,
        ),
        centerTitle: true,
        actions: [
          // IconButton(
          //     onPressed: () {},
          //     icon: Icon(
          //       isDark ? Icons.sun : Icons.moon,
          //       color: isDark ? white : black,
          //     ))
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: StreamBuilder<UserModel>(
        stream: ref.watch(authProvider).getUser(uid:currentUser!.uid),
        builder: (_, snapshot) {
          if ( snapshot.connectionState != ConnectionState.active) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
            if (snapshot.hasData ) {
        return  Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child:  Image(
                            image: userImage(snapshot.data!.profileImageUrl!)! )),
                  ),
                  Positioned(
                      bottom: 0,
                      right: -10,
                         
                      child: TextButton(
                        onPressed: (){
    ChangeImageDialogue(user: currentUser,ref: ref).showImageMessageDialog(context, ImageSource.gallery);
                   
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(100),
                              color: all.withOpacity(0.8)
                              ),
                          child: Icon(
                               Icons.update,
                                color: white,
                              ),
                        ),
                      ))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${snapshot.data!.prenom} ${snapshot.data!.nom}",
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                snapshot.data!.email,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200.w,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => const UpdateProfil()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: all,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text("Modifier Profil"),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(),
              const SizedBox(
                height: 20,
              ),
              ProfilMenuWidget(
                  title: "Setting",
                  icon: Icons.settings,
                  onPress: () {},
                  endIcon: true),
              ProfilMenuWidget(
                  title: "About",
                  icon: Icons.link,
                  onPress: () {},
                  endIcon: true),
              ProfilMenuWidget(
                  title: "Notifications",
                  icon: Icons.notifications,
                  onPress: () {},
                  endIcon: true),
              ProfilMenuWidget(
                  title: "Help",
                  icon: Icons.info,
                  onPress: () {},
                  endIcon: true),
              ProfilMenuWidget(
                  title: "Privacy Politics",
                  icon: Icons.privacy_tip,
                  onPress: () {},
                  endIcon: true),
              ProfilMenuWidget(
                title: "Se deconnecter",
                icon: Icons.logout,
                onPress: () async{
                await  FirebaseAuth.instance.signOut();
                },
                endIcon: false,
                textColor: all,
              )
            ],
          );
            }else{
              return Center(
                child: Text('Une erreur est produite'),
              );
            }
            
            })
            
          ),
        ),
      ),
    );
  }
}

class ProfilMenuWidget extends StatelessWidget {
  const ProfilMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    required this.endIcon,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: purple.withOpacity(0.2)),
        child: Icon(
          icon,
          color: all,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1?.apply(color: textColor),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey.withOpacity(0.2)),
              child: const Icon(
                Icons.backspace,
                color: Colors.grey,
              ),
            )
          : null,
    );
  }
}
