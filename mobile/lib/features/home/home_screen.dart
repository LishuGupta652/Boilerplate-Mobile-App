import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../core/providers.dart';
import '../../core/models/auth_session.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionStreamProvider).valueOrNull;
    final flags =
        ref.watch(featureFlagsProvider).valueOrNull ?? const <String, bool>{};

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Welcome back,',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Gap(4),
        Text(
          session?.user.name ?? 'Explorer',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const Gap(24),
        _InfoCard(
          title: 'Environment',
          subtitle: 'Ready for staging and production builds',
          icon: Icons.rocket_launch_rounded,
        ),
        const Gap(16),
        Row(
          children: const [
            Expanded(
              child: _StatCard(
                label: 'Uptime',
                value: '99.9%',
              ),
            ),
            Gap(12),
            Expanded(
              child: _StatCard(
                label: 'Role',
                value: session?.roles.isNotEmpty == true
                    ? session!.roles.first
                    : 'Member',
              ),
            ),
          ],
        ),
        const Gap(24),
        Text('Quick Actions', style: Theme.of(context).textTheme.titleMedium),
        const Gap(12),
        _QuickActionGrid(flags: flags),
        const Gap(24),
        if (session?.hasRole('admin') == true ||
            session?.hasPermission('manage:projects') == true)
          _AdminCard(session: session!),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05);
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.subtitle, required this.icon});

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.secondaryContainer,
          ],
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 36, color: Theme.of(context).colorScheme.onPrimaryContainer),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const Gap(4),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const Gap(8),
          Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _QuickActionGrid extends StatelessWidget {
  const _QuickActionGrid({required this.flags});

  final Map<String, bool> flags;

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionTile(
        title: 'Create Project',
        subtitle: 'Spin up a new workspace',
        icon: Icons.add_circle_outline,
        enabled: flags['projects.create'] ?? true,
      ),
      _ActionTile(
        title: 'Invite Team',
        subtitle: 'Share access securely',
        icon: Icons.group_add_outlined,
        enabled: flags['teams.invites'] ?? true,
      ),
      _ActionTile(
        title: 'Enable Push',
        subtitle: 'Prepare notifications',
        icon: Icons.notifications_active_outlined,
        enabled: flags['push.enable'] ?? false,
      ),
      _ActionTile(
        title: 'Offline Sync',
        subtitle: 'Cache data locally',
        icon: Icons.wifi_off_outlined,
        enabled: flags['offline.sync'] ?? true,
      ),
    ];

    return Column(
      children: [
        for (var i = 0; i < actions.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(child: actions[i]),
                const Gap(12),
                Expanded(child: actions[i + 1]),
              ],
            ),
          ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.enabled,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: enabled
            ? Theme.of(context).colorScheme.surface
            : Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: enabled
              ? Theme.of(context).colorScheme.outlineVariant
              : Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: enabled ? Theme.of(context).colorScheme.primary : Colors.grey),
          const Gap(12),
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          const Gap(4),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _AdminCard extends StatelessWidget {
  const _AdminCard({required this.session});

  final AuthSession session;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_outlined, color: Theme.of(context).colorScheme.onPrimaryContainer),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Admin Controls', style: Theme.of(context).textTheme.titleMedium),
                const Gap(4),
                Text('RBAC enabled for ${session.roles.join(', ')}',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
