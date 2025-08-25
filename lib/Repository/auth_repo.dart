import 'package:towtrackwhiz/Core/Network/api_client.dart';
import 'package:towtrackwhiz/Model/Auth/login_req_model.dart';
import 'package:http/http.dart' as http;
import 'package:towtrackwhiz/Model/Auth/signup_req_model.dart';
import '../Core/Utils/log_util.dart';
import '../Model/Auth/auth_response_model.dart';

class AuthRepo extends ApiClient {
  Future<AuthResponseModel?> login({LoginReqModel? model}) async {
    try {
      var response = await post("login", body: model?.toJson());

      AuthResponseModel authResponseModel;
      if (response.data != null) {
        authResponseModel = AuthResponseModel.fromJson(response.data);
      } else {
        throw http.ClientException(response.message!);
      }
      return authResponseModel;
    } catch (e) {
      Log.e("login: AuthRepo- ", e.toString());

      rethrow;
    }
  }

  Future<AuthResponseModel?> signUp({SignupReqModel? model}) async {
    try {
      var response = await post("register", body: model?.toJson());

      AuthResponseModel authResponseModel;
      if (response.data != null) {
        authResponseModel = AuthResponseModel.fromJson(response.data);
      } else {
        throw http.ClientException(response.message!);
      }
      return authResponseModel;
    } catch (e) {
      Log.e("signUp: AuthRepo- ", e.toString());

      rethrow;
    }
  }

  Future<UserModel?> getProfile() async {
    try {
      var response = await get("user");

      UserModel? userModel;
      if (response.data != null) {
        userModel = UserModel.fromJson(response.data);
      } else {
        throw http.ClientException(response.message!);
      }
      return userModel;
    } catch (e) {
      Log.e("getProfile: AuthRepo- ", e.toString());

      rethrow;
    }
  }

  Future<UpdateProfileResModel?> updateProfile({
    UpdateUserReqModel? model,
  }) async {
    try {
      var response = await multipartPost(
        endpoint: "profile/update",
        fields: model!.toJson(),
      );

      UpdateProfileResModel userModel;
      if (response.data != null) {
        userModel = UpdateProfileResModel.fromJson(response.data);
      } else {
        throw http.ClientException(response.message!);
      }
      return userModel;
    } catch (e) {
      Log.e("login: AuthRepo- ", e.toString());

      rethrow;
    }
  }
}
