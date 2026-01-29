import '../network/api_client.dart';
import 'auth_service.dart';
import 'connectivity_service.dart';
import 'feature_flags_service.dart';
import 'permissions_service.dart';
import 'push_service.dart';

class AppBootstrap {
  AppBootstrap({
    required this.authService,
    required this.featureFlagsService,
    required this.permissionsService,
    required this.pushService,
    required this.connectivityService,
    required this.apiClient,
  });

  final AuthService authService;
  final FeatureFlagsService featureFlagsService;
  final PermissionsService permissionsService;
  final PushService pushService;
  final ConnectivityService connectivityService;
  final ApiClient apiClient;

  Future<void> initialize() async {
    await authService.restoreSession();
    await connectivityService.isOnline();

    await featureFlagsService.initialize(fetcher: () async {
      final response = await apiClient.get<Map<String, dynamic>>('/flags');
      final data = response.data ?? {};
      return data.map((key, value) => MapEntry(key, value == true));
    });

    await permissionsService.prewarm();
    await pushService.initialize();
  }
}
