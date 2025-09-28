<#import "template.ftl" as layout>

<@layout.registrationLayout displayInfo=false; section>
  <#if section == "title">
    ${msg("loginTitle")}
  <#elseif section == "form">
    <div class="kc-login-layout">
      <section class="kc-login-hero">
        <div class="kc-logo" aria-hidden="true">
          <div class="cta-badge">${msg("doLogIn")?upper_case}</div>
        </div>
        <h1>${msg("welcome")!"Welcome back"}</h1>
        <p>Securely access your account with an experience inspired by open skies and thriving greens.</p>
        <div class="kc-cta">
          <span class="cta-badge">Trusted access</span>
          <span class="cta-text">Stay productive anywhere with a login that adapts to every screen size.</span>
        </div>
      </section>

      <section class="kc-login-form" aria-labelledby="kc-login-heading">
        <header>
          <h2 id="kc-login-heading">Sign in to your workspace</h2>
          <span>Use your organizational credentials to continue.</span>
        </header>

        <#if messagesPerField.existsError("username") || messagesPerField.existsError("password") || message?? && message?has_content>
          <div class="login-alert" role="alert">
            <div class="kc-feedback-text">
              <#if messagesPerField.existsError("username")>
                ${kcSanitize(messagesPerField.get("username"))}
              <#elseif messagesPerField.existsError("password")>
                ${kcSanitize(messagesPerField.get("password"))}
              <#elseif message?? && message?has_content>
                ${kcSanitize(message.summary)}
              </#if>
            </div>
          </div>
        </#if>

        <form id="kc-form-login" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post">
          <div class="form-group">
            <label for="username">${msg("username")}</label>
            <#if usernameEditDisabled?? && usernameEditDisabled>
              <input tabindex="1" id="username" name="username" value="${(login.username)!}" type="text" disabled>
            <#elseif login.username??>
              <input tabindex="1" id="username" name="username" value="${(login.username)!}" type="text" autofocus autocomplete="username">
            <#else>
              <input tabindex="1" id="username" name="username" value="" type="text" autofocus autocomplete="username">
            </#if>
          </div>

          <#if passwordRequired??>
            <div class="form-group">
              <label for="password">${msg("password")}</label>
              <input tabindex="2" id="password" name="password" type="password" autocomplete="current-password">
            </div>
          </#if>

          <div class="kc-form-options">
            <#if realm.rememberMe && !(usernameEditDisabled?? && usernameEditDisabled)>
              <label for="rememberMe" class="checkbox">
                <input tabindex="3" id="rememberMe" name="rememberMe" type="checkbox" value="on" <#if login.rememberMe?? && login.rememberMe>checked</#if>>
                <span>${msg("rememberMe")}</span>
              </label>
            </#if>
            <#if realm.resetPasswordAllowed>
              <a tabindex="4" href="${url.loginResetCredentialsUrl}">${msg("doForgotPassword")}</a>
            </#if>
          </div>

          <div class="kc-form-buttons">
            <input tabindex="5" class="kc-button" name="login" id="kc-login" type="submit" value="${msg("doLogIn")}">

            <#if realm.password && social.providers?has_content>
              <div class="kc-social" role="group" aria-label="${msg("identity-provider-login-label")}">
                <#list social.providers as p>
                  <button type="button" onclick="window.location='${p.loginUrl}'">${p.displayName}</button>
                </#list>
              </div>
            </#if>
          </div>
        </form>

        <footer>
          <#if realm.registrationAllowed && !registrationDisabled??>
            ${msg("noAccount")?replace("?", "")}
            <a href="${url.registrationUrl}">${msg("doRegister")}</a>
          </#if>
        </footer>
      </section>
    </div>
  </#if>
</@layout.registrationLayout>
