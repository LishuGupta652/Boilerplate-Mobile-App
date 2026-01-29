import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  final String apiBaseUrl;
  final String kindeIssuerUrl;
  final String kindeClientId;
  final String kindeRedirectUri;
  final String kindeLogoutRedirectUri;
  final String kindeAudience;
  final List<String> kindeScopes;
  final bool enablePush;
  final Duration featureFlagsPollInterval;

  const AppConfig({
    required this.apiBaseUrl,
    required this.kindeIssuerUrl,
    required this.kindeClientId,
    required this.kindeRedirectUri,
    required this.kindeLogoutRedirectUri,
    required this.kindeAudience,
    required this.kindeScopes,
    required this.enablePush,
    required this.featureFlagsPollInterval,
  });

  static Future<AppConfig> load() async {
    await dotenv.load(fileName: 'assets/.env');

    final pollSeconds = int.tryParse(dotenv.env['FEATURE_FLAGS_POLL_SECONDS'] ?? '') ?? 120;

    return AppConfig(
      apiBaseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:4000',
      kindeIssuerUrl: dotenv.env['KINDE_ISSUER_URL'] ?? '',
      kindeClientId: dotenv.env['KINDE_CLIENT_ID'] ?? '',
      kindeRedirectUri: dotenv.env['KINDE_REDIRECT_URI'] ?? '',
      kindeLogoutRedirectUri: dotenv.env['KINDE_LOGOUT_REDIRECT_URI'] ?? '',
      kindeAudience: dotenv.env['KINDE_AUDIENCE'] ?? '',
      kindeScopes: (dotenv.env['KINDE_SCOPES'] ?? 'openid profile email offline_access')
          .split(' ')
          .where((scope) => scope.trim().isNotEmpty)
          .toList(),
      enablePush: (dotenv.env['ENABLE_PUSH'] ?? 'false').toLowerCase() == 'true',
      featureFlagsPollInterval: Duration(seconds: pollSeconds),
    );
  }
}
