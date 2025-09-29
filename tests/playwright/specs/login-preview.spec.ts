import { expect, test } from '@playwright/test';

const ADMIN_USERNAME = process.env.KC_BOOTSTRAP_ADMIN_USERNAME ?? 'admin';
const ADMIN_PASSWORD = process.env.KC_BOOTSTRAP_ADMIN_PASSWORD ?? 'admin';

const LOGIN_PREVIEW_URL = '/realms/green-sky/protocol/openid-connect/auth' +
  '?response_type=code' +
  '&scope=openid' +
  '&client_id=login-app' +
  '&redirect_uri=' + encodeURIComponent('http://localhost:8080/realms/green-sky/account/');

test('log in to admin console and capture themed login page', async ({ page }, testInfo) => {
  await page.goto('/admin/');

  await page.getByLabel(/username or email/i).fill(ADMIN_USERNAME);
  await page.locator('input[name="password"]').fill(ADMIN_PASSWORD);
  await page.getByRole('button', { name: /sign in/i }).click();

  await page.waitForURL('**/admin/master/console/**', { timeout: 30_000 });

  await page.context().clearCookies();
  await page.goto('about:blank');

  await page.goto(LOGIN_PREVIEW_URL);
  await expect(page.locator('.login-hero-title')).toHaveText('Welcome to your workspace');

  const screenshotPath = testInfo.outputPath('green-sky-login.png');
  await page.screenshot({ path: screenshotPath, fullPage: true });
  await testInfo.attach('green-sky-login', {
    path: screenshotPath,
    contentType: 'image/png'
  });
});
