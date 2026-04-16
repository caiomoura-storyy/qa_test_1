import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../app/service/auth_service.dart';
import '../theme/app_theme.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({this.displayName = 'Admin', super.key});

  final String displayName;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    final canPop = router.canPop();

    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      toolbarHeight: 72,
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: canPop ? 8 : 24,
      leading: canPop
          ? IconButton(
              tooltip: 'Back',
              icon: const Icon(Icons.arrow_back, color: AppTheme.mutedText),
              onPressed: router.pop,
            )
          : null,
      title: SvgPicture.asset(
        'assets/svg/storyy|magic_admin.svg',
        height: 36.0,
        semanticsLabel: 'magic admin',
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _UserAvatarMenu(displayName: displayName),
        ),
      ],
      shape: const Border(
        bottom: BorderSide(color: AppTheme.divider, width: 1),
      ),
    );
  }
}

class _UserAvatarMenu extends StatelessWidget {
  const _UserAvatarMenu({required this.displayName});

  final String displayName;

  String get _initials =>
      displayName.isEmpty ? '?' : displayName[0].toUpperCase();

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      alignmentOffset: const Offset(0, 8),
      style: MenuStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(
            Icons.logout,
            size: 18,
            color: AppTheme.mutedText,
          ),
          onPressed: () => AuthService.instance.logout(),
          child: const Text('Logout'),
        ),
      ],
      builder: (context, controller, _) {
        return Tooltip(
          message: displayName,
          child: Material(
            color: AppTheme.iconBg,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              customBorder: const CircleBorder(),
              hoverColor: Colors.black.withValues(alpha: 0.06),
              onTap: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              child: SizedBox(
                width: 36,
                height: 36,
                child: Center(
                  child: Text(
                    _initials,
                    style: const TextStyle(
                      color: AppTheme.mutedText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
