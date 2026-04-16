import 'package:go_router/go_router.dart';

import '../app/service/auth_service.dart';
import '../pages/home/home_page.dart';
import '../pages/login/login_page.dart';
import '../pages/no_access/no_access_page.dart';
import '../pages/two_factor/two_factor_page.dart';
import 'auth_guard.dart';

final appRouter = GoRouter(
  initialLocation: AuthGuard.loginRoute,
  refreshListenable: AuthService.instance,
  redirect: (context, state) => AuthGuard.redirect(state),
  routes: [
    GoRoute(
      path: AuthGuard.loginRoute,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AuthGuard.twoFactorRoute,
      builder: (context, state) => const TwoFactorPage(),
    ),
    GoRoute(
      path: AuthGuard.noAccessRoute,
      builder: (context, state) => const NoAccessPage(),
    ),
    GoRoute(
      path: AuthGuard.homeRoute,
      builder: (context, state) => const HomePage(),
    ),
  ],
);
