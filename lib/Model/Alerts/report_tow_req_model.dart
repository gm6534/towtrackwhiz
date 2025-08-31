class ReportTowReqModel {
  int? vehicleId;
  String? date;
  String? location;
  String? latitude;
  String? longitude;
  String? alertType;
  String? comments;
  String? image;

  ReportTowReqModel({
    this.vehicleId,
    this.date,
    this.location,
    this.latitude,
    this.longitude,
    this.alertType,
    this.comments,
    this.image,
  });

  ReportTowReqModel.fromJson(Map<String, dynamic> json) {
    vehicleId = json['vehicle_id'];
    date = json['date'];
    location = json['location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    alertType = json['alert_type'];
    comments = json['comments'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vehicle_id'] = vehicleId;
    data['date'] = date;
    data['location'] = location;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['alert_type'] = alertType;
    data['comments'] = comments;
    data['image'] = image;
    return data;
  }
}
