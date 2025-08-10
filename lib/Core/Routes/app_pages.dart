import 'package:get/get.dart';
import 'package:towtrackwhiz/Core/Routes/app_route.dart';
import 'package:towtrackwhiz/View/Auth/bindings/login_binding.dart';
import 'package:towtrackwhiz/View/Auth/bindings/sign_up_binding.dart';
import 'package:towtrackwhiz/View/Auth/login_screen.dart';
import 'package:towtrackwhiz/View/Auth/sign_up_screen.dart';
import 'package:towtrackwhiz/View/Dashboard/bindings/dashboard_binding.dart';
import 'package:towtrackwhiz/View/Dashboard/dashboard_screen.dart';
import 'package:towtrackwhiz/View/ForgetPassword/forget_password_binding.dart';
import 'package:towtrackwhiz/View/ForgetPassword/forget_password_screen.dart';
import 'package:towtrackwhiz/View/GetStarted/get_started_binding.dart';
import 'package:towtrackwhiz/View/GetStarted/get_started_screen.dart';
import 'package:towtrackwhiz/View/Initial/initial_binding.dart';
import 'package:towtrackwhiz/View/Initial/splash_screen.dart';
import 'package:towtrackwhiz/View/OTPVerification/otp_binding.dart';
import 'package:towtrackwhiz/View/OTPVerification/otp_verification_screen.dart';
import 'package:towtrackwhiz/View/Onboarding/onboarding_binding.dart';
import 'package:towtrackwhiz/View/Onboarding/onboarding_screen.dart';
import 'package:towtrackwhiz/View/ResetPasswordScreen/reset_pass_binding.dart';
import 'package:towtrackwhiz/View/ResetPasswordScreen/reset_pass_screen.dart';

class AppPages {
  static List<GetPage> pages = [
    GetPage(
      name: AppRoute.initial,
      page: () => SplashScreen(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: AppRoute.onboarding,
      page: () => OnboardingScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoute.getStarted,
      page: () => GetStartedScreen(),
      binding: GetStartedBinding(),
    ),
    GetPage(
      name: AppRoute.loginScreen,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoute.signUpScreen,
      page: () => SignUpScreen(),
      binding: SignUpBinding(),
    ),

    GetPage(
      name: AppRoute.forgetPassScreen,
      page: () => ForgetPasswordScreen(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: AppRoute.otpScreen,
      page: () => OtpVerificationScreen(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: AppRoute.resetPassScreen,
      page: () => ResetPassScreen(),
      binding: ResetPassBinding(),
    ),
    GetPage(
      name: AppRoute.dashboard,
      page: () => DashboardScreen(),
      binding: DashboardBinding(),
    ),
  ];
}
