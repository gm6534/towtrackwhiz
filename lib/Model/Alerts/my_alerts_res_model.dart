class MyAlertsResModel {
  bool? success;
  List<AlertsModel>? alerts;

  MyAlertsResModel({this.success, this.alerts});

  MyAlertsResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['alerts'] != null) {
      alerts = <AlertsModel>[];
      json['alerts'].forEach((v) {
        alerts!.add(AlertsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (alerts != null) {
      data['alerts'] = alerts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AlertsModel {
  int? id;
  String? userId;
  String? alertType;
  String? latitude;
  String? longitude;
  String? location;
  String? comments;
  dynamic imagePath;
  String? verified;
  String? upvotes;
  String? downvotes;
  String? votes;
  dynamic expiresAt;
  String? createdAt;
  String? updatedAt;
  String? status;
  String? date;
  String? vehicleId;

  AlertsModel(
      {this.id,
        this.userId,
        this.alertType,
        this.latitude,
        this.longitude,
        this.location,
        this.comments,
        this.imagePath,
        this.verified,
        this.upvotes,
        this.downvotes,
        this.votes,
        this.expiresAt,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.date,
        this.vehicleId});

  AlertsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    alertType = json['alert_type'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    location = json['location'];
    comments = json['comments'];
    imagePath = json['image_path'];
    verified = json['verified'];
    upvotes = json['upvotes'];
    downvotes = json['downvotes'];
    votes = json['votes'];
    expiresAt = json['expires_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    date = json['date'];
    vehicleId = json['vehicle_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['alert_type'] = alertType;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['location'] = location;
    data['comments'] = comments;
    data['image_path'] = imagePath;
    data['verified'] = verified;
    data['upvotes'] = upvotes;
    data['downvotes'] = downvotes;
    data['votes'] = votes;
    data['expires_at'] = expiresAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    data['date'] = date;
    data['vehicle_id'] = vehicleId;
    return data;
  }
}
