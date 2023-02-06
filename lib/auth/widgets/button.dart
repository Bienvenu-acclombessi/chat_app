import 'package:flutter/material.dart';

class MyButtons extends StatelessWidget {
  const MyButtons({super.key, required this.onPressed, required this.name});

  final VoidCallback onPressed;
  final String name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: double.infinity,
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(const Color(0xff5E2B9F)),
          ),
          onPressed: onPressed,
          child: Text(name)),
    );
  }
}
