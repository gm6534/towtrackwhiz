class AppInfo {
  static const String appTitle = "Cleanly";
}

class GetStorageKeys {
  static const String authInfo = 'authInfo';
  static const String credentials = "credentials";
  static const String languageCode = 'language_code';
  static const String countryCode = 'country_code';
}

class ApiEndPoints {}

class ImgPath {
  static const String assets = "assets/";
  static const String appLogo = "${assets}app_logo.png";
}

class AppHeadings {}
class Strings {
  static const String permissionRequired = "Permission Required";
  static const String openSettings = "Open Settings";
}

class ActionText {
  static const String login = "Login";
  static const String yes = "Yes";
  static const String no = "No";
  static const String cancel = "Cancel";
}

class ToastMsg {
  static const String allowCameraAccess = "Please allow access to the Camera";
  static const String allowGalleryAccess = "Please allow access to the Gallery";
  static const String noInternetConnection = "No Internet Connection";
  static const String required = "* required";
  static const String pleaseWait = "please_wait";
  static const String unknownError =
      "The application has encountered an unknown error. Please check that your device is connected to the internet";
  static const String unableToConnect = "Unable to connect to the internet";
  static const String internalServerError = "Internal server error.";
  static const String internetNotAvailable = "Internet not available";
  static const String someThingWentWrong = "Something went wrong.";
  static const String charactersLimit = "Only 500 characters are allowed.";
  static const String checkNadraRecord =
      "Please wait our system validating your fingerprint from Nadra";
  static const String bioFailed =
      'Biometric verification failed. Please try again.';
  static const String validCNICHint = "Enter Valid CNIC Without (-) Dashes";
  static const String validMobileNoHint = "Enter Valid Mobile Number";
  static const String selectRegionHint = "Select Region";
  static const String validUsernameHint = "Enter Valid Username";
  static const String validPassHint = "Enter Valid Password";
  static const String linkError = "Unable to launch url";
  static const String closeAppConfirmation =
      "Are you sure you would like to close the app?";
}

class ErrorCode {
  static const String connectionAbort = "Software caused connection abort";
  static const String failedHost = "Failed host lookup";
  static const String invalidHtml = "<!DOCTYPE html>";
}

class ValidationMessages {
  static const String emptyEmail = "Email cannot be empty";
  static const String invalidEmail = "Please enter a valid email address";
  static const String emptyPassword = "Password cannot be empty";
  static const String shortPassword =
      "Password must be at least 8 characters long";
  static const String emptyConfirmPassword = "Confirm Password cannot be empty";
  static const String passwordMismatch = "Passwords do not match";
  static const String allRequired = "All fields are required";
}

enum TaskFilter { today, tomorrow, thisWeek, all }

String filterLabel(TaskFilter filter) {
  switch (filter) {
    case TaskFilter.all:
      return 'All';
    case TaskFilter.today:
      return 'Today';
    case TaskFilter.tomorrow:
      return 'Tomorrow';
    case TaskFilter.thisWeek:
      return 'This Week';
  }
}
