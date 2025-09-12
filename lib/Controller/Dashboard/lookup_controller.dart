import 'package:get/get.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Utils/log_util.dart';
import 'package:towtrackwhiz/Model/lookup_res_model.dart';
import 'package:towtrackwhiz/Repository/dashboard_repo.dart';

class LookupController extends GetxController {
  RxBool isLookupLoading = false.obs;
  RxList<LookupResModel> lookupList = <LookupResModel>[].obs;
  Rx<LookupResModel?> selectedCity = Rx<LookupResModel?>(null);

  DashboardRepo? dashboardRepo;

  // Default entry: "Choose your city"
  final LookupResModel defaultCity = LookupResModel(
    cityName: Strings.chooseYourCity,
    cityCode: "",
    lookupUrl: null,
    buttonText: null,
    tips: [],
  );

  @override
  void onInit() {
    dashboardRepo = DashboardRepo();
    selectedCity.value = defaultCity;
    getLookupData();
    super.onInit();
  }

  Future<void> getLookupData() async {
    try {
      isLookupLoading.value = true;
      lookupList.clear();
      final result = await dashboardRepo?.getLookups() ?? [];
      if (result.isNotEmpty) {
        lookupList.assignAll([defaultCity, ...result]);
      }
    } catch (e, s) {
      Log.e("getLookupData - LookupController", "$e\n$s");
    } finally {
      isLookupLoading.value = false;
    }
  }
}
