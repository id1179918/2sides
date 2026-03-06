import 'dart:convert';

class ApiError implements Exception {
  final String key;
  final String message;

  ApiError({
    required this.key,
    required this.message,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      key: json['key'] as String,
      message: json['message'] as String? ?? '',
    );
  }

  @override
  String toString() => 'ApiError(key: $key, message: $message)';
}

ApiError errorFromJson(String body) {
  final decoded = jsonDecode(body);

  if (decoded is Map<String, dynamic>) {
    return ApiError.fromJson(decoded);
  }

  throw FormatException('Invalid error response format');
}

