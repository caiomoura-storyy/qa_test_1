import 'package:flutter/material.dart';

import 'app/service/account_service.dart';
import 'app/service/auth_service.dart';
import 'app_root.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.instance.init();
  await AccountService.instance.init();
  runApp(const AppRoot());
}
