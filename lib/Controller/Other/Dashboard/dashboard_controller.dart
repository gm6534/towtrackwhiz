import 'package:get/get.dart';
class DashboardController extends GetxController {
  var currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;

    // RxBool isDashboardLoading = true.obs;
    // RxList<TaskModel> taskList = <TaskModel>[].obs;
    // AuthController? authController;
    // DashboardRepo? dashboardRepo;
    // Rx<TaskFilter> selectedFilter = TaskFilter.today.obs;

    // ////////////Map Items////////////////
    // final Completer<GoogleMapController> mapController =
    //     Completer<GoogleMapController>();

    // ////////////////////////////////////

    // @override
    // void onInit() {
    //   authController = Get.find<AuthController>();
    //   dashboardRepo = DashboardRepo();
    //   firstApiCall();
    //   super.onInit();
    // }

    // Future<void> firstApiCall() async {
    //   isDashboardLoading.value = true;
    //   authController?.getUserProfile();
    //   await getTaskList();
    //   isDashboardLoading.value = false;
    // }

    // void navigateToProfile() {
    //   Get.toNamed(AppRoute.profileScreen);
    // }

    // Future<void> getTaskList() async {
    //   try {
    //     taskList.value = [];
    //     var result = await dashboardRepo?.getTasksList();
    //     if (result != null &&
    //         result.taskModel != null &&
    //         result.taskModel!.isNotEmpty) {
    //       taskList.value = result.taskModel ?? [];
    //     }
    //   } catch (e) {
    //     if (e is ClientException) {
    //       ToastAndDialog.errorDialog(e.message);
    //     } else {
    //       ToastAndDialog.errorDialog(e.toString());
    //     }
    //   }
    // }
  }
}
