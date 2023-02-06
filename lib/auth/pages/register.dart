import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth_repository/auth_repository.dart';
import '../widgets/button.dart';
import '../widgets/changescreen.dart';
import '../widgets/clip.dart';
import '../widgets/mypass.dart';
import '../widgets/textffield.dart';
import '../widgets/utils.dart';
import 'login.dart';

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final keyForm = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final fnameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool obsText = true;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        width: width,
        height: height,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Stack(
            children: [
              ClipPath(
                clipper: Clipper(),
                child: clipping(width, height / 1.7 + 50, height / 10),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 20.0, right: 20.0, top: height / 5),
                height: height / 1.8,
                child: Card(
                    color: Colors.white,
                    child: SizedBox(
                      width: width,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            child: Text(
                              "Inscription",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Form(
                              key: keyForm,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: MyTextfField(
                                        controller: nameController,
                                        validator: (value) =>
                                            validatioName(value!),
                                        name: "Nom",
                                        kboardtype: TextInputType.name),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: MyTextfField(
                                        controller: fnameController,
                                        validator: (value) =>
                                            validatioFname(value!),
                                        name: "Prenom",
                                        kboardtype: TextInputType.name),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: MyTextfField(
                                        controller: emailController,
                                        validator: (value) =>
                                            validatioEmail(value!),
                                        name: "Email",
                                        kboardtype: TextInputType.name),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: PassTextFField(
                                      controller: passController,
                                      obsText: obsText,
                                      validator: (value) =>
                                          validationPass(value!),
                                      name: "PassWord",
                                      onTap: () {
                                        setState(() {
                                          obsText = !obsText;
                                          FocusScope.of(context).unfocus();
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  MyButtons(
                                      onPressed: () async {
                                        if (keyForm.currentState!.validate()) {
                                     await AuthService().signUp(
                                              email: emailController.text,
                                              password: passController.text,
                                              nom: nameController.text,
                                              prenom: fnameController.text,
                                              context: context);
                                        }
                                      },
                                      name: "Inscription")
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
              ),
              Container(
                margin: EdgeInsets.only(top: height / 1.2),
                child: ChangeScrens(
                    name: "Login",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>const Connexion()));
                    },
                    whichAccount: "Vous avez déjà un conpte"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
