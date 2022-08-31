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
        color: Color(0XFF2C7AE2),
        fontSize: 15,
      ),
    ),
  );
};
