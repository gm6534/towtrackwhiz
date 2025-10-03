class AuthResponseModel {
  String? token;
  UserModel? user;

  AuthResponseModel({this.token, this.user});

  AuthResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (user != null) {
      data['user'] = user?.toJson();
    }
    return data;
  }
}

// class UserModel {
//   int? id;
//   String? name;
//   String? email;
//   String? phone;
//   dynamic emailVerifiedAt;
//   String? avatar;
//   dynamic countryId;
//   String? status;
//   String? role;
//   dynamic deviceToken;
//   dynamic location;
//   dynamic lat;
//   dynamic lng;
//   dynamic streetAddress;
//   dynamic deletedAt;
//   String? createdAt;
//   String? updatedAt;
//   dynamic cnic;
//   dynamic dob;
//   dynamic gender;
//   dynamic address;
//   String? availability;
//   dynamic profilePic;
//   String? pass;
//   String? confirmPass;
//
//   UserModel({
//     this.id,
//     this.name,
//     this.email,
//     this.phone,
//     this.emailVerifiedAt,
//     this.avatar,
//     this.countryId,
//     this.status,
//     this.role,
//     this.deviceToken,
//     this.location,
//     this.lat,
//     this.lng,
//     this.streetAddress,
//     this.deletedAt,
//     this.createdAt,
//     this.updatedAt,
//     this.cnic,
//     this.dob,
//     this.gender,
//     this.address,
//     this.availability,
//     this.profilePic,
//   });
//
//   UserModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     email = json['email'];
//     phone = json['phone'];
//     emailVerifiedAt = json['email_verified_at'];
//     avatar = json['avatar'];
//     countryId = json['country_id'];
//     status = json['status'].toString();
//     role = json['role'];
//     deviceToken = json['device_token'];
//     location = json['location'];
//     lat = json['lat'];
//     lng = json['lng'];
//     streetAddress = json['street_address'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     cnic = json['cnic'];
//     dob = json['dob'];
//     gender = json['gender'];
//     address = json['address'];
//     availability = json['availability'];
//     profilePic = json['profile_pic'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['email'] = email;
//     data['phone'] = phone;
//     data['email_verified_at'] = emailVerifiedAt;
//     data['avatar'] = avatar;
//     data['country_id'] = countryId;
//     data['status'] = status;
//     data['role'] = role;
//     data['device_token'] = deviceToken;
//     data['location'] = location;
//     data['lat'] = lat;
//     data['lng'] = lng;
//     data['street_address'] = streetAddress;
//     data['deleted_at'] = deletedAt;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['cnic'] = cnic;
//     data['dob'] = dob;
//     data['gender'] = gender;
//     data['address'] = address;
//     data['availability'] = availability;
//     data['profile_pic'] = profilePic;
//     return data;
//   }
// }

class UserModel {
  int? id;
  String? name;
  String? email;
  dynamic phone;
  dynamic emailVerifiedAt;
  String? avatar;
  String? verified;
  String? walletBalance;
  dynamic countryId;
  String? status;
  String? role;
  String? deviceToken;
  dynamic location;
  dynamic lat;
  dynamic lng;
  dynamic streetAddress;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  String? level;
  String? totalVerifiedCount;
  String? verifiedLevel;
  bool? isNotify;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.emailVerifiedAt,
    this.avatar,
    this.verified,
    this.walletBalance,
    this.countryId,
    this.status,
    this.role,
    this.deviceToken,
    this.location,
    this.lat,
    this.lng,
    this.streetAddress,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.level,
    this.isNotify,
    this.totalVerifiedCount,
    this.verifiedLevel,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    emailVerifiedAt = json['email_verified_at'];
    avatar = json['avatar'];
    verified = json['verified'];
    walletBalance = json['wallet_balance'];
    countryId = json['country_id'];
    status = json['status'];
    role = json['role'];
    deviceToken = json['device_token'];
    location = json['location'];
    lat = json['lat'];
    lng = json['lng'];
    streetAddress = json['street_address'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    level = json['level'];
    isNotify =
        json['is_notify'] != null
            ? (json['is_notify'] == "1" ? true : false)
            : null;
    totalVerifiedCount = json['total_verified_count'];
    verifiedLevel = json['verified_level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['email_verified_at'] = emailVerifiedAt;
    data['avatar'] = avatar;
    data['verified'] = verified;
    data['wallet_balance'] = walletBalance;
    data['country_id'] = countryId;
    data['status'] = status;
    data['role'] = role;
    data['device_token'] = deviceToken;
    data['location'] = location;
    data['lat'] = lat;
    data['lng'] = lng;
    data['street_address'] = streetAddress;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['level'] = level;
    // data['is_notify'] = isNotify;
    data['total_verified_count'] = totalVerifiedCount;
    data['verified_level'] = verifiedLevel;
    return data;
  }
}

class UpdateProfileResModel {
  bool? status;
  String? message;
  UserModel? user;

  UpdateProfileResModel({this.status, this.message, this.user});

  UpdateProfileResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (user != null) {
      data['user'] = user?.toJson();
    }
    return data;
  }
}
