class SubmitPayoutReqModel {
  int? payoutMethodId;
  double? amount;
  String? notes;
  String? paypalEmail;
  String? payoneerEmail;
  String? payoneerCustomerId;
  String? accountHolder;
  String? bankName;
  String? accountNumber;
  String? routingNumber;
  String? accountType;
  String? payoutHandle;

  SubmitPayoutReqModel({
    this.payoutMethodId,
    this.amount,
    this.notes,
    this.paypalEmail,
    this.payoneerEmail,
    this.payoneerCustomerId,
    this.accountHolder,
    this.bankName,
    this.accountNumber,
    this.routingNumber,
    this.accountType,
    this.payoutHandle,
  });

  SubmitPayoutReqModel.fromJson(Map<String, dynamic> json) {
    payoutMethodId = json['payout_method_id'];
    amount = json['amount'];
    notes = json['notes'];
    paypalEmail = json['paypal_email'];
    payoneerEmail = json['payoneer_email'];
    payoneerCustomerId = json['payoneer_customer_id'];
    accountHolder = json['account_holder'];
    bankName = json['bank_name'];
    accountNumber = json['account_number'];
    routingNumber = json['routing_number'];
    accountType = json['account_type'];
    payoutHandle = json['payout_handle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payout_method_id'] = payoutMethodId;
    data['amount'] = amount;
    data['notes'] = notes;
    data['paypal_email'] = paypalEmail;
    data['payoneer_email'] = payoneerEmail;
    data['payoneer_customer_id'] = payoneerCustomerId;
    data['account_holder'] = accountHolder;
    data['bank_name'] = bankName;
    data['account_number'] = accountNumber;
    data['routing_number'] = routingNumber;
    data['account_type'] = accountType;
    data['payout_handle'] = payoutHandle;
    return data;
  }
}
