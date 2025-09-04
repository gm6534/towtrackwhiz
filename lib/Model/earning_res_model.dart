class EarningResModel {
  bool? status;
  String? message;
  Earnings? data;
  int? rank;
  String? totalEarning;
  String? cycleEarning;

  EarningResModel({
    this.status,
    this.message,
    this.data,
    this.rank,
    this.totalEarning,
    this.cycleEarning,
  });

  EarningResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Earnings.fromJson(json['data']) : null;
    rank = json['rank'];
    totalEarning = json['total_earning'];
    cycleEarning = json['cycle_earning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['rank'] = rank;
    data['total_earning'] = totalEarning;
    data['cycle_earning'] = cycleEarning;
    return data;
  }
}

class Earnings {
  int? id;
  String? userId;
  String? cycle;
  String? amount;
  String? eligible;
  dynamic rank;
  String? createdAt;
  String? updatedAt;

  Earnings({
    this.id,
    this.userId,
    this.cycle,
    this.amount,
    this.eligible,
    this.rank,
    this.createdAt,
    this.updatedAt,
  });

  Earnings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    cycle = json['cycle'];
    amount = json['amount'];
    eligible = json['eligible'];
    rank = json['rank'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['cycle'] = cycle;
    data['amount'] = amount;
    data['eligible'] = eligible;
    data['rank'] = rank;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
