import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/project.dart';
import '../../core/network/api_client.dart';
import '../../core/providers.dart';
import '../../core/storage/local_cache.dart';

final projectsControllerProvider =
    StateNotifierProvider<ProjectsController, AsyncValue<List<Project>>>((ref) {
  return ProjectsController(
    apiClient: ref.watch(apiClientProvider),
    localCache: ref.watch(localCacheProvider),
  )..load();
});

class ProjectsController extends StateNotifier<AsyncValue<List<Project>>> {
  ProjectsController({required this.apiClient, required this.localCache})
      : super(const AsyncLoading());

  final ApiClient apiClient;
  final LocalCache localCache;

  static const _cacheKey = 'projects_cache';

  Future<void> load() async {
    state = const AsyncLoading();
    try {
      final response = await apiClient.get<List<dynamic>>('/projects');
      final data = (response.data ?? [])
          .map((item) => Project.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      state = AsyncData(data);
      await localCache.setPref(_cacheKey, data.map((e) => e.toJson()).toList());
    } catch (err, stack) {
      final cached = localCache.getPref<List>(_cacheKey);
      if (cached != null) {
        final data = cached
            .map((item) => Project.fromJson(Map<String, dynamic>.from(item)))
            .toList();
        state = AsyncData(data);
        return;
      }
      state = AsyncError(err, stack);
    }
  }

  Future<void> createProject(String name) async {
    final response = await apiClient.post<Map<String, dynamic>>('/projects', data: {
      'name': name,
    });

    final created = Project.fromJson(Map<String, dynamic>.from(response.data ?? {}));
    final current = state.value ?? [];
    final updated = [created, ...current];
    state = AsyncData(updated);
    await localCache.setPref(_cacheKey, updated.map((e) => e.toJson()).toList());
  }
}
