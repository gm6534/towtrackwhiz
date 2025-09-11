import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  /// New lists to store who voted
  List<VoteModel>? upvotes;
  List<VoteModel>? downvotes;

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
    this.upvotes,
    this.downvotes,
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

    /// Parse lists of votes
    if (json['upvotes'] != null) {
      upvotes =
          (json['upvotes'] as List).map((e) => VoteModel.fromJson(e)).toList();
    }
    if (json['downvotes'] != null) {
      downvotes =
          (json['downvotes'] as List)
              .map((e) => VoteModel.fromJson(e))
              .toList();
    }
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
    data['votes'] = votes;
    data['expires_at'] = expiresAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    data['date'] = date;
    data['vehicle_id'] = vehicleId;
    data['distance'] = distance;
    data['upvotes_count'] = upVoteCount;
    data['downvotes_count'] = downVoteCount;

    if (upvotes != null) {
      data['upvotes'] = upvotes!.map((e) => e.toJson()).toList();
    }
    if (downvotes != null) {
      data['downvotes'] = downvotes!.map((e) => e.toJson()).toList();
    }

    return data;
  }

  /// Helpers to check if my user has already voted
  bool isUpVoted(String myUserId) {
    return upvotes?.any((v) => v.userId == myUserId) ?? false;
  }

  bool isDownVoted(String myUserId) {
    return downvotes?.any((v) => v.userId == myUserId) ?? false;
  }

  LatLng? get latLng {
    if (latitude == null || longitude == null) return null;
    return LatLng(double.parse(latitude!), double.parse(longitude!));
  }
}

class VoteModel {
  String? userId;
  String? alertId;

  VoteModel({this.userId, this.alertId});

  VoteModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    alertId = json['alert_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['alert_id'] = alertId;
    data['user_id'] = userId;
    return data;
  }
}
