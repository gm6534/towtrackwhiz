import 'dart:async';
import 'dart:convert';

import 'package:towtrackwhiz/Controller/Auth/auth_controller.dart';
import 'package:towtrackwhiz/Controller/Other/connectivity_controller.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/app_config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'api_response.dart';

class ApiClient {
  static final String _baseUrl = AppConfig.rootURL ?? "";
  static const Duration _timeout = Duration(seconds: 15);

  AuthController get _authController => Get.find<AuthController>();

  final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    return _request<T>(
      method: 'GET',
      url: _baseUrl + endpoint,
      headers: headers,
    );
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    return _request<T>(
      method: 'POST',
      url: _baseUrl + endpoint,
      headers: headers,
      body: body,
    );
  }

  Future<ApiResponse<T>> multipartPost<T>({
    required String endpoint,
    required Map<String, dynamic> fields,
    String imageKeyValue = 'avatar',
    Map<String, String>? headers,
  }) async {
    try {
      var connectivity = Get.find<ConnectionManagerController>();
      if (!connectivity.isConnected.value) {
        return ApiResponse.error(ToastMsg.noInternetConnection);
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(_baseUrl + endpoint),
      );

      // 🔐 Authorization Header
      final token = _authController.accessToken;
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      if (headers != null) {
        request.headers.addAll(headers);
      }

      // ✏️ Extract avatar and remove from fields map
      final avatarPath = fields[imageKeyValue];
      final filteredFields = Map<String, dynamic>.from(fields)
        ..removeWhere((key, value) => key == imageKeyValue || value == null);

      // 🌐 Add remaining fields as strings
      request.fields.addAll(
        filteredFields.map((key, value) => MapEntry(key, value.toString())),
      );

      // 📷 Add avatar as multipart file if present
      if (avatarPath != null && avatarPath.toString().isNotEmpty) {
        final file = await http.MultipartFile.fromPath(
          imageKeyValue,
          avatarPath.toString(),
        );
        request.files.add(file);
      }

      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse<T>(response);
    } catch (e) {
      return ApiResponse.error("${ErrorCode.unexpectedError} ${e.toString()}");
    }
  }

  Future<ApiResponse<T>> multipartPost1<T>({
    required String endpoint,
    required Map<String, dynamic> fields,
    Map<String, String>? headers,
    Map<String, String>? filePaths,
  }) async {
    try {
      var connectivity = Get.find<ConnectionManagerController>();
      if (!connectivity.isConnected.value) {
        return ApiResponse.error(ToastMsg.noInternetConnection);
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(_baseUrl + endpoint),
      );

      // 🔐 Authorization Header
      final token = _authController.accessToken;
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      if (headers != null) {
        request.headers.addAll(headers);
      }

      request.fields.addAll(
        Map.fromEntries(
          fields.entries
              .where((e) => e.value != null)
              .map((e) => MapEntry(e.key, e.value.toString())),
        ),
      );

      // request.fields.addAll(
      //   fields.map((key, value) => MapEntry(key, value?.toString() ?? '')),
      // );

      if (filePaths != null) {
        for (final entry in filePaths.entries) {
          final file = await http.MultipartFile.fromPath(
            entry.key,
            entry.value,
          );
          request.files.add(file);
        }
      }

      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse<T>(response);
    } catch (e) {
      return ApiResponse.error("${ErrorCode.unexpectedError}: ${e.toString()}");
    }
  }

  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    return _request<T>(
      method: 'PUT',
      url: _baseUrl + endpoint,
      headers: headers,
      body: body,
    );
  }

  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    return _request<T>(
      method: 'DELETE',
      url: _baseUrl + endpoint,
      headers: headers,
      body: body,
    );
  }

  Future<ApiResponse<T>> _request<T>({
    required String method,
    required String url,
    Map<String, String>? headers,
    Object? body,
  }) async {
    try {
      var connectivity = Get.find<ConnectionManagerController>();
      if (!connectivity.isConnected.value) {
        return ApiResponse.error(ToastMsg.noInternetConnection);
      }

      final token = _authController.accessToken;
      final mergedHeaders = {
        ..._defaultHeaders,
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        if (headers != null) ...headers,
      };

      http.Response response;

      switch (method) {
        case 'GET':
          response = await http
              .get(Uri.parse(url), headers: mergedHeaders)
              .timeout(_timeout);
          break;
        case 'POST':
          response = await http
              .post(
                Uri.parse(url),
                headers: mergedHeaders,
                body: jsonEncode(body),
              )
              .timeout(_timeout);
          break;
        case 'PUT':
          response = await http
              .put(
                Uri.parse(url),
                headers: mergedHeaders,
                body: jsonEncode(body),
              )
              .timeout(_timeout);
          break;
        case 'DELETE':
          response = await http
              .delete(
                Uri.parse(url),
                headers: mergedHeaders,
                body: jsonEncode(body),
              )
              .timeout(_timeout);
          break;
        default:
          return ApiResponse.error("${ErrorCode.invalidHTTPMethod}: $method");
      }

      return _handleResponse<T>(response);
    } catch (e) {
      return ApiResponse.error("${ErrorCode.unexpectedError}: ${e.toString()}");
    }
  }


  ApiResponse<T> _handleResponse<T>(http.Response response) {
    final int statusCode = response.statusCode;
    final String responseBody = response.body;
    String? errorMsg;

    try {
      final decoded = responseBody.isNotEmpty ? jsonDecode(responseBody) : null;

      if (decoded != null && decoded is Map<String, dynamic>) {
        if (decoded.containsKey("errors")) {
          final errors = decoded["errors"];

          if (errors is List) {
            errorMsg = errors.join(", ");
          } else {
            errorMsg = errors.toString();
          }
        }
      }

      if (statusCode >= 200 && statusCode < 300) {
        return ApiResponse.success(decoded as T, statusCode: statusCode);
      } else if (statusCode == 401 || statusCode == 403) {
        _authController.logout();
        return ApiResponse.error(
          errorMsg ?? decoded?["errors"] ?? ErrorCode.unAuthorizedAccess,
          statusCode: statusCode,
        );
      } else if (statusCode == 422) {
        return ApiResponse.error(
          errorMsg ?? decoded?["errors"] ?? ErrorCode.validationError,
          statusCode: statusCode,
        );
      } else if (statusCode >= 500) {
        return ApiResponse.error(
          errorMsg ?? decoded?["errors"] ?? ErrorCode.serverError,
          statusCode: statusCode,
        );
      } else {
        return ApiResponse.error(
          errorMsg ?? decoded?["errors"] ?? ErrorCode.unexpectedError,
          statusCode: statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(e.toString(), statusCode: statusCode);
    }
  }


// ApiResponse<T> _handleResponse<T>(http.Response response) {
  //   final int statusCode = response.statusCode;
  //   final String responseBody = response.body;
  //
  //   try {
  //     final decoded = responseBody.isNotEmpty ? jsonDecode(responseBody) : null;
  //
  //     if (statusCode >= 200 && statusCode < 300) {
  //       return ApiResponse.success(decoded as T, statusCode: statusCode);
  //     } else if (statusCode == 401 || statusCode == 403) {
  //       // 🔐 Handle auth expiry
  //       _authController.logout();
  //       return ApiResponse.error(
  //         decoded["message"] ?? ErrorCode.unAuthorizedAccess,
  //         statusCode: statusCode,
  //       );
  //     } else if (statusCode == 422) {
  //       return ApiResponse.error(
  //         decoded["message"] ?? ErrorCode.validationError,
  //         statusCode: statusCode,
  //       );
  //     } else if (statusCode >= 500) {
  //       return ApiResponse.error(
  //         decoded["message"] ?? ErrorCode.serverError,
  //         statusCode: statusCode,
  //       );
  //     } else {
  //       return ApiResponse.error(
  //         decoded["message"] ?? ErrorCode.unexpectedError,
  //         statusCode: statusCode,
  //       );
  //     }
  //   } catch (e) {
  //     return ApiResponse.error(e.toString(), statusCode: statusCode);
  //   }
  // }
}
