import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers.dart';

class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityServiceProvider);

    return StreamBuilder<bool>(
      stream: connectivity.onStatusChange,
      initialData: connectivity.isOnlineSync,
      builder: (context, snapshot) {
        final online = snapshot.data ?? true;
        if (online) return const SizedBox.shrink();
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: Theme.of(context).colorScheme.errorContainer,
          child: Row(
            children: [
              Icon(Icons.cloud_off, color: Theme.of(context).colorScheme.onErrorContainer),
              const SizedBox(width: 8),
              Text(
                'You are offline. Showing cached data.',
                style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
              ),
            ],
          ),
        );
      },
    );
  }
}
