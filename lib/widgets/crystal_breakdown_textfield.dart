import 'package:flutter/material.dart';

class CrystalBreakdownTextfield extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  const CrystalBreakdownTextfield({
    super.key,
    required this.labelText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: labelText,
        floatingLabelStyle: TextStyle(color: Colors.white),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2.0),
        ),
        border: OutlineInputBorder(),
      ),
    );
  }
}
