# Implementation Plan: Custom Keycloak Login Theme Container

## 1. Problem Understanding & Goals
- Deliver a custom login theme based on Keycloak bundled theme inheritance, matching green/sky-blue aesthetic and responsive behaviour described in the spec.
- Package theme assets (Freemarker templates, CSS, optional JS, theme.properties) into a JAR during container build without requiring contributors to install Java locally.
- Build a multi-stage Docker image based on `quay.io/keycloak/keycloak:26.3.5`, copying the theme JAR into the final stage.
- Provide GitHub Actions workflow that builds and pushes the container image to GitHub Packages on pushes to `main` and on tag creation.
- Avoid adding automated tests for now; focus on build, packaging, and documentation.

## 2. Key Design Considerations
- **Theme inheritance**: Extend the closest bundled Keycloak theme (likely `keycloak.v2` login) to minimize template overrides while allowing custom styling.
- **Asset organization**: Keep Freemarker templates, CSS, and other assets under a dedicated module directory (e.g., `theme/login/<theme-name>`), with gradients and responsive rules defined in CSS.
- **Build tooling**: Use containerized build tools (e.g., `keycloak/bin/kc.sh` or `jar` from JDK image) inside Docker multi-stage to create the theme archive; avoid requiring Java locally.
- **Container image layering**: First stage uses JDK-enabled Keycloak image for theme packaging, second stage uses final Keycloak image copying over the theme jar and enabling it via env vars or config.
- **Automation**: Workflow must authenticate to GitHub Packages, reuse caching where possible, and trigger on both branch and tag events.

## 3. High-Level Architecture & Components
1. **Theme Source**
   - Directory: `theme/green-sky-login/`
   - Files: `theme.properties`, Freemarker template overrides (`login.ftl`, fragments as needed), CSS, optional JS, static assets.
2. **Build Scripts & Config**
   - `Dockerfile`: Multi-stage build packaging theme jar using `jar` command; final stage based on `quay.io/keycloak/keycloak:26.3.5` with theme jar copied to `/opt/keycloak/providers/` or `/opt/keycloak/themes/` as appropriate.
   - Possibly a simple `Makefile` or README instructions; avoid extra tooling.
3. **CI/CD Workflow**
   - GitHub Actions YAML under `.github/workflows/build-and-push.yml`.
   - Steps: checkout, login to ghcr, build image (with build args for version/tag), push to GitHub Packages.
4. **Documentation**
   - Update README with usage instructions, build/push details, theme description.

## 4. Implementation Steps
1. **Repository Setup**
   - Add base directory structure for theme assets.
   - Document project structure in README.
2. **Theme Development**
   - Create `theme.properties` specifying parent theme and display name.
   - Copy/override necessary Freemarker templates (start with login page) to apply layout tweaks.
   - Create CSS file implementing responsive design, gradients, and colors; ensure mobile-first rules.
   - Reference CSS/JS via `theme.properties` or template includes.
3. **Local Verification Resources**
   - Provide minimal instructions for running Keycloak container with theme to allow manual verification (e.g., `docker compose` snippet or CLI command).
4. **Dockerfile**
   - Stage 1: Base on a Keycloak image that includes JDK tools (or adopt official builder image) to package theme directory into JAR via `jar cf` command.
   - Stage 2: Base on `quay.io/keycloak/keycloak:26.3.5`; copy JAR into `/opt/keycloak/providers/` and run `kc.sh build` during image build as needed.
   - Ensure Dockerfile uses multi-stage approach, no custom shell scripts, and keeps image lean.
5. **Container Entrypoint Configuration**
   - Configure Keycloak to enable custom theme via environment variable or CLI argument (e.g., `KEYCLOAK_ADMIN`, `KEYCLOAK_ADMIN_PASSWORD`, `KC_THEME` updates) documented for runtime configuration.
6. **CI/CD Workflow**
   - Create GitHub Actions workflow triggered on push to `main` and tags (`v*`).
   - Steps: checkout, set up Buildx, log in to `ghcr.io`, build image using `docker/build-push-action`, push image tag(s) (e.g., `latest`, git sha/tag).
   - Use repository secrets for `GHCR_TOKEN` if necessary or default `GITHUB_TOKEN` with appropriate permissions.
7. **Documentation Updates**
   - Update README with build/run instructions, theme preview details, CI behavior, and contribution notes (no local Java requirement).

## 5. Risks & Mitigations
- **Theming complexity**: If overriding `login.ftl` becomes extensive, ensure minimal duplication by leveraging macros and parent structures.
- **Asset responsiveness**: Test CSS across responsive breakpoints conceptually; include explicit CSS breakpoints and fallback colors.
- **CI authentication**: Ensure GitHub Actions uses appropriate permissions (set `packages: write`).
- **Image size**: Minimize additional layers; clean up intermediate artifacts in Dockerfile.

## 6. Open Questions
- Should additional pages (e.g., registration) share the same theme styling now or later? (Out of scope unless requested.)
- Any branding assets (logos/images) to include beyond color scheme? (Assume placeholder text until provided.)

## 7. Acceptance Criteria Alignment
- Plan covers delivering responsive green/sky-blue theme meeting FR-001 to FR-008 by structuring CSS & template overrides.
- Dockerfile and CI setup ensure theme is packaged into container image with automated publishing.
- Documentation ensures contributors can build/run image without local Java installation.

