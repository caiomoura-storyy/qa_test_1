import 'package:flutter/material.dart';

import '../../app/service/auth_service.dart';
import '../../components/auth_card.dart';
import '../../theme/app_theme.dart';

class NoAccessPage extends StatelessWidget {
  const NoAccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'You do not have access to this system.\nIf you believe this is an error, please contact an administrator.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.danger,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => AuthService.instance.reset(),
            icon: const Icon(Icons.login, size: 18),
            label: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
