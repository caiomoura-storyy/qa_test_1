import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../components/main_app_bar.dart';
import '../../router/auth_guard.dart';
import '../../theme/app_theme.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  static const _title = Color(0xFF344054);
  static const _body = AppTheme.mutedText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MainAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '404',
                  style: TextStyle(
                    fontSize: 128,
                    fontWeight: FontWeight.w800,
                    color: _title,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Page Not Found',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: _title,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "We're sorry, the page you requested could not be found.\nPlease go back to the homepage.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _body,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                FilledButton(
                  onPressed: () => context.go(AuthGuard.homeRoute),
                  style: FilledButton.styleFrom(
                    backgroundColor: _title,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 48),
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    shape: const StadiumBorder(),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  child: const Text('GO HOME'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
