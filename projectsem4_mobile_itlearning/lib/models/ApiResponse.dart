class ApiResponse {
  final bool success;
  final int code;
  final String message;
  final dynamic data;
  final dynamic errors;

  ApiResponse({
    required this.success,
    required this.code,
    required this.message,
    this.data,
    this.errors,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'],
      code: json['code'],
      message: json['message'],
      data: json['data'],
      errors: json['errors'],
    );
  }
}
