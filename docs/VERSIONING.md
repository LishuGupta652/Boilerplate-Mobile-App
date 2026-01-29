# Versioning Scheme

We use SemVer (`MAJOR.MINOR.PATCH`) plus a build number for platform stores.

## Flutter
- `pubspec.yaml`: `version: MAJOR.MINOR.PATCH+BUILD`
- `MAJOR.MINOR.PATCH` maps to iOS `CFBundleShortVersionString` and Android `versionName`.
- `BUILD` maps to iOS `CFBundleVersion` and Android `versionCode`.

## Release cadence
- **Patch**: bug fixes, no breaking API/UI
- **Minor**: new features, backwards compatible
- **Major**: breaking changes or redesigns

## Build number rules
- Increment `BUILD` on every store submission
- Reset `BUILD` only when moving to a new major version
