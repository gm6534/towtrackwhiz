import 'package:get/get.dart';

class ProfileController extends GetxController {
  var isNotificationEnabled = true.obs;

  final vehicles = [
    {"name": "Car 02465", "plate": "Lue4567", "model": "2022"},
    {"name": "Car 02465", "plate": "Lue4567", "model": "2022"},
    {"name": "Car 02465", "plate": "Lue4567", "model": "2022"},
    {"name": "Car 02465", "plate": "Lue4567", "model": "2022"},
  ];

  @override
  void onInit() {
    firstApiCall();
    super.onInit();
  }

  Future<void> firstApiCall() async {}
}
