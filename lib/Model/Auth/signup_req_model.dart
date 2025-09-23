class SignupReqModel {
  String? userIdentifier;
  String? email;
  String? password;
  String? name;
  String? confirmPassword;

  String? authType;
  String? deviceToken;

  SignupReqModel({
    this.email,
    this.userIdentifier,
    this.password,
    this.name,
    this.confirmPassword,
    this.deviceToken,
    this.authType,
  });

  SignupReqModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    userIdentifier = json['userIdentifier'];
    password = json['password'];
    name = json['name'];
    confirmPassword = json['confirm_password'];

    authType = json['auth_type'];
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['userIdentifier'] = userIdentifier;
    data['password'] = password;
    data['name'] = name;
    data['confirm_password'] = confirmPassword;

    data['auth_type'] = authType;
    data['device_token'] = deviceToken;
    return data;
  }
}
