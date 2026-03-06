class Auth {
  Auth({
    required this.status,
  });

  factory Auth.fromJson(Map<String, Object?> json) {
    return Auth(
      status: json['status']! as String,
    );
  }

  final String status;
}