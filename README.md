# magic admin

Web-only Flutter admin panel with a mocked authentication flow (login → 2FA → home) and session persistence.

## Getting started

Requirements: Flutter **3.38.5+** on the stable channel, with web enabled
(`flutter config --enable-web`).

## Credentials

The auth layer is mocked in [lib/app/service/auth_service.dart](lib/app/service/auth_service.dart).

| Field    | Value   |
| -------- | ------- |
| Email    | `admin` |
| Password | `admin` |
| 2FA code | `12345` |

After 3 failed login attempts the app locks out and shows `/no-access`.

## Routes

| Path         | Page           |
| ------------ | -------------- |
| `/login`     | LoginPage      |
| `/2fa`       | TwoFactorPage  |
| `/no-access` | NoAccessPage   |
| `/home`      | HomePage       |

Routing and guard logic live in [lib/router/](lib/router/). The `AuthGuard`
redirects users based on the current `AuthStage`, and the authenticated
session is persisted via `SharedPreferences`.

## Project structure

```
lib/
├── app/service/     # AuthService (singleton, ChangeNotifier)
├── components/      # Reusable widgets (AuthCard, AuthScaffold)
├── pages/           # One folder per screen
├── router/          # go_router config + AuthGuard
├── theme/           # Material 3 theme + design tokens
├── app_root.dart
└── main.dart
```
