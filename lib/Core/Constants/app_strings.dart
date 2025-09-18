class AppInfo {
  static const String appTitle = "TowTrackWhiz";
}

class GetStorageKeys {
  static const String firstTime = "first_time";
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
  // static const String appLogo = "${png}towTrackLogo.png";
  static const String appLogo = "${png}app_new_logo.png";
  static const String appLogo1 = "${png}Tow-Track-Whiz.png";
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
  static const String downArrow = "${png}down-arrow.png";
  static const String truckIcon = "${png}truck.png";
  static const String circleTick = "${png}circle_tick.png";
  static const String googleIcon = "${png}google_icon.png";
  static const String appleIcon = "${png}apple_icon.png";

  /////////////////<<<<<-- SVG IMAGES -->>>>///////////////////////
  static const String appLogoSvg = "${svg}towTrackLogo.svg";
  // static const String tow1Svg = "${svg}tow1.svg";
  // static const String tow2Svg = "${svg}tow2.svg";
  // static const String tow3Svg = "${svg}tow3.svg";
}

class AppHeadings {
  static const name = "Name";
  static const email = "Email";
  static const password = "Password";
  static const confirmPassword = "Confirm Password";
  static const home = "Home";
  static const alert = "Alert";
  static const lookUp = "Look Up";
  static const profile = "Profile";
  static const updateVehicle = "Update Vehicle";
  static const addVehicles = "Add Vehicles";
  static const make = "Make";
  static const vehicleModel = "Vehicle Model";
  static const modelYear = "Model Year (e.g. 2025)";
  static const vehicleColor = "Vehicle Color";
  static const registrationState = "Registration State";
  static const registeredVehicles = "Registered Vehicles";
  static const myVehicles = "My Vehicles";
  static const notificationSettings = "Notification Settings";
  static const accountSettings = "Account Settings";
  static const paymentMethod = "Payment Method";
  static const payoutMethod = "Payouts";
  static const notificationSetting = "Notification Setting";
  static const vehicleDetail = "Vehicle Detail";

  static const letGetStarted = "Let's Get Started";
  static const findTowedCarEasily = "Find your towed car easily";
  static const helpCommunityRewards = "Help the community & earn rewards";
  static const avoidHighRiskZone = "Avoid high-risk zones with live heatmaps";
  static const towingHotZonesMap = "Towing Hot Zones Map";
  static const communityAlerts = "Community Alerts";
  static const communityHelper = "Community Helper";
  static const String type = "Type";
  static const String location = "Location";
  static const reportTowActivity = "Report Tow Activity";
  static const comments = "Comments (Optional)";
  static const String uploadImage = "Upload Image (Optional)";
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
  static const String orLoginWithText = "Or login with";
  static const String orContinueWithText = "Or continue with";
  static const String continueWith = "Continue with";
  static const String alertRequire = "Alert Require";
  static const String verified = "Verified";
  static const String carsRegistered = "Cars Registered";
  static const String youHaveHelpedVerify = "You’ve helped verify";
  static const String communityAlerts = "Community alerts";
  static const String level = "Level";

  static const String permissionRequired = "Permission Required";
  static const String openSettings = "Open Settings";
  static const String enterEmailHere = "Enter email here";
  static const String enterNameHere = "Enter name here";
  static const String dontHaveAccount = "Don’t have an account? ";
  static const String haveAnAccount = "Have an account? ";
  static const String selectType = "Select Type....";
  static const String emergency = "Emergency";
  static const String gasLeakReported = "Gas Leak Reported";
  static const String chooseOnMap = "Choose on map";
  static const String attachFile = "Attach file";
  static const String typeComment = "Type Comment";
  static const String licensePlate = "License plate";
  static const String model = "Model";
  static const String reportTow = "Report Tow";
  static const String image = "Image";
  static const String chooseImg = "Choose Image";
  static const String camera = "Camera";
  static const String gallery = "Gallery";
  static const String noRecordFound = "No record found";
  static const String noEarning = "You have no earnings yet.";
  static const String availabilityOfNotification =
      "Availability of notification";
  static const String memberSince = "Member Since";
  static const String chooseYourCity = "Choose Your City";
}

class ActionText {
  static const String signIn = "Sign In";
  static const String singUp = "Sign Up";
  static const String sendCode = "Send Code";
  static const String submit = "Submit";
  static const String submitReport = "Submit Report";
  static const String save = "Save";
  static const String resendCode = "Resend Code";
  static const String getStarted = "Get Started";
  static const String addVehicle = "Add Vehicle";
  static const String deleteVehicle = "Delete Vehicle";
  static const String next = "Next";
  static const String skip = "Skip";
  static const String logout = "Logout";

  static const String yes = "Yes";
  static const String no = "No";
  static const String cancel = "Cancel";
  static const String delete = "Delete";
  static const String edit = "Edit";
  static const String update = "Update";
  static const String select = "Select";
}

class ToastMsg {
  static const String allowCameraAccess = "Please allow access to the Camera";
  static const String allowGalleryAccess = "Please allow access to the Gallery";
  static const String noInternetConnection = "No Internet Connection";
  static const String required = "* required";
  static const String pleaseWait = "Please Wait";
  static const String closeApp = "Close App";
  static const String deleteVehicle = "Delete Vehicle";
  static const String areYouSureToDelVehicle =
      "Are you sure you want to delete this vehicle?";

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
  static const String allowLocationAccess =
      "Please allow access to the location";
}

class ErrorCode {
  static const String connectionAbort = "Software caused connection abort";
  static const String failedHost = "Failed host lookup";
  static const String invalidHtml = "<!DOCTYPE html>";
  static const String unexpectedError = "Unexpected error";
  static const String validationError = "Validation error";
  static const String serverError = "Internal Server error";
  static const String failedToParseResponse = "Failed to parse response";
  static const String invalidHTTPMethod = "Invalid HTTP method";
  static const String unAuthorizedAccess =
      "Unauthorized access. Please login again.";
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

enum TowEvent { tow_truck_seen, car_being_towed
  // , signage_posted
}

extension TowEventExtension on TowEvent {
  String get label {
    switch (this) {
      case TowEvent.tow_truck_seen:
        return 'Tow truck seen';
      case TowEvent.car_being_towed:
        return 'Car being towed';
      // case TowEvent.signage_posted:
      //   return 'Tow signage posted';
    }
  }

  static TowEvent? fromValue(String value) {
    switch (value) {
      case 'tow_truck_seen':
        return TowEvent.tow_truck_seen;
      case 'car_being_towed':
        return TowEvent.car_being_towed;
      // case 'signage_posted':
      //   return TowEvent.signage_posted;
      default:
        return null;
    }
  }
}
