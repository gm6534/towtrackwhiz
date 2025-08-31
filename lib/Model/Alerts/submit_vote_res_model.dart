class SubmitVoteResModel {
  String? status;
  String? message;
  Verification? verification;
  String? alertStatus;
  int? upvotes;
  int? downvotes;
  dynamic rewardAction;

  SubmitVoteResModel({
    this.status,
    this.message,
    this.verification,
    this.alertStatus,
    this.upvotes,
    this.downvotes,
    this.rewardAction,
  });

  SubmitVoteResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    verification =
        json['verification'] != null
            ? Verification.fromJson(json['verification'])
            : null;
    alertStatus = json['alert_status'];
    upvotes = json['upvotes'];
    downvotes = json['downvotes'];
    rewardAction = json['reward_action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (verification != null) {
      data['verification'] = verification!.toJson();
    }
    data['alert_status'] = alertStatus;
    data['upvotes'] = upvotes;
    data['downvotes'] = downvotes;
    data['reward_action'] = rewardAction;
    return data;
  }
}

class Verification {
  int? id;
  String? alertId;
  String? userId;
  String? voteType;
  dynamic deviceId;
  String? createdAt;
  String? updatedAt;

  Verification({
    this.id,
    this.alertId,
    this.userId,
    this.voteType,
    this.deviceId,
    this.createdAt,
    this.updatedAt,
  });

  Verification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    alertId = json['alert_id'];
    userId = json['user_id'];
    voteType = json['vote_type'];
    deviceId = json['device_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['alert_id'] = alertId;
    data['user_id'] = userId;
    data['vote_type'] = voteType;
    data['device_id'] = deviceId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
