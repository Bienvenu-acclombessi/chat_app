import 'package:chatapp/auth/pages/register2.dart';
import 'package:chatapp/commun/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../auth_repository/auth_repository.dart';
import '../widgets/clippath.dart';
import '../widgets/field.dart';

class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  
  final keyForm = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool obsText = true;
  TextInputType? ktype;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SafeArea(
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
                child: Column(
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      "ChatApp",
                      style: TextStyle(
                          fontSize: 35.sp,
                          fontWeight: FontWeight.bold,
                          color: white),
                    ),
                    SizedBox(
                      height: 60.h,
                    ),
                    SizedBox(
                        height: 400.h,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Form(
                            key: keyForm,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 10.h),
                                  child: Text(
                                    "Connexion",
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
                                  nameController: emailController,
                                  ktype: TextInputType.emailAddress,
                                  icon: Icons.mail,
                                  hint: "Email",
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 10),
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
                                  height: 17.h,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            "Mot de passe oublié ?",
                                            style: TextStyle(
                                                fontSize: 13.h,
                                                fontWeight: FontWeight.w400,
                                                color: dark),
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 100.h,
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(left: 10, right: 10),
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () async{
                                        if (keyForm.currentState!.validate()) {
                                                await AuthService().signIn(
                                                    emailController.text,
                                                    passController.text,
                                                    context);
                                              }
                                           },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(all),
                                      ),
                                      child: const Text("Connexion")),
                                )
                              ],
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Vous n'avez pas de compte ?",
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: dark),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                              onPressed: () {
                           Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                const  Inscription()));
                              },
                              child: Text(
                                "Inscrivez-vous",
                                style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold,
                                    color: all),
                              )),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ],
    ));
  }
}
