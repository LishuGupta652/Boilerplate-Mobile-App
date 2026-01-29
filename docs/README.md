# Documentation Site

This folder contains the docs website for Mobile Boilerplate.

## Structure
- `docs/site/` static site assets
- `docs/VERSIONING.md` versioning policy
- `docs/RELEASE_NOTES_TEMPLATE.md` release notes template
- `docs/ROLLBACK.md` rollback strategy

## Local preview
```bash
cd docs/site
python3 -m http.server 8080
```

Open http://localhost:8080

## Deployment
The site is static and can be hosted on GitHub Pages, Netlify, or any static host.
A `CNAME` file is provided for:

```
mobile-boilerplate.lishugupta.in
```
