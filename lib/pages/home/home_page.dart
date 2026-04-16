import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../components/main_app_bar.dart';
import '../../theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _displayName = 'Admin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(displayName: _displayName),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 32),
                  child: Text(
                    'Welcome, $_displayName.',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF222222),
                    ),
                  ),
                ),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: const _HomeMenuCard(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeMenuCard extends StatelessWidget {
  const _HomeMenuCard();

  static const _entries = <_MenuEntry>[
    _MenuEntry(icon: Icons.manage_accounts_outlined, title: 'My Account'),
    _MenuEntry(
      icon: Icons.hub_outlined,
      title: 'My Pod',
      subtitle: 'Submitted projects and fulfillment tickets.',
      route: '/my-pod',
    ),
    // _MenuEntry(
    //   icon: Icons.folder_outlined,
    //   title: 'Projects',
    //   subtitle: 'Submitted projects and fulfillment tickets.',
    // ),
    // _MenuEntry(
    //   icon: Icons.people_outline,
    //   title: 'Customers',
    //   subtitle: 'View users and teams that are part of our customer base.',
    // ),
    // _MenuEntry(
    //   icon: Icons.groups_outlined,
    //   title: 'Manage Pods',
    //   subtitle: 'Manage Pod members and assigned clients.',
    // ),
    // _MenuEntry(
    //   icon: Icons.admin_panel_settings_outlined,
    //   title: 'Admin User Management',
    //   subtitle: 'Adjust permissions for Storyy Admin users.',
    // ),
    // _MenuEntry(
    //   icon: Icons.auto_stories_outlined,
    //   title: 'Reports (COMING SOON)',
    //   subtitle: 'See business reports and stats.',
    //   enabled: false,
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          children: [
            for (int i = 0; i < _entries.length; i++) ...[
              _MenuItemTile(entry: _entries[i]),
              if (i < _entries.length - 1)
                const Divider(height: 1, thickness: 1, color: AppTheme.divider),
            ],
          ],
        ),
      ),
    );
  }
}

class _MenuEntry {
  const _MenuEntry({
    required this.icon,
    required this.title,
    this.subtitle,
    // ignore: unused_element_parameter
    this.enabled = true,
    this.route,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool enabled;
  final String? route;
}

class _MenuItemTile extends StatelessWidget {
  const _MenuItemTile({required this.entry});

  final _MenuEntry entry;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final disabled = !entry.enabled;

    final route = entry.route;
    return InkWell(
      onTap: disabled
          ? null
          : (route == null ? () {} : () => context.push(route)),
      hoverColor: const Color(0xFFF9FAFB),
      splashColor: primary.withValues(alpha: 0.08),
      highlightColor: primary.withValues(alpha: 0.04),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppTheme.iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(entry.icon, size: 20, color: AppTheme.mutedText),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: disabled
                          ? AppTheme.mutedText
                          : const Color(0xFF1F2937),
                    ),
                  ),
                  if (entry.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      entry.subtitle!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.mutedText,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.arrow_forward,
              size: 20,
              color: disabled ? AppTheme.mutedText : primary,
            ),
          ],
        ),
      ),
    );
  }
}
