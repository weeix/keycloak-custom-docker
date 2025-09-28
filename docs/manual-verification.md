# Manual Verification – Green & Sky-Blue Keycloak Login Theme

Use the following steps to validate the custom login experience after building the container image.

## Prerequisites
- Docker Desktop or Docker Engine 24+
- Built image `green-sky-keycloak:local` (or image pulled from GitHub Packages)

## Launch Instructions
1. Run `docker compose up --build` from the repository root.
2. Wait for the Keycloak logs to display `Running the server in development mode.`
3. Navigate to `http://localhost:8080` and authenticate with `admin / admin`.

## Viewport Checks
| Scenario | Steps | Expected Outcome |
|----------|-------|------------------|
| Desktop (≥1200px width) | Resize browser to full desktop width. | Two-column layout with hero gradient on the left, login card on the right; button hover states cast subtle shadow. |
| Tablet (~768px width) | Resize or use responsive dev tools around 768px. | Hero stacks above form with centered copy; spacing remains generous; no horizontal scroll. |
| Mobile (≤480px width) | Simulate or use a phone device width. | Sections stack with full-height gradient header, buttons span width, remember-me and forgot-password align vertically. |

## Functional Checks
- Submit invalid credentials to confirm the red alert banner appears with rounded corners and remains readable.
- Toggle **Remember me** and ensure checkbox focus states display a blue halo.
- Follow the **Forgot password?** link to verify navigation uses theme link styling.
- If social providers are configured, confirm buttons adopt the soft sky-blue outline style.

## Accessibility Notes
- Focusable elements (inputs, links, buttons) should show a blue focus ring (`--focus-ring`).
- Text contrast ratios meet WCAG AA against the gradient and white surfaces.
- Hero content is purely decorative; screen readers should land on the form heading first (`Sign in to your workspace`).
