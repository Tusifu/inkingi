class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

class LoginResponse {
  final bool isResettingPassword;
  final String refreshToken;
  final String token;
  final String userId;

  LoginResponse({
    required this.isResettingPassword,
    required this.refreshToken,
    required this.token,
    required this.userId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      isResettingPassword: json['isResettingPassword'],
      refreshToken: json['refreshToken'],
      token: json['token'],
      userId: json['userId'],
    );
  }
}
