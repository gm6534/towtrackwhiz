import 'package:http/http.dart' as http;
import 'package:towtrackwhiz/Core/Network/api_client.dart';
import 'package:towtrackwhiz/Model/Vehicle/add_vehicle_req_model.dart';
import 'package:towtrackwhiz/Model/Vehicle/add_vehicle_res_model.dart';
import 'package:towtrackwhiz/Model/Vehicle/vehicle_list_res_model.dart';
import 'package:towtrackwhiz/Model/analytics_res_model.dart';

import '../Core/Utils/log_util.dart';

class DashboardRepo extends ApiClient {
  Future<AnalyticsResModel?> getAnalytics() async {
    try {
      var response = await get("get/analytics");

      AnalyticsResModel? analyticsResModel;
      if (response.data != null) {
        analyticsResModel = AnalyticsResModel.fromJson(response.data);
      } else {
        throw http.ClientException(response.message!);
      }
      return analyticsResModel;
    } catch (e) {
      Log.e("getAnalytics: DashboardRepo- ", e.toString());

      rethrow;
    }
  }

  Future<VehicleListResModel?> getMyVehicleList() async {
    try {
      var response = await get("vehicles/list");

      VehicleListResModel? vehicleListResModel;
      if (response.data != null) {
        vehicleListResModel = VehicleListResModel.fromJson(response.data);
      } else {
        throw http.ClientException(response.message!);
      }
      return vehicleListResModel;
    } catch (e) {
      Log.e("getMyVehicleList: DashboardRepo- ", e.toString());

      rethrow;
    }
  }

  Future<AddVehicleResModel?> addVehicle({
    required AddVehicleReqModel model,
  }) async {
    try {
      var response = await post("vehicles/store", body: model);

      AddVehicleResModel? addVehicleResModel;
      if (response.data != null) {
        addVehicleResModel = AddVehicleResModel.fromJson(response.data);
      } else {
        throw http.ClientException(response.message!);
      }
      return addVehicleResModel;
    } catch (e) {
      Log.e("getMyVehicleList: DashboardRepo- ", e.toString());

      rethrow;
    }
  }

  Future<String?> deleteVehicle({required int vId}) async {
    try {
      var response = await delete("vehicles/delete/$vId");

      String? message;
      if (response.statusCode == 200) {
        message = response.data["message"];
      } else {
        throw http.ClientException(response.message!);
      }
      return message;
    } catch (e) {
      Log.e("deleteVehicle: DashboardRepo- ", e.toString());
      rethrow;
    }
  }

  Future<AddVehicleResModel?> updateVehicle({
    required int vId,
    required AddVehicleReqModel model,
  }) async {
    try {
      var response = await post("vehicles/update/$vId", body: model);

      AddVehicleResModel? updateVehicleResModel;
      if (response.data != null) {
        updateVehicleResModel = AddVehicleResModel.fromJson(response.data);
      } else {
        throw http.ClientException(response.message!);
      }
      return updateVehicleResModel;
    } catch (e) {
      Log.e("updateVehicle: DashboardRepo- ", e.toString());
      rethrow;
    }
  }
}
