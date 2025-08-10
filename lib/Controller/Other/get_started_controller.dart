import 'package:get/get.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Routes/app_route.dart';

class GetStartedController extends GetxController {
  String login = ActionText.login;
  String signUp = ActionText.singUp;
  
  void loginPage() {
    Get.offAllNamed(AppRoute.loginScreen);
  }

  void signUpPage() {
    Get.offAllNamed(AppRoute.signUpScreen);
  }
}
