class SignupReqModel {
  String? email;
  String? password;
  String? name;
  String? confirmPassword;

  SignupReqModel({this.email, this.password, this.name, this.confirmPassword});

  SignupReqModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    name = json['name'];
    confirmPassword = json['confirm_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['name'] = name;
    data['confirm_password'] = confirmPassword;
    return data;
  }
}
