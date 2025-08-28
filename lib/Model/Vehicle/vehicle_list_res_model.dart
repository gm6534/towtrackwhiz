import 'vehicle_list_model.dart';

class VehicleListResModel {
  String? status;
  List<VehiclesListModel>? vehicles;

  VehicleListResModel({this.status, this.vehicles});

  VehicleListResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['vehicles'] != null) {
      vehicles = <VehiclesListModel>[];
      json['vehicles'].forEach((v) {
        vehicles!.add(VehiclesListModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (vehicles != null) {
      data['vehicles'] = vehicles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

