import 'package:get/get.dart';

class ProfileController extends GetxController {
  var isNotificationEnabled = true.obs;

  @override
  void onInit() {
    firstApiCall();
    super.onInit();
  }

  Future<void> firstApiCall() async {}
}
