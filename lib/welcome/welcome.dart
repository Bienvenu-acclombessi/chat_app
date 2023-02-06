import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/service/wrapper.dart';

class Description extends StatefulWidget {
  const Description({super.key});

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff5E2B9F),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage("assets/images/logo_description 9.jpg"),
            width: 200,
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(children: [
                  TextSpan(text: "Avec "),
                  TextSpan(
                      text: "ChatApp ",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  TextSpan(
                      text:
                          "discuter avec vos proches n'a jamais été aussi facile")
                ])),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(CupertinoPageRoute(
                    builder: (context) => const Wrapper()));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Text(
                "Démarrer",
                style: TextStyle(color: Color(0xff5E2B9F)),
              ))
        ],
      ),
    );
  }
}
