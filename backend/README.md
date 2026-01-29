# Mobile Boilerplate Backend

NestJS backend for the Flutter boilerplate. Includes Kinde JWT auth, RBAC, feature flags, and a simple Projects API.

## Requirements
- Node.js 18+
- npm

## Setup
```bash
cp .env.example .env
npm install
npm run start:dev
```

## Environment
- `PORT`: API port (default 4000)
- `KINDE_ISSUER_URL`: e.g. `https://YOUR_KINDE_DOMAIN.kinde.com`
- `KINDE_AUDIENCE`: API audience configured in Kinde

## Endpoints
- `GET /health` — health check
- `GET /me` — returns user profile (JWT required)
- `GET /flags` — feature flags for current user (JWT required)
- `GET /projects` — list projects (requires `projects:read`)
- `POST /projects` — create project (requires `projects:write`)

## RBAC
RBAC is enforced via `RolesGuard` and `PermissionsGuard`. Permissions are pulled from the JWT `permissions` claim.

## Testing
```bash
npm run test
```

## Docker
```bash
docker build -t mobile-backend .
docker run --env-file .env -p 4000:4000 mobile-backend
```
