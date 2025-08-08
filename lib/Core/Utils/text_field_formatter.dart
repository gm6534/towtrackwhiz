import 'package:flutter/services.dart';

class NoLeadingSpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Allow empty text
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove leading space from new value
    if (newValue.text.startsWith(' ')) {
      final trimmedValue = newValue.text.trimLeft();
      return newValue.copyWith(
        text: trimmedValue,
        selection: TextSelection.collapsed(offset: trimmedValue.length),
      );
    }

    return newValue;
  }
}