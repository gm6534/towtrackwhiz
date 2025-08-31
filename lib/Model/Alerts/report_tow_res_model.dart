class ReportTowResModel {
  bool? status;
  String? message;
  Data? data;

  ReportTowResModel({this.status, this.message, this.data});

  ReportTowResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? userId;
  int? vehicleId;
  String? date;
  String? location;
  String? latitude;
  String? longitude;
  String? alertType;
  String? comments;
  String? imagePath;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data({
    this.userId,
    this.vehicleId,
    this.date,
    this.location,
    this.latitude,
    this.longitude,
    this.alertType,
    this.comments,
    this.imagePath,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    vehicleId = int.parse(json['vehicle_id'].toString());
    date = json['date'];
    location = json['location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    alertType = json['alert_type'];
    comments = json['comments'];
    imagePath = json['image_path'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['vehicle_id'] = vehicleId;
    data['date'] = date;
    data['location'] = location;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['alert_type'] = alertType;
    data['comments'] = comments;
    data['image_path'] = imagePath;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
