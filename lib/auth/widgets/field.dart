import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chatapp/commun/colors/colors.dart';

class Field extends StatelessWidget {
  const Field({
    Key? key,
    required this.nameController,
    required this.ktype,
    required this.icon,
    this.hint,
    this.validator,
  }) : super(key: key);

  final TextEditingController nameController;
  final TextInputType? ktype;
  final IconData icon;
  final String? hint;
  final validator;

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextFormField(
            controller: nameController,
            cursorColor: primary,
            keyboardType: ktype,
            validator:validator,
            decoration: InputDecoration(
              
                border: InputBorder.none,
                suffixIcon: Icon(icon),
                hintText: hint),
          ),
        ),
      ),
    ));
  }
}
