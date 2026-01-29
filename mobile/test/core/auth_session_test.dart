import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/models/auth_session.dart';
import 'package:mobile_app/core/models/user_profile.dart';

void main() {
  test('auth session role and permission checks', () {
    final session = AuthSession(
      accessToken: 'token',
      idToken: 'id',
      refreshToken: null,
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
      user: const UserProfile(id: '1', email: 'test@example.com', name: 'Tester'),
      roles: const ['admin'],
      permissions: const ['projects:write'],
    );

    expect(session.hasRole('admin'), isTrue);
    expect(session.hasRole('member'), isFalse);
    expect(session.hasPermission('projects:write'), isTrue);
    expect(session.hasPermission('projects:read'), isFalse);
  });
}
