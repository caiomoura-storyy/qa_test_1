import 'package:flutter/material.dart';

import '../../app/service/account_service.dart';
import '../../components/main_app_bar.dart';
import '../../theme/app_theme.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _jobTitle;
  late final TextEditingController _department;
  late final TextEditingController _address;

  late final List<_TrackedField> _tracked;
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    final profile = AccountService.instance.profile;
    _firstName = TextEditingController(text: profile.firstName);
    _lastName = TextEditingController(text: profile.lastName);
    _email = TextEditingController(text: profile.email);
    _phone = TextEditingController(text: profile.phone);
    _jobTitle = TextEditingController(text: profile.jobTitle);
    _department = TextEditingController(text: profile.department);
    _address = TextEditingController(text: profile.address);
    _tracked = [
      _TrackedField(_firstName),
      _TrackedField(_lastName),
      _TrackedField(_email),
      _TrackedField(_phone),
      _TrackedField(_jobTitle),
      _TrackedField(_address),
    ];
    for (final f in _tracked) {
      f.controller.addListener(_recomputeDirty);
    }
  }

  void _recomputeDirty() {
    final dirty = _tracked.any((f) => f.controller.text != f.baseline);
    if (dirty != _isDirty) setState(() => _isDirty = dirty);
  }

  @override
  void dispose() {
    for (final f in _tracked) {
      f.controller.removeListener(_recomputeDirty);
    }
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _jobTitle.dispose();
    _department.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    await AccountService.instance.save(
      AccountProfile(
        firstName: _firstName.text,
        lastName: _lastName.text,
        email: _email.text,
        phone: _phone.text,
        jobTitle: _jobTitle.text,
        department: _department.text,
        address: _address.text,
      ),
    );

    if (!mounted) return;
    setState(() {
      for (final f in _tracked) {
        f.baseline = f.controller.text;
      }
      _isDirty = false;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Account updated.')));
  }

  Future<bool> _confirmDiscard() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Discard changes?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'You have unsaved changes. Are you sure you want to leave and discard them?',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.mutedText,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Keep editing'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.danger,
                    side: const BorderSide(color: AppTheme.danger),
                    minimumSize: const Size.fromHeight(40),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Discard'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final confirmed = await _confirmDiscard();
        if (!confirmed || !mounted) return;
        if (context.mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: const MainAppBar(),
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
                    'My Account',
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
                    child: _buildCard(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      padding: const EdgeInsets.all(32),
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
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _LabeledField(
                      label: 'First Name',
                      order: 1,
                      isRequired: true,
                      child: TextFormField(
                        controller: _firstName,
                        decoration: const InputDecoration(
                          hintText: 'First name',
                        ),
                        validator: _required,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _LabeledField(
                      label: 'Last Name',
                      order: 3,
                      child: TextFormField(
                        controller: _lastName,
                        decoration: const InputDecoration(
                          hintText: 'Last name',
                        ),
                        validator: _required,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _LabeledField(
                label: 'Email',
                order: 2,
                child: TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'you@example.com',
                  ),
                  validator: _email_,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _LabeledField(
                      label: 'Phone Number',
                      order: 4,
                      child: TextFormField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: '+1 555 0100',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _LabeledField(
                      label: 'Job Title',
                      order: 5,
                      child: TextFormField(
                        controller: _jobTitle,
                        decoration: const InputDecoration(
                          hintText: 'Job title',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _LabeledField(
                label: 'Department',
                order: 6,
                child: TextFormField(
                  controller: _department,
                  decoration: const InputDecoration(hintText: 'Department'),
                ),
              ),
              const SizedBox(height: 20),
              _LabeledField(
                label: 'Address',
                order: 8,
                child: TextFormField(
                  controller: _address,
                  decoration: const InputDecoration(
                    hintText: 'Street, city, country',
                  ),
                ),
              ),
              const SizedBox(height: 28),
              FocusTraversalOrder(
                order: const NumericFocusOrder(7),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: _save,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(120, 44),
                    ),
                    child: const Text('Save'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'This field is required.' : null;

  // ignore: non_constant_identifier_names
  static String? _email_(String? v) {
    if (v == null || v.trim().isEmpty) return 'This field is required.';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
    return ok ? null : 'Enter a valid email address.';
  }
}

class _TrackedField {
  _TrackedField(this.controller) : baseline = controller.text;

  final TextEditingController controller;
  String baseline;
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.order,
    required this.child,
    this.isRequired = false,
  });

  final String label;
  final double order;
  final Widget child;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Color(0xFF344054),
    );

    return FocusTraversalOrder(
      order: NumericFocusOrder(order),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: labelStyle,
              children: isRequired
                  ? const [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: AppTheme.danger),
                      ),
                    ]
                  : null,
            ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}
