import 'dart:async';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../config/app_config.dart';
import '../models/auth_session.dart';
import '../models/user_profile.dart';
import '../storage/secure_store.dart';

class AuthService {
  AuthService({required this.config, required this.secureStore});

  final AppConfig config;
  final SecureStore secureStore;
  final FlutterAppAuth _appAuth = FlutterAppAuth();
  final StreamController<AuthSession?> _sessionController =
      StreamController<AuthSession?>.broadcast();

  AuthSession? _session;

  Stream<AuthSession?> get sessionStream => _sessionController.stream;

  AuthSession? get currentSession => _session;

  Future<void> restoreSession() async {
    final accessToken = await secureStore.read(_Keys.accessToken);
    final idToken = await secureStore.read(_Keys.idToken);
    final refreshToken = await secureStore.read(_Keys.refreshToken);
    final expiresAtRaw = await secureStore.read(_Keys.expiresAt);

    if (accessToken == null || idToken == null) {
      _emit(null);
      return;
    }

    final expiresAt = expiresAtRaw != null ? DateTime.tryParse(expiresAtRaw) : null;
    var session = _buildSession(
      accessToken: accessToken,
      idToken: idToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );

    if (session.isExpired && refreshToken != null) {
      final refreshed = await _refreshToken(refreshToken, idTokenHint: idToken);
      if (refreshed != null) {
        session = refreshed;
      } else {
        await secureStore.clear();
        _emit(null);
        return;
      }
    }

    _emit(session);
  }

  Future<AuthSession> signIn() async {
    final result = await _appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        config.kindeClientId,
        config.kindeRedirectUri,
        issuer: config.kindeIssuerUrl,
        scopes: config.kindeScopes,
        additionalParameters: {
          'audience': config.kindeAudience,
        },
      ),
    );

    if (result?.accessToken == null || result?.idToken == null) {
      throw StateError('Authentication failed. Missing tokens.');
    }

    final session = _buildSession(
      accessToken: result!.accessToken!,
      idToken: result.idToken!,
      refreshToken: result.refreshToken,
      expiresAt: result.accessTokenExpirationDateTime,
    );

    await _persist(session);
    _emit(session);
    return session;
  }

  Future<void> signOut() async {
    final idToken = _session?.idToken ?? await secureStore.read(_Keys.idToken);
    if (idToken != null && config.kindeLogoutRedirectUri.isNotEmpty) {
      await _appAuth.endSession(EndSessionRequest(
        idTokenHint: idToken,
        postLogoutRedirectUrl: config.kindeLogoutRedirectUri,
        issuer: config.kindeIssuerUrl,
      ));
    }

    await secureStore.clear();
    _emit(null);
  }

  Future<String?> getAccessToken() async {
    if (_session == null) return null;
    if (_session!.isExpired && _session!.refreshToken != null) {
      final refreshed = await _refreshToken(_session!.refreshToken!, idTokenHint: _session!.idToken);
      if (refreshed != null) {
        await _persist(refreshed);
        _emit(refreshed);
      } else {
        await secureStore.clear();
        _emit(null);
        return null;
      }
    }
    return _session?.accessToken;
  }

  bool hasRole(String role) => _session?.roles.contains(role) ?? false;
  bool hasPermission(String permission) =>
      _session?.permissions.contains(permission) ?? false;

  void _emit(AuthSession? session) {
    _session = session;
    _sessionController.add(session);
  }

  AuthSession _buildSession({
    required String accessToken,
    required String idToken,
    required String? refreshToken,
    required DateTime? expiresAt,
  }) {
    final accessClaims = Jwt.parseJwt(accessToken);
    final idClaims = Jwt.parseJwt(idToken);

    final permissions = List<String>.from(accessClaims['permissions'] ?? const []);
    final roles = List<String>.from(accessClaims['roles'] ?? const []);

    return AuthSession(
      accessToken: accessToken,
      idToken: idToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt ?? Jwt.getExpiryDate(accessToken),
      user: UserProfile.fromClaims(idClaims),
      roles: roles,
      permissions: permissions,
    );
  }

  Future<void> _persist(AuthSession session) async {
    await secureStore.write(_Keys.accessToken, session.accessToken);
    await secureStore.write(_Keys.idToken, session.idToken);
    if (session.refreshToken != null) {
      await secureStore.write(_Keys.refreshToken, session.refreshToken!);
    }
    if (session.expiresAt != null) {
      await secureStore.write(_Keys.expiresAt, session.expiresAt!.toIso8601String());
    }
  }

  Future<AuthSession?> _refreshToken(String refreshToken,
      {required String idTokenHint}) async {
    final response = await _appAuth.token(TokenRequest(
      config.kindeClientId,
      config.kindeRedirectUri,
      issuer: config.kindeIssuerUrl,
      refreshToken: refreshToken,
      scopes: config.kindeScopes,
      additionalParameters: {
        'audience': config.kindeAudience,
      },
    ));

    if (response?.accessToken == null || response?.idToken == null) {
      return null;
    }

    return _buildSession(
      accessToken: response!.accessToken!,
      idToken: response.idToken!,
      refreshToken: response.refreshToken ?? refreshToken,
      expiresAt: response.accessTokenExpirationDateTime,
    );
  }
}

class _Keys {
  static const accessToken = 'access_token';
  static const idToken = 'id_token';
  static const refreshToken = 'refresh_token';
  static const expiresAt = 'expires_at';
}
