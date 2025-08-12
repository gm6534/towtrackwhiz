class AppInfo {
  static const String appTitle = "TowTrack";
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
  static const String png = "assets/png/";
  static const String svg = "assets/svg/";

  /////////////////<<<<<-- PNG IMAGES -->>>>///////////////////////
  static const String appLogo = "${png}towTrackLogo.png";
  static const String tow1Png = "${png}tow1.png";
  static const String tow2Png = "${png}tow2.png";
  static const String tow3Png = "${png}tow3.png";
  static const String alertIcon = "${png}alertIcon.png";
  static const String announcementIcon = "${png}announcementIcon.png";
  static const String carIcon = "${png}carIcon.png";
  static const String deleteIcon = "${png}deleteIcon.png";
  static const String editIcon = "${png}editIcon.png";
  static const String filledLookupIcon = "${png}filledLookupIcon.png";
  static const String filledHomeIcon = "${png}filledHomeIcon.png";
  static const String filledProfileIcon = "${png}filledProfileIcon.png";
  static const String profileIcon = "${png}profileOutlinedIcon.png";
  static const String homeIcon = "${png}homeIcon.png";
  static const String locationIcon = "${png}locationIcon.png";
  static const String lookupIcon = "${png}lookupIcon.png";
  static const String msgIcon = "${png}msgIcon.png";
  static const String outlinedAlertIcon = "${png}outlinedAlertIcon.png";
  static const String passIcon = "${png}passIcon.png";
  static const String successBadge = "${png}successBadge.png";
  static const String logoutIcon = "${png}logoutIcon.png";
  static const String myVehicleIcon = "${png}myVehicleIcon.png";
  static const String notificationIcon = "${png}notificationIcon.png";
  static const String payMethodIcon = "${png}payMethodIcon.png";
  static const String settingIcon = "${png}settingIcon.png";
  static const String badgeIcon = "${png}badgeIcon.png";
  static const String verifyBadge = "${png}verifyBadge.png";
  static const String mapImg = "${png}mapImg.png";

  /////////////////<<<<<-- SVG IMAGES -->>>>///////////////////////
  static const String appLogoSvg = "${svg}towTrackLogo.svg";
  // static const String tow1Svg = "${svg}tow1.svg";
  // static const String tow2Svg = "${svg}tow2.svg";
  // static const String tow3Svg = "${svg}tow3.svg";
}

class AppHeadings {
  static const signInTitle =
      "Welcome to TowTrackWhiz\nAssist users in locating towed vehicles";
  static const signUpTitle =
      "Welcome to TowTrackWhiz\nEngaging with a Community-driven Alert system";
  static const forgetPassTitle = "Forgot Password";
  static const forgetPassBtnTitle = "Forgot Password ?";
  static const forgetPassSubTitle =
      "Please enter your registered email to recover the account.";
  static const otpTitle = "OTP Verification";
  static otpSubTitle(String value) {
    return "We have sent OTP Code via email to $value";
  }

  static const resetPassTitle = "Reset Password";
  static const resetPassSubTitle =
      "Protect your account with a secure password. Try to use different";
  static const beforeStart =
      "To find your towed Vehicle,You’ll Need the following information";
}

class Strings {
  static const String permissionRequired = "Permission Required";
  static const String openSettings = "Open Settings";
}

class ActionText {
  static const String signIn = "Sign In";
  static const String singUp = "Sign Up";
  static const String sendCode = "Send Code";
  static const String submit = "Submit";
  static const String save = "Save";
  static const String resendCode = "Resend Code";

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
