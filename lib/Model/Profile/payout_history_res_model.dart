class PayoutHistoryResModel {
  int? id;
  String? userId;
  String? amount;
  String? payoutMethod;
  String? paypalEmail;
  dynamic payoneerEmail;
  dynamic payoneerCustomerId;
  dynamic accountHolder;
  dynamic bankName;
  dynamic accountNumber;
  dynamic routingNumber;
  dynamic accountType;
  String? payoutDetails;
  dynamic transactionId;
  String? status;
  dynamic notes;
  String? createdAt;
  String? updatedAt;
  dynamic methodId;
  dynamic payoutHandle;

  PayoutHistoryResModel({
    this.id,
    this.userId,
    this.amount,
    this.payoutMethod,
    this.paypalEmail,
    this.payoneerEmail,
    this.payoneerCustomerId,
    this.accountHolder,
    this.bankName,
    this.accountNumber,
    this.routingNumber,
    this.accountType,
    this.payoutDetails,
    this.transactionId,
    this.status,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.methodId,
    this.payoutHandle,
  });

  PayoutHistoryResModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    amount = json['amount'];
    payoutMethod = json['payout_method'];
    paypalEmail = json['paypal_email'];
    payoneerEmail = json['payoneer_email'];
    payoneerCustomerId = json['payoneer_customer_id'];
    accountHolder = json['account_holder'];
    bankName = json['bank_name'];
    accountNumber = json['account_number'];
    routingNumber = json['routing_number'];
    accountType = json['account_type'];
    payoutDetails = json['payout_details'];
    transactionId = json['transaction_id'];
    status = json['status'];
    notes = json['notes'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    methodId = json['method_id'];
    payoutHandle = json['payout_handle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['amount'] = amount;
    data['payout_method'] = payoutMethod;
    data['paypal_email'] = paypalEmail;
    data['payoneer_email'] = payoneerEmail;
    data['payoneer_customer_id'] = payoneerCustomerId;
    data['account_holder'] = accountHolder;
    data['bank_name'] = bankName;
    data['account_number'] = accountNumber;
    data['routing_number'] = routingNumber;
    data['account_type'] = accountType;
    data['payout_details'] = payoutDetails;
    data['transaction_id'] = transactionId;
    data['status'] = status;
    data['notes'] = notes;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['method_id'] = methodId;
    data['payout_handle'] = payoutHandle;
    return data;
  }
}
