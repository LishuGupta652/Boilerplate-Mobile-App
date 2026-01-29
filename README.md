# Mobile Boilerplate (Flutter + NestJS)

Production-ready starter for iOS and Android with KindeAuth, RBAC, offline caching, and a NestJS backend.

## What's inside
- `mobile/` Flutter app with modern UI, networking layer, offline cache, permissions, and feature flags.
- `backend/` NestJS API with Kinde JWT auth, RBAC guards, and sample endpoints.
- Docker + Compose for the backend.

## Quick start
```bash
# Backend
cd backend
cp .env.example .env
npm install
npm run start:dev

# Mobile (in a new terminal)
cd ../mobile
cp .env.example assets/.env
flutter pub get
flutter run -d ios
```

## Feature highlights
- KindeAuth (OIDC) + RBAC permissions
- Offline caching (Hive) + connectivity banner
- Networking layer (Dio + retries + auth)
- Feature flags (client + backend)
- Customizable theme + modern UI
- Splash screen + app icons

## Docker
```bash
docker compose up --build
```

## Versioning + releases
See `docs/VERSIONING.md` and `docs/RELEASE_NOTES_TEMPLATE.md`.

## Rollback strategy
See `docs/ROLLBACK.md` for feature flags + phased rollout guidance.
