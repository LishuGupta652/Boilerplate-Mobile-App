import 'user_profile.dart';

class AuthSession {
  final String accessToken;
  final String idToken;
  final String? refreshToken;
  final DateTime? expiresAt;
  final UserProfile user;
  final List<String> roles;
  final List<String> permissions;

  const AuthSession({
    required this.accessToken,
    required this.idToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.user,
    required this.roles,
    required this.permissions,
  });

  bool get isExpired =>
      expiresAt != null && DateTime.now().isAfter(expiresAt!);

  bool hasRole(String role) => roles.contains(role);
  bool hasPermission(String permission) => permissions.contains(permission);
}
