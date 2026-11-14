<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="en" class="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="theme-color" content="#080808">
<title>HabitFlow | <c:out value="${mode}"/></title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles.css?v=20261114-obsidian1">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@700;800&display=swap" rel="stylesheet">
<style>
html,body{min-height:100%;margin:0;background:var(--hf-canvas,#080808);color:var(--hf-text,#f5f5f7);font-family:'DM Sans',sans-serif}
.auth-shell{min-height:100vh;display:grid;grid-template-columns:minmax(0,1.05fr) minmax(390px,.95fr);background:var(--hf-canvas);overflow:hidden}
.auth-showcase{position:relative;display:flex;flex-direction:column;justify-content:center;min-width:0;padding:clamp(34px,7vw,100px);overflow:hidden;background:radial-gradient(ellipse at 8% 92%,rgba(239,35,35,.22),transparent 45%),linear-gradient(145deg,#0b0b0e,#080808 72%)}
.auth-showcase:after{content:"";position:absolute;inset:auto 0 0;height:1px;background:linear-gradient(90deg,transparent,rgba(239,35,35,.6),transparent)}
.auth-brand{display:flex;align-items:center;gap:12px;margin-bottom:clamp(40px,8vh,88px);font:800 24px 'Plus Jakarta Sans',sans-serif}
.auth-brand .brand-mark{width:42px;height:42px;display:grid;place-items:center;border-radius:12px;background:linear-gradient(135deg,#ff3b3b,#c81010);color:#fff}
.brand-flow{color:#ef2323}
.auth-showcase h1{max-width:700px;margin:0;color:#f5f5f7;font:800 clamp(38px,5.4vw,72px)/1.08 'Plus Jakarta Sans',sans-serif;letter-spacing:-.055em}
.auth-showcase h1 span{white-space:nowrap}
.auth-lead{max-width:520px;margin:18px 0 0;color:#a1a1aa;font-size:clamp(15px,1.5vw,19px);line-height:1.65}
.auth-formula{display:inline-flex;align-items:center;gap:10px;max-width:100%;margin-top:34px;padding:12px 15px;color:#f5f5f7;background:rgba(17,17,20,.82);border:1px solid rgba(239,35,35,.3);border-radius:13px;font-size:12px;font-weight:800;letter-spacing:.05em;box-shadow:0 10px 30px rgba(0,0,0,.3),0 0 24px -6px rgba(239,35,35,.18)}
.auth-formula-mark{color:#ef2323;font-size:18px}
.auth-preview{max-width:460px;margin-top:42px;padding:20px;background:linear-gradient(145deg,rgba(17,17,20,.92),rgba(17,17,20,.72));border:1px solid rgba(255,255,255,.1);border-radius:18px;box-shadow:0 20px 45px rgba(0,0,0,.25)}
.auth-preview-label{margin:0 0 14px;color:#ef2323;font-size:10px;font-weight:800;letter-spacing:.14em}
.auth-preview-row{display:flex;align-items:center;gap:12px;padding:12px 0;border-top:1px solid rgba(255,255,255,.08);color:#a1a1aa}
.auth-preview-check{width:28px;height:28px;display:grid;place-items:center;border:1px solid rgba(239,35,35,.6);border-radius:9px;color:#ff7777}
.auth-panel{display:grid;place-items:center;min-width:0;padding:32px;background:var(--hf-canvas)}
.auth-card{width:min(100%,440px);padding:clamp(24px,4vw,42px);background:var(--hf-surface);border:1px solid var(--hf-border);border-radius:22px;box-shadow:0 25px 80px #0005}
.auth-card h2{margin:0 0 8px;font:800 29px 'Plus Jakarta Sans',sans-serif;letter-spacing:-.04em}
.auth-card>p{margin:0 0 24px;color:var(--hf-subtext);line-height:1.55}
.auth-card form{display:grid;gap:15px}
.auth-card label{display:grid;gap:7px;color:var(--hf-subtext);font-size:12px;font-weight:700}
.auth-card input:not([type=checkbox]){width:100%;height:45px;padding:0 12px;border-radius:10px;border:1px solid var(--hf-border);background:var(--hf-canvas);color:var(--hf-text);font:inherit}
.auth-password-wrap{position:relative}
.auth-password-wrap input{padding-right:76px!important}
.auth-show-password{position:absolute;top:50%;right:8px;transform:translateY(-50%);padding:6px 8px;color:var(--hf-subtext);background:transparent;border:0;border-radius:7px;font-size:11px;font-weight:700}
.auth-show-password:hover{color:var(--hf-accent)}
.auth-check-row{display:flex;align-items:center;justify-content:space-between;gap:10px}
.auth-check-row label{display:flex;align-items:center;gap:8px;font-weight:500}
.auth-check-row input{accent-color:#ef2323}
.auth-link{color:#ff555d;font-size:12px;font-weight:700;text-decoration:none}
.auth-link:hover{text-decoration:underline}
.auth-submit{min-height:47px;border:1px solid rgba(255,120,120,.4);border-radius:10px;background:linear-gradient(180deg,#ff3b3b 0%,#ef2323 55%,#c81010 100%);color:#fff;font:700 14px 'DM Sans',sans-serif;box-shadow:0 4px 18px rgba(239,35,35,.35),inset 0 1px rgba(255,255,255,.2)}
.auth-hint{color:var(--hf-subtext);font-size:11px;line-height:1.5}
.auth-hint.invalid{color:#ff7777}
.auth-error{margin:0 0 18px;padding:11px;border-radius:9px;background:rgba(239,35,35,.12);color:#ff7777}
.auth-switch{margin:20px 0 0!important;text-align:center;font-size:12px}
.auth-dialog{position:fixed;inset:0;z-index:50;display:none;place-items:center;padding:20px;background:rgba(0,0,0,.72);backdrop-filter:blur(5px)}
.auth-dialog.open{display:grid}
.auth-dialog-card{width:min(100%,420px);padding:24px;background:var(--hf-surface);border:1px solid var(--hf-border);border-radius:16px;box-shadow:var(--shadow)}
.auth-dialog-card h3{margin:0 0 8px;font:700 19px 'Plus Jakarta Sans',sans-serif}
.auth-dialog-card p{color:var(--hf-subtext);font-size:13px;line-height:1.6}
.auth-dialog-card button{min-height:39px;padding:0 15px;color:#fff;background:var(--hf-accent);border:0;border-radius:9px;font-weight:700}
@media(max-width:850px){.auth-shell{grid-template-columns:1fr}.auth-showcase{min-height:340px;padding:34px 28px 40px}.auth-brand{margin-bottom:36px}.auth-showcase h1{font-size:clamp(36px,9vw,54px)}.auth-preview{display:none}.auth-panel{padding:24px}}
@media(max-width:480px){.auth-showcase{min-height:285px;padding:25px 20px}.auth-brand{margin-bottom:28px;font-size:20px}.auth-showcase h1{font-size:34px}.auth-lead{margin-top:12px;font-size:14px}.auth-formula{margin-top:20px;padding:10px;font-size:10px}.auth-panel{padding:16px}.auth-card{padding:23px 19px}}
</style>
</head>
<body>
<main class="auth-shell">
    <section class="auth-showcase" aria-label="HabitFlow introduction">
        <div class="auth-brand"><span class="brand-mark">H</span><span>Habit<span class="brand-flow">Flow</span></span></div>
        <h1>Good habits,<br><span>built one day at a time.</span></h1>
        <p class="auth-lead">A private place to keep your routine, notice your progress, and make steady changes that last.</p>
        <div class="auth-formula"><span class="auth-formula-mark">↗</span><span>1% BETTER EVERY DAY</span><span aria-hidden="true">|</span><span>1.01<sup>365</sup> = 37.78×</span></div>
        <div class="auth-preview" aria-hidden="true"><p class="auth-preview-label">A SIMPLE START</p><div class="auth-preview-row"><span class="auth-preview-check">○</span><span>Read for 10 minutes</span></div><div class="auth-preview-row"><span class="auth-preview-check">○</span><span>Move for 15 minutes</span></div></div>
    </section>
    <section class="auth-panel">
        <div class="auth-card">
            <h2><c:choose><c:when test="${mode eq 'register'}">Create your account</c:when><c:otherwise>Welcome back</c:otherwise></c:choose></h2>
            <p><c:choose><c:when test="${mode eq 'register'}">Start a private workspace for your habits.</c:when><c:otherwise>Sign in to continue your personal routine.</c:otherwise></c:choose></p>
            <c:if test="${not empty error}"><div class="auth-error" role="alert"><c:out value="${error}"/></div></c:if>
            <form method="post" action="${pageContext.request.contextPath}/${mode eq 'register' ? 'register' : 'login'}" id="auth-form">
                <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>"/>
                <c:if test="${mode eq 'register'}"><label>Full name<input name="name" autocomplete="name" required minlength="2" maxlength="80" value="<c:out value='${param.name}'/>"/></label></c:if>
                <label>Email<input type="email" name="email" autocomplete="email" required maxlength="254" value="<c:out value='${param.email}'/>"/></label>
                <label>Password<div class="auth-password-wrap"><input id="auth-password" type="password" name="password" autocomplete="${mode eq 'register' ? 'new-password' : 'current-password'}" required minlength="10" maxlength="72"/><button type="button" class="auth-show-password" data-password-toggle="auth-password" aria-label="Show password">Show</button></div></label>
                <c:if test="${mode eq 'register'}"><label>Confirm password<div class="auth-password-wrap"><input id="auth-confirm-password" type="password" name="confirmPassword" autocomplete="new-password" required minlength="10" maxlength="72"/><button type="button" class="auth-show-password" data-password-toggle="auth-confirm-password" aria-label="Show confirmation password">Show</button></div></label><small class="auth-hint" id="password-match">Use 10 or more characters. Passwords must match. Passwords are hashed before storage.</small></c:if>
                <c:if test="${mode ne 'register'}"><div class="auth-check-row"><label><input type="checkbox" name="remember"/> Remember me</label><a class="auth-link" href="#forgot-password" id="forgot-password-link">Forgot password?</a></div></c:if>
                <button type="submit" class="auth-submit"><c:out value="${mode eq 'register' ? 'Create account' : 'Sign in'}"/></button>
            </form>
            <p class="auth-switch"><c:choose><c:when test="${mode eq 'register'}">Already have an account? <a class="auth-link" href="${pageContext.request.contextPath}/login">Sign in</a></c:when><c:otherwise>New to HabitFlow? <a class="auth-link" href="${pageContext.request.contextPath}/register">Create account</a></c:otherwise></c:choose></p>
        </div>
    </section>
</main>
<div class="auth-dialog" id="forgot-password-dialog" role="dialog" aria-modal="true" aria-labelledby="forgot-password-title" aria-hidden="true"><section class="auth-dialog-card"><h3 id="forgot-password-title">Password recovery</h3><p>Password reset is not available yet because this deployment does not have an email delivery service configured. Your account remains secure; contact the project maintainer for help.</p><button type="button" id="close-forgot-password">Close</button></section></div>
<script>
document.querySelectorAll('[data-password-toggle]').forEach(function(button){button.addEventListener('click',function(){var input=document.getElementById(button.dataset.passwordToggle);var show=input.type==='password';input.type=show?'text':'password';button.textContent=show?'Hide':'Show';button.setAttribute('aria-label',show?'Hide password':'Show password');});});
var authForm=document.getElementById('auth-form');
if(authForm){
    var passwordInput=document.getElementById('auth-password');
    var confirmation=document.getElementById('auth-confirm-password');
    var passwordHint=document.getElementById('password-match');
    function validateRegistrationPassword(){
        if(!confirmation)return;
        var matches=confirmation.value===passwordInput.value;
        confirmation.setCustomValidity(matches?'':'Passwords do not match.');
        if(passwordHint&&confirmation.value){passwordHint.textContent=matches?'Passwords match.':'Passwords do not match.';passwordHint.classList.toggle('invalid',!matches);}
        if(passwordHint&&!confirmation.value){passwordHint.textContent='Use 10 or more characters. Passwords must match. Passwords are hashed before storage.';passwordHint.classList.remove('invalid');}
    }
    if(confirmation){passwordInput.addEventListener('input',validateRegistrationPassword);confirmation.addEventListener('input',validateRegistrationPassword);}
    authForm.addEventListener('submit',function(event){if(confirmation&&passwordInput.value!==confirmation.value){event.preventDefault();validateRegistrationPassword();confirmation.reportValidity();}});
}
var forgotDialog=document.getElementById('forgot-password-dialog');var forgotLink=document.getElementById('forgot-password-link');var forgotClose=document.getElementById('close-forgot-password');if(forgotLink&&forgotDialog){forgotLink.addEventListener('click',function(event){event.preventDefault();forgotDialog.classList.add('open');forgotDialog.setAttribute('aria-hidden','false');forgotClose.focus();});forgotClose.addEventListener('click',function(){forgotDialog.classList.remove('open');forgotDialog.setAttribute('aria-hidden','true');forgotLink.focus();});forgotDialog.addEventListener('click',function(event){if(event.target===forgotDialog){forgotDialog.classList.remove('open');forgotDialog.setAttribute('aria-hidden','true');}});}
</script>
</body>
</html>
