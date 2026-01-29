import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/services/auth_service.dart';

final loginControllerProvider =
    StateNotifierProvider<LoginController, AsyncValue<void>>((ref) {
  return LoginController(ref.read(authServiceProvider));
});

class LoginController extends StateNotifier<AsyncValue<void>> {
  LoginController(this._authService) : super(const AsyncData(null));

  final AuthService _authService;

  Future<void> signIn() async {
    state = const AsyncLoading();
    try {
      await _authService.signIn();
      state = const AsyncData(null);
    } catch (err, stack) {
      state = AsyncError(err, stack);
    }
  }
}
