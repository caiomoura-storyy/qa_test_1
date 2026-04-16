import 'package:go_router/go_router.dart';

import '../app/service/auth_service.dart';

class AuthGuard {
  const AuthGuard._();

  static const String loginRoute = '/login';
  static const String twoFactorRoute = '/2fa';
  static const String noAccessRoute = '/no-access';
  static const String homeRoute = '/home';

  static const Set<String> _authFlowRoutes = {
    loginRoute,
    twoFactorRoute,
    noAccessRoute,
  };

  static String? redirect(GoRouterState state) {
    final stage = AuthService.instance.stage;
    final loc = state.matchedLocation;

    switch (stage) {
      case AuthStage.lockedOut:
        return loc == noAccessRoute ? null : noAccessRoute;
      case AuthStage.pendingTwoFactor:
        return loc == twoFactorRoute ? null : twoFactorRoute;
      case AuthStage.authenticated:
        return _authFlowRoutes.contains(loc) ? homeRoute : null;
      case AuthStage.loggedOut:
        return loc == loginRoute ? null : loginRoute;
    }
  }
}
