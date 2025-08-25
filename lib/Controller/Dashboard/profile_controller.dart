import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Auth/auth_controller.dart';

class ProfileController extends GetxController {
  var isNotificationEnabled = true.obs;

  final vehicles = [
    {"name": "Car 02465", "plate": "Lue4567", "model": "2022"},
    {"name": "Car 02465", "plate": "Lue4567", "model": "2022"},
    {"name": "Car 02465", "plate": "Lue4567", "model": "2022"},
    {"name": "Car 02465", "plate": "Lue4567", "model": "2022"},
  ];

  AuthController? authController;

  @override
  void onInit() {
    authController = Get.find<AuthController>();
    firstApiCall();
    super.onInit();
  }

  Future<void> firstApiCall() async {}
}
