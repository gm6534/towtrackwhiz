// core/network/api_response.dart
class ApiResponse<T> {
  final T? data;
  final String? message;
  final int? statusCode;
  final bool isSuccess;

  ApiResponse.success(this.data, {this.statusCode})
      : message = null,
        isSuccess = true;

  ApiResponse.error(this.message, {this.statusCode})
      : data = null,
        isSuccess = false;
}
