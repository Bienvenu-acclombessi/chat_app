import 'package:chatapp/auth/pages/password_reset.dart';
import 'package:chatapp/auth/pages/register2.dart';
import 'package:chatapp/commun/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../auth_repository/auth_repository.dart';
import '../widgets/clippath.dart';
import '../widgets/field.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResedPasssword extends StatefulWidget {
  const ResedPasssword({super.key});

  @override
  State<ResedPasssword> createState() => _ResedPassswordState();
}

class _ResedPassswordState extends State<ResedPasssword> {
  final keyForm = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool obsText = true;
  TextInputType? ktype;
  bool isLoading = false;
  signIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);

      Navigator.pop(context);
      //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ResedConfirmationCode()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'auth/invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email invalide')),
        );
      } else if (e.code == 'auth/user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email invalide')),
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
                                    "Mot de passe oublié",
                                    style: TextStyle(
                                        fontSize: 25.sp,
                                        fontWeight: FontWeight.bold,
                                        color: dark),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10.h),
                                  child: Text(
                                    "Vous recevrez un mail sur dans votre boite mail qui vous permettra de changer votre mot de passe",
                                    
                                        textAlign:TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 10.sp,
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
                                SizedBox(
                                  height: 17.h,
                                ),
                                
                                SizedBox(
                                  height: 100.h,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        // if (keyForm.currentState!.validate()) {
                                        //         await AuthService().signIn(
                                        //             emailController.text,
                                        //             passController.text,
                                        //             context);
                                        //       }
                                        if (!isLoading &&
                                            keyForm.currentState!.validate()) {
                                          await signIn();
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
                                          : Text("Envoyez")),
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
                                            const Inscription()));
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
