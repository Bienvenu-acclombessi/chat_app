
import 'package:chatapp/auth/auth_repository/auth_repository.dart';
import 'package:chatapp/commun/colors/colors.dart';
import '../widgets/clippath.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/field.dart';

import '../widgets/utils.dart';

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final keyForm = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final othernameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool obsText = true;
  TextInputType? ktype;
  bool isLoading = false;
  signUp() async {
    setState(() {
      isLoading = true;
    });
    try {
      await AuthService().signUp(
                                                email: emailController.text,
                                                password: passController.text,
                                                nom: nameController.text,
                                                prenom: othernameController.text,
                                                context: context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mot de passe trop petit.')),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cet email existe deja')),
        );
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          SizedBox(
            height: size.height,
          ),
          const CPath(),
          Positioned(
              left: 30.w,
              right: 30.w,
              child: SizedBox(
                height: size.height,
                child: SingleChildScrollView(
                  child: Form(
                    key: keyForm,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40.h,
                        ),
                        Text(
                          "ChatApp",
                          style: TextStyle(
                              fontSize: 35.sp,
                              fontWeight: FontWeight.bold,
                              color: white),
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        SizedBox(
                            height: 400.h,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.h),
                                    child: Text(
                                      "Inscription",
                                      style: TextStyle(
                                          fontSize: 25.sp,
                                          fontWeight: FontWeight.bold,
                                          color: dark),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Field(
                                    nameController: nameController,
                                    ktype: TextInputType.name,
                                    icon: Icons.person,
                                    hint: "Nom",
                                     validator: (value) =>
                                            validatioName(value!),
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Field(
                                    nameController: othernameController,
                                    ktype: TextInputType.name,
                                    icon: Icons.person,
                                    hint: "Prénom",
                                     validator: (value) =>
                                            validatioFname(value!)
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Field(
                                    nameController: emailController,
                                    ktype: TextInputType.emailAddress,
                                    icon: Icons.mail,
                                    hint: "Email",
                                        validator: (value) =>
                                            validatioEmail(value!),
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Container(
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: TextFormField(
                                          controller: passController,
                                          keyboardType: TextInputType.text,
                                          obscureText: obsText,
                                           validator: (value) =>
                                          validationPass(value!),
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              suffixIcon: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      obsText = !obsText;
                                                    });
                                                  },
                                                  child: Icon(obsText
                                                      ? Icons.visibility
                                                      : Icons.visibility_off)),
                                              hintText: "Mot de passe"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25.h,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          if (!isLoading &&
                                            keyForm.currentState!.validate()) {
                                          await signUp();
                                        }
                  
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(all),
                                        ),
                                        child: isLoading
                                          ? SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 3,
                                              ))
                                          : Text("Inscription")),
                                  )
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                "Vous avez déjà un compte ?",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: dark),
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                  onPressed: () {
                                   Navigator.pop(context);
                                    },
                                  child: const Text(
                                    "Connectez-vous",
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: all),
                                  )),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ],
      )),
    );
  }
}
