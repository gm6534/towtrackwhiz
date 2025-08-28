import 'package:towtrackwhiz/Model/Vehicle/vehicle_list_model.dart';

class AddVehicleResModel {
  String? status;
  String? message;
  VehiclesListModel? vehicle;

  AddVehicleResModel({this.status, this.message, this.vehicle});

  AddVehicleResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    vehicle =
        json['vehicle'] != null
            ? VehiclesListModel.fromJson(json['vehicle'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (vehicle != null) {
      data['vehicle'] = vehicle!.toJson();
    }
    return data;
  }
}
