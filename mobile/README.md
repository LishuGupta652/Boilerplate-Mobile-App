# Mobile Boilerplate (Flutter)

A modern Flutter starter with KindeAuth, RBAC-aware UI, offline caching, and a production-ready architecture.

## Requirements
- Flutter SDK (stable)
- Xcode + iOS Simulator
- Android Studio / Android SDKs

## Setup
```bash
cp .env.example assets/.env
flutter pub get
```

For Android emulators, set `API_BASE_URL=http://10.0.2.2:4000` in `assets/.env`.

Generate assets:
```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

Run:
```bash
flutter run -d ios
flutter run -d android
```

## KindeAuth
Update `assets/.env` with your Kinde domain and client IDs.

Required redirect URIs in Kinde:
- `com.example.mobileapp://login-callback`
- `com.example.mobileapp://logout-callback`

## RBAC
Tokens should include `roles` and `permissions` claims. The UI checks permissions like `projects:write` to enable actions.

## Offline + Networking
- Dio + retry + cache interceptor
- Offline banner + cached GET responses (Hive)

## Security
- Tokens stored in `flutter_secure_storage`
- Automatic token refresh when expired
- HTTPS enforced in release mode

## Push Notifications
Push wiring is stubbed in `PushService`. Enable by:
1. Add Firebase/APNS configs.
2. Add a real provider in `core/services/push_service.dart`.
3. Set `ENABLE_PUSH=true` in `assets/.env`.

## Permissions
Uses `permission_handler`. Add any extra permission strings in:
- `ios/Runner/Info.plist`
- `android/app/src/main/AndroidManifest.xml`

## Testing
```bash
flutter test
```
