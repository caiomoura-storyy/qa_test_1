import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../app/service/auth_service.dart';
import '../pages/home/home_page.dart';
import '../pages/login/login_page.dart';
import '../pages/no_access/no_access_page.dart';
import '../pages/not_found/not_found_page.dart';
import '../pages/two_factor/two_factor_page.dart';
import 'auth_guard.dart';

NoTransitionPage<void> _page(Widget child) => NoTransitionPage(child: child);

final appRouter = GoRouter(
  initialLocation: AuthGuard.loginRoute,
  refreshListenable: AuthService.instance,
  redirect: (context, state) => AuthGuard.redirect(state),
  errorPageBuilder: (context, state) => _page(const NotFoundPage()),
  routes: [
    GoRoute(
      path: AuthGuard.loginRoute,
      pageBuilder: (context, state) => _page(const LoginPage()),
    ),
    GoRoute(
      path: AuthGuard.twoFactorRoute,
      pageBuilder: (context, state) => _page(const TwoFactorPage()),
    ),
    GoRoute(
      path: AuthGuard.noAccessRoute,
      pageBuilder: (context, state) => _page(const NoAccessPage()),
    ),
    GoRoute(
      path: AuthGuard.homeRoute,
      pageBuilder: (context, state) => _page(const HomePage()),
    ),
  ],
);
