class SubmitPayoutResModel {
  String? message;
  SubmitPayoutResData? data;

  SubmitPayoutResModel({this.message, this.data});

  SubmitPayoutResModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data =
        json['data'] != null
            ? SubmitPayoutResData.fromJson(json['data'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class SubmitPayoutResData {
  int? amount;
  String? notes;
  String? paypalEmail;
  int? userId;
  String? payoutMethod;
  String? payoutDetails;
  String? updatedAt;
  String? createdAt;
  int? id;

  SubmitPayoutResData({
    this.amount,
    this.notes,
    this.paypalEmail,
    this.userId,
    this.payoutMethod,
    this.payoutDetails,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  SubmitPayoutResData.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    notes = json['notes'];
    paypalEmail = json['paypal_email'];
    userId = json['user_id'];
    payoutMethod = json['payout_method'];
    payoutDetails = json['payout_details'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['notes'] = notes;
    data['paypal_email'] = paypalEmail;
    data['user_id'] = userId;
    data['payout_method'] = payoutMethod;
    data['payout_details'] = payoutDetails;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
