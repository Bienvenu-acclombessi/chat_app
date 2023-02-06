import 'package:flutter/material.dart';

class ChangeScrens extends StatelessWidget {
  const ChangeScrens(
      {super.key,
      required this.name,
      required this.onTap,
      required this.whichAccount});

  final String name;
  final VoidCallback onTap;
  final String whichAccount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          whichAccount,
          style: const TextStyle(fontSize: 17),
        ),
        const SizedBox(
          width: 15,
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            name,
            style: const TextStyle(
                color: Color(0xff5E2B9F),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
