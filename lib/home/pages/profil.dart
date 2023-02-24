import 'package:chatapp/auth/auth_repository/auth_repository.dart';
import 'package:chatapp/auth/widgets/utils.dart';
import 'package:chatapp/commun/colors/colors.dart';
import 'package:chatapp/commun/models/userModel.dart';
import 'package:chatapp/home/widgets/changeImageDialogue.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfil extends ConsumerStatefulWidget {
  const UpdateProfil({super.key});

  @override
  ConsumerState<UpdateProfil> createState() => _UpdateProfilState();
}

class _UpdateProfilState extends ConsumerState<UpdateProfil> {
  final keyForm = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final fNameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        // leading: IconButton(
        //     onPressed: () => Navigator.pop(context),
        //     icon: const Icon(
        //       Icons.backspace,
        //       color: black,
        //     )),
        title: Text(
          "Modifier mon profil",
          style: Theme.of(context).textTheme.headline5,
        ),
        centerTitle: true,
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
              nameController.text=snapshot.data!.nom;
             fNameController.text=snapshot.data!.prenom;
             emailController.text=snapshot.data!.email;
           return Column(
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
                  height: 50,
                ),
                Form(
                  key:keyForm,
                    child: Column(
                  children: [
                    ProfilField(
                      nameController: nameController,
                      kbt: TextInputType.text,
                      icon: Icons.person,
                      hText: 'Change your name',
                      label: 'Nom',
                      validator: (value) =>
                                            validatioName(value!),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ProfilField(
                      nameController: fNameController,
                      kbt: TextInputType.text,
                      icon:Icons.person,
                      hText: 'Change your first name',
                      label: 'Prenom',
                       validator: (value) =>
                                            validatioFname(value!)
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ProfilField(
                      nameController: emailController,
                      kbt: TextInputType.text,
                      icon: Icons.mail,
                      hText: 'Change your email',
                      label: 'email',
                       validator: (value) =>
                                            validatioEmail(value!),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async{
                           if (keyForm.currentState!.validate()) {
                                       await AuthService().updateProfile(
                                        uid: snapshot.data!.uid,
                                                email: emailController.text,
                                                nom: nameController.text,
                                                prenom: fNameController.text,
                                                context: context);
                                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: all,
                            foregroundColor: white,
                            shape: const StadiumBorder()),
                        child: Text(
                          "Modifier",
                          style: TextStyle(
                              fontSize: 20.r, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ))
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

class ProfilField extends StatelessWidget {
  const ProfilField({
    Key? key,
    required this.nameController,
    required this.kbt,
    required this.icon,
    required this.hText,
    required this.label,
    required this.validator
  }) : super(key: key);

  final TextEditingController nameController;
  final TextInputType kbt;
  final IconData icon;
  final String hText;
  final String label;
  final validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,
      keyboardType: kbt,
      validator:validator,
      decoration: InputDecoration(
        label: Text(label),
        labelStyle: const TextStyle(color: purple),
        hintText: hText,
        suffixIcon: Icon(
          icon,
          color: all,
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: all),
            borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: purple),
            borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
