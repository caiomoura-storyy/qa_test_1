import 'package:shared_preferences/shared_preferences.dart';

class AccountProfile {
  const AccountProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.jobTitle,
    required this.department,
    required this.address,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String jobTitle;
  final String department;
  final String address;
}

class AccountService {
  AccountService._();
  static final AccountService instance = AccountService._();

  static const _firstNameKey = 'account.firstName';
  static const _lastNameKey = 'account.lastName';
  static const _emailKey = 'account.email';
  static const _phoneKey = 'account.phone';
  static const _jobTitleKey = 'account.jobTitle';
  static const _departmentKey = 'account.department';
  static const _addressKey = 'account.address';

  static const _defaults = AccountProfile(
    firstName: 'Admin',
    lastName: 'User',
    email: 'admin@storyy.test',
    phone: '+1 555 0100',
    jobTitle: 'Administrator',
    department: 'Operations',
    address: '42 Diagon Alley, London',
  );

  AccountProfile _profile = _defaults;
  bool _initialized = false;

  AccountProfile get profile => _profile;

  Future<void> init() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    _profile = AccountProfile(
      firstName: prefs.getString(_firstNameKey) ?? _defaults.firstName,
      lastName: prefs.getString(_lastNameKey) ?? _defaults.lastName,
      email: prefs.getString(_emailKey) ?? _defaults.email,
      phone: prefs.getString(_phoneKey) ?? _defaults.phone,
      jobTitle: prefs.getString(_jobTitleKey) ?? _defaults.jobTitle,
      department: prefs.getString(_departmentKey) ?? _defaults.department,
      address: prefs.getString(_addressKey) ?? _defaults.address,
    );
    _initialized = true;
  }

  Future<void> save(AccountProfile profile) async {
    _profile = profile;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_firstNameKey, profile.firstName);
    await prefs.setString(_lastNameKey, profile.lastName);
    await prefs.setString(_emailKey, profile.email);
    await prefs.setString(_phoneKey, profile.phone);
    await prefs.setString(_jobTitleKey, profile.jobTitle);
    await prefs.setString(_departmentKey, profile.department);
    await prefs.setString(_addressKey, profile.address);
  }
}
