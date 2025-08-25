class LoginReqModel {
  String? email;
  String? password;
  String? deviceToken;

  LoginReqModel({this.email, this.password, this.deviceToken});

  LoginReqModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['device_token'] = deviceToken;
    return data;
  }
}

class UpdateUserReqModel {
  String? name;
  String? email;
  String? avatar;
  String? password;
  String? confirmPassword;
  String? phone;

  UpdateUserReqModel({
    this.name,
    this.email,
    this.avatar,
    this.password,
    this.confirmPassword,
    this.phone,
  });

  UpdateUserReqModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
    password = json['password'];
    confirmPassword = json['confirm_password'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['avatar'] = avatar;
    data['password'] = password;
    data['confirm_password'] = confirmPassword;
    data['phone'] = phone;
    return data;
  }
}
