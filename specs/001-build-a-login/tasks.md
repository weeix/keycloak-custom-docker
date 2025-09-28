# Tasks: Custom Keycloak Login Theme Container

**Input**: Design documents from `/specs/001-build-a-login/`
**Prerequisites**: plan.md (required)

## Phase 3.1: Setup
- [x] T001 Scaffold `theme/green-sky-login/login/` directory tree with `resources/css/` (and empty `resources/js/`, `resources/img/`) folders to host theme assets per plan structure.

## Phase 3.2: Tests First (TDD)
- _No automated tests are required for this feature per implementation plan; proceed directly to core tasks once manual verification notes are drafted in Phase 3.5._

## Phase 3.3: Core Implementation (ONLY after tests are failing)
- [x] T002 Create `theme/green-sky-login/login/theme.properties` inheriting from `keycloak.v2` login theme and registering custom CSS/JS resources.
- [x] T003 [P] Author responsive styling in `theme/green-sky-login/login/resources/css/theme.css` implementing the green/sky-blue palette, gradients, typography, and mobile breakpoints described in the plan.
- [x] T004 Update `theme/green-sky-login/login/login.ftl` to mirror the reference layout, reference the new stylesheet, and ensure accessible markup for login form elements.

## Phase 3.4: Integration
- [x] T005 Create multi-stage `Dockerfile` that packages the theme directory into a JAR in a builder stage and copies it into `/opt/keycloak/providers/` of the `quay.io/keycloak/keycloak:26.3.5` runtime image, enabling the theme at build time.
- [x] T006 [P] Add `docker-compose.yml` (or update README snippet) providing a local run profile that sets `KC_HTTP_ENABLED` and selects the new theme via environment variables for manual verification.
- [x] T007 Configure `.github/workflows/build-and-push.yml` to build the Docker image with Buildx and push to GitHub Packages on pushes to `main` and tag events, authenticating with `GITHUB_TOKEN`.

## Phase 3.5: Polish
- [x] T008 [P] Document image usage, local verification steps, and theme asset overview in `README.md`, including recommended logo dimensions and environment variable guidance.
- [x] T009 Draft `docs/manual-verification.md` outlining browser viewport checks (desktop, tablet, narrow mobile) and expected visual outcomes for the login page.

## Dependencies
- T001 must complete before T002-T004 to ensure files exist.
- T002 must precede T003 and T004 so stylesheet references align with `theme.properties`.
- T004 depends on T003 for class names and assets.
- T005 requires T002-T004 so packaged assets are finalized.
- T006 depends on T005 because the run profile relies on the built image.
- T007 depends on T005 to push the finalized image.
- T008 depends on T005-T007 to document accurate build and deployment behaviour.
- T009 depends on T004 and T008 to describe actual UI behaviour and instructions.

## Parallel Example
```
# After completing T002, run the parallelizable styling and integration doc tasks together:
/tasks run T003
/tasks run T006
/tasks run T008
```
