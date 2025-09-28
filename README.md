# Green & Sky-Blue Keycloak Login Theme Container

This repository packages a custom Keycloak login theme inspired by a green and sky-blue palette. The theme ships inside a Docker image built from `quay.io/keycloak/keycloak:26.3.5`, providing a responsive hero layout that mirrors the supplied visual reference while remaining mobile-friendly.

## Project Structure

```
.
├── Dockerfile                     # Multi-stage build that jars the theme and adds it to Keycloak
├── docker-compose.yml             # Local development profile
├── theme/
│   └── green-sky-login/
│       └── login/
│           ├── login.ftl          # Custom Freemarker login template
│           ├── resources/
│           │   └── css/theme.css  # Responsive, gradient-driven styling
│           └── theme.properties   # Registers assets and inherits keycloak.v2
└── .github/workflows/build-and-push.yml
```

## Building the Image Locally

```bash
# Build the optimized Keycloak image with the bundled theme
docker build -t green-sky-keycloak:local .
```

The build process creates `green-sky-login.jar` from the `theme/` directory and copies it into `/opt/keycloak/providers/` before running `kc.sh build`.

## Running with Docker Compose

A convenient compose profile is provided for manual verification:

```bash
docker compose up --build
```

The service exposes Keycloak on `http://localhost:8080` with `KEYCLOAK_ADMIN=admin` and `KEYCLOAK_ADMIN_PASSWORD=admin`. The container starts in `start-dev` mode with HTTP enabled and the `green-sky-login` theme activated for both login and welcome flows.

## Recommended Theme Settings

- **Theme name**: `green-sky-login`
- **Parent theme**: `keycloak.v2`
- **Primary colors**: `#1C8F5C` (emerald) and `#38BDF8` (sky)
- **Hero logo area**: Reserve a transparent PNG/SVG up to `180px × 60px` for optimal balance on desktop; on mobile it scales down to `140px` wide.
- **Gradient usage**: Apply the provided `theme.css` gradients to keep tonal consistency across hero and button elements.

## CI/CD

GitHub Actions automatically builds and publishes the container to GitHub Container Registry on pushes to `main` or whenever a `v*` tag is created. Tags and labels are derived from repository metadata, and build caches are stored via the GitHub Actions cache backend.

## Manual Verification Checklist

1. **Desktop (≥1200px width)** – Ensure the two-column layout renders with the hero gradient on the left and the login form on the right without overflow.
2. **Tablet (~768px width)** – Confirm that the layout collapses gracefully with centered hero copy and accessible form controls.
3. **Mobile (≤480px width)** – Validate stacked sections, generous tap targets, and maintained contrast for text, buttons, and links.
4. **Error states** – Trigger invalid credentials to confirm error banners remain legible against the theme colors.

## Contributing

Contributions are welcome. Please keep styling assets within `theme/green-sky-login/login/resources/` and document any structural changes or additional assets in this README.
