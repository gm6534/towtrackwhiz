import 'package:towtrackwhiz/Core/Network/api_client.dart';
import 'package:towtrackwhiz/Model/tasks_list_res_model.dart';
import 'package:http/http.dart' as http;

import '../Core/Utils/log_util.dart';

class DashboardRepo extends ApiClient {
  Future<TasksListResModel?> getTasksList() async {
    try {
      var response = await get("appointments/tasks");

      TasksListResModel? tasksListResModel;
      if (response.data != null) {
        tasksListResModel = TasksListResModel.fromJson(response.data);
      } else {
        throw http.ClientException(response.message!);
      }
      return tasksListResModel;
    } catch (e) {
      Log.e("getTasksList: DashboardRepo- ", e.toString());

      rethrow;
    }
  }
}
