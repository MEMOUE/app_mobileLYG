import 'user_model.dart';

class AuthResponse {
  final String token;
  final String refreshToken;
  final UserModel user;
  final int expiresIn;

  AuthResponse({
    required this.token,
    required this.refreshToken,
    required this.user,
    required this.expiresIn,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      refreshToken: json['refreshToken'],
      user: UserModel.fromJson(json['user']),
      expiresIn: json['expiresIn'],
    );
  }
}