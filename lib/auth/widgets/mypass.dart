import 'package:flutter/material.dart';

class PassTextFField extends StatelessWidget {
   PassTextFField(
      {super.key,
      required this.obsText,
      required this.validator,
      required this.name,
      required this.onTap,
      required this.controller
      });

  final bool obsText;
  final String? Function(String?) validator;
   TextEditingController controller = TextEditingController();
  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obsText,
      decoration: InputDecoration(
          hintText: name,
          suffixIcon: GestureDetector(
            onTap: onTap,
            child: Icon(
              obsText ? Icons.visibility : Icons.visibility_off,
              color: Colors.black,
            ),
          ),
          hintStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(width: 2.0, color: Color(0xff5E2B9F)),
              borderRadius: BorderRadius.circular(10))),
      validator: validator,
    );
  }
}
