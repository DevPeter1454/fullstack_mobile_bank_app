import 'package:flutter/material.dart';

var textField = (
  controller,
  label,
) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: 'Enter your $label',
      labelStyle: const TextStyle(
        color: MyColors.colorA,
        fontSize: 15,
      ),
      // filled: true,
      // fillColor: Colors.white,
    ),
  );
};

class MyColors {
  static const Color colorA = Color(0XFF3F3D56);
  static const Color colorB = Color(0XFFEA251F);
  static const Color colorC = Color(0XFFD4C8C8);
  static const Color colorD = Color.fromARGB(255, 247, 246, 246);
}
