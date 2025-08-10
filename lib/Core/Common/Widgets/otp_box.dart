import 'package:flutter/material.dart';

class OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final int index;
  final List<TextEditingController> allControllers;

  const OtpBox({
    super.key,
    required this.controller,
    required this.index,
    required this.allControllers,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),

        // Move focus on type / backspace
        onChanged: (value) {
          if (value.isNotEmpty) {
            // Move to next field if exists
            if (index + 1 < allControllers.length) {
              FocusScope.of(context).nextFocus();
            } else {
              FocusScope.of(context).unfocus();
            }
          } else {
            // Move to previous field if exists
            if (index > 0) {
              FocusScope.of(context).previousFocus();
            }
          }
        },
      ),
    );
  }
}
