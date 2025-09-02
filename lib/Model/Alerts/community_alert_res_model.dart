class CommunityAlertResModel {
  bool? success;
  List<CommunityAlertsModel>? alerts;

  CommunityAlertResModel({this.success, this.alerts});

  CommunityAlertResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['alerts'] != null) {
      alerts = <CommunityAlertsModel>[];
      json['alerts'].forEach((v) {
        alerts!.add(CommunityAlertsModel.fromJson(v));
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

class CommunityAlertsModel {
  int? id;
  String? userId;
  String? alertType;
  String? latitude;
  String? longitude;
  String? location;
  String? comments;
  String? imagePath;
  int? verified;
  int? upvotes;
  int? downvotes;
  int? votes;
  int? upVoteCount;
  int? downVoteCount;
  dynamic expiresAt;
  String? createdAt;
  String? updatedAt;
  String? status;
  String? date;
  String? vehicleId;
  String? distance;

  CommunityAlertsModel({
    this.id,
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
    this.vehicleId,
    this.distance,
    this.upVoteCount,
    this.downVoteCount,
  });

  CommunityAlertsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    alertType = json['alert_type'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    location = json['location'];
    comments = json['comments'];
    imagePath = json['image_path'];
    verified = int.parse(json['verified'].toString());
    upvotes = int.parse(json['upvotes'].toString());
    downvotes = int.parse(json['downvotes'].toString());
    votes = int.parse(json['votes'].toString());
    expiresAt = json['expires_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    date = json['date'];
    vehicleId = json['vehicle_id'];
    distance = json['distance'];

    upVoteCount = int.parse(json['upvotes_count'].toString());
    downVoteCount = int.parse(json['downvotes_count'].toString());
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
    data['distance'] = distance;
    return data;
  }
}
