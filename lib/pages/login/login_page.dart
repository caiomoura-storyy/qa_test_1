import 'package:flutter/material.dart';

import '../../app/service/auth_service.dart';
import '../../components/auth_card.dart';
import '../../theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    final ok = await AuthService.instance.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (!ok) {
      setState(() {
        _submitting = false;
        _errorMessage = 'Invalid email or password.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      footer: const _WarningFooter(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _emailController,
              enabled: !_submitting,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.username],
              decoration: const InputDecoration(hintText: 'Email'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter your email.' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              enabled: !_submitting,
              obscureText: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              decoration: const InputDecoration(hintText: 'Password'),
              onFieldSubmitted: (_) => _handleLogin(),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Enter your password.' : null,
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
              onPressed: _submitting ? null : _handleLogin,
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
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: _submitting ? null : () {},
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF667085),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                child: const Text('Forgot password?'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WarningFooter extends StatelessWidget {
  const _WarningFooter();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'ENEMIES OF THE HEIR, BEWARE',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.danger,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Authorized use only.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.danger,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
