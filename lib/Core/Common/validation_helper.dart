import '../Constants/app_strings.dart';

class ValidationHelper {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return ValidationMessages.emptyEmail;
    }
    const emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    if (!RegExp(emailPattern).hasMatch(email)) {
      return ValidationMessages.invalidEmail;
    }
    return null;
  }

  static String? validateEmptyEmail(String? email) {
    if (email == null || email.isEmpty) {
      return ValidationMessages.emptyEmail;
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return ValidationMessages.emptyPassword;
    }
    if (password.length < 8) {
      return ValidationMessages.shortPassword;
    }
    return null;
  }

  static String? validateConfirmPassword(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return ValidationMessages.emptyConfirmPassword;
    }
    if (password != confirmPassword) {
      return ValidationMessages.passwordMismatch;
    }
    return null;
  }

  static String? validateNonEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "$fieldName cannot be empty";
    }
    return null;
  }

  static String? validateName(String? name, String fieldName) {
    if (name == null || name.isEmpty) {
      return "$fieldName require*";
    }
    if (name.length < 2) {
      return "$fieldName must be at least 2 characters long";
    }
    return null;
  }
}
