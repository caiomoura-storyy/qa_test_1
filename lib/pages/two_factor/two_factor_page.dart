import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/service/auth_service.dart';
import '../../components/auth_card.dart';
import '../../theme/app_theme.dart';

class TwoFactorPage extends StatefulWidget {
  const TwoFactorPage({super.key});

  @override
  State<TwoFactorPage> createState() => _TwoFactorPageState();
}

class _TwoFactorPageState extends State<TwoFactorPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    final ok = await AuthService.instance.verifyTwoFactor(
      _codeController.text.trim(),
    );

    if (!mounted) return;

    if (!ok) {
      setState(() {
        _submitting = false;
        _errorMessage = 'Invalid code.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Please enter the 2FA code sent to your email.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF667085), fontSize: 12),
            ),
            const SizedBox(height: 16),
            TextFormField(
              autofocus: true,
              controller: _codeController,
              enabled: !_submitting,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(hintText: 'Enter code here.'),
              onFieldSubmitted: (_) => _handleSubmit(),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter the code.' : null,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.danger,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _submitting ? null : _handleSubmit,
              icon: _submitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.login, size: 18),
              label: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
