class VehiclesListModel {
  int? id;
  String? userId;
  String? licensePlate;
  String? make;
  String? model;
  String? color;
  String? registrationState;
  String? createdAt;
  String? updatedAt;
  String? status;

  VehiclesListModel({
    this.id,
    this.userId,
    this.licensePlate,
    this.make,
    this.model,
    this.color,
    this.registrationState,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  VehiclesListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'].toString();
    licensePlate = json['license_plate'];
    make = json['make'];
    model = json['model'];
    color = json['color'];
    registrationState = json['registration_state'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['license_plate'] = licensePlate;
    data['make'] = make;
    data['model'] = model;
    data['color'] = color;
    data['registration_state'] = registrationState;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    return data;
  }
}