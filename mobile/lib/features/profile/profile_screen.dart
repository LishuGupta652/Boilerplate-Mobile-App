import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../core/providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionStreamProvider).valueOrNull;
    final themeMode = ref.watch(themeModeProvider);
    final colorSchemes = ref.watch(appColorSchemeProvider);
    final config = ref.watch(appConfigProvider);

    final seedOptions = [
      const Color(0xFF2DD4BF),
      const Color(0xFF38BDF8),
      const Color(0xFFF97316),
      const Color(0xFFA855F7),
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Profile', style: Theme.of(context).textTheme.headlineMedium),
        const Gap(16),
        _ProfileHeader(
          name: session?.user.name ?? 'Guest',
          email: session?.user.email ?? 'Not signed in',
        ),
        const Gap(24),
        Text('Appearance', style: Theme.of(context).textTheme.titleMedium),
        const Gap(12),
        _SegmentedThemeSelector(
          current: themeMode,
          onChanged: (mode) => ref.read(themeModeProvider.notifier).setMode(mode),
        ),
        const Gap(16),
        Wrap(
          spacing: 12,
          children: [
            for (final color in seedOptions)
              _ColorSwatch(
                color: color,
                selected: color.value == colorSchemes.light.primary.value,
                onTap: () => ref.read(appColorSchemeProvider.notifier).updateSeed(color),
              ),
          ],
        ),
        const Gap(24),
        Text('Security & Permissions',
            style: Theme.of(context).textTheme.titleMedium),
        const Gap(12),
        _ActionTile(
          title: 'Request notifications',
          subtitle: 'Enable push permissions',
          icon: Icons.notifications_active_outlined,
          onTap: () async {
            await ref.read(permissionsServiceProvider).requestNotifications();
          },
        ),
        const Gap(12),
        _ActionTile(
          title: 'Check app settings',
          subtitle: 'Manage system permissions',
          icon: Icons.settings_outlined,
          onTap: () => ref.read(permissionsServiceProvider).openSettings(),
        ),
        const Gap(24),
        Text('Push notifications',
            style: Theme.of(context).textTheme.titleMedium),
        const Gap(12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                config.enablePush ? 'Push enabled' : 'Push disabled',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Gap(8),
              Text(
                config.enablePush
                    ? 'Ready to hook into Firebase/APNS.'
                    : 'Set ENABLE_PUSH=true after configuring your provider.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Gap(12),
              FilledButton(
                onPressed: config.enablePush
                    ? () => ref.read(pushServiceProvider).emitTestMessage()
                    : null,
                child: const Text('Send test message'),
              ),
            ],
          ),
        ),
        const Gap(24),
        _ActionTile(
          title: 'Sign out',
          subtitle: 'Clear secure tokens',
          icon: Icons.logout_rounded,
          onTap: () => ref.read(authServiceProvider).signOut(),
        ),
        const Gap(32),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.name, required this.email});

  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'U',
              style: TextStyle(color: Theme.of(context).colorScheme.primaryContainer),
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleMedium),
                const Gap(4),
                Text(email, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentedThemeSelector extends StatelessWidget {
  const _SegmentedThemeSelector({required this.current, required this.onChanged});

  final ThemeMode current;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ThemeMode>(
      segments: const [
        ButtonSegment(value: ThemeMode.system, label: Text('System')),
        ButtonSegment(value: ThemeMode.light, label: Text('Light')),
        ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
      ],
      selected: {current},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({required this.color, required this.selected, required this.onTap});

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: selected ? Theme.of(context).colorScheme.onPrimary : Colors.transparent,
            width: 3,
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  const Gap(2),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
