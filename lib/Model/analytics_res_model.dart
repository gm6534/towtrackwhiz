class AnalyticsResModel {
  bool? success;
  int? totalAlerts;
  int? totalVehicles;
  int? verifiedAlerts;

  AnalyticsResModel({
    this.success,
    this.totalAlerts,
    this.totalVehicles,
    this.verifiedAlerts,
  });

  AnalyticsResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    totalAlerts = json['totalAlerts'];
    totalVehicles = json['totalVehicles'];
    verifiedAlerts = json['verifiedAlerts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['totalAlerts'] = totalAlerts;
    data['totalVehicles'] = totalVehicles;
    data['verifiedAlerts'] = verifiedAlerts;
    return data;
  }
}
