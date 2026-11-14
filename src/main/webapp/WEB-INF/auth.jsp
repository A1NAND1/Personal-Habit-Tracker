<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="theme-color" content="#F8FAFC">
<title>HabitFlow | <c:out value="${mode}"/></title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles.css?v=20261114-obsidian2">
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@700;800&display=swap" rel="stylesheet">
<script>try{if(localStorage.getItem('habitflow-theme')==='dark')document.documentElement.classList.add('dark')}catch(e){}</script>
<style>
.auth-page{min-height:100vh;padding:18px 24px 34px;background:var(--hf-canvas);color:var(--hf-text)}
.auth-topbar{max-width:1152px;height:48px;margin:0 auto 18px;display:flex;align-items:center;justify-content:space-between}
.auth-brand{display:flex;align-items:center;gap:10px;color:var(--hf-text);text-decoration:none;font:800 19px 'Plus Jakarta Sans',sans-serif}
.auth-brand-mark{width:32px;height:32px;display:grid;place-items:center;color:white;background:linear-gradient(135deg,#EF2323,#C41212);border-radius:12px}
.auth-brand-flow{color:#EF2323}
.auth-theme-toggle{width:36px;height:36px;display:grid;place-items:center;color:var(--hf-text);background:var(--hf-surface);border:1px solid var(--hf-border);border-radius:12px}
.auth-theme-toggle svg{width:18px;height:18px;fill:none;stroke:currentColor;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
.auth-shell{max-width:1152px;margin:0 auto;display:grid;grid-template-columns:repeat(12,minmax(0,1fr));gap:32px;align-items:stretch}
.auth-showcase,.auth-card{position:relative;min-width:0;overflow:hidden;border-radius:20px;padding:clamp(24px,4vw,44px)}
.auth-showcase{grid-column:span 6;display:flex;flex-direction:column;justify-content:center;background:var(--hf-surface);border:1px solid var(--hf-border);box-shadow:var(--shadow)}
.auth-kicker{margin:0 0 12px;color:#EF2323;font-size:12px;font-weight:800;letter-spacing:.14em;text-transform:uppercase}
.auth-showcase h1{max-width:550px;margin:0;font:800 clamp(30px,3.2vw,42px)/1.13 'Plus Jakarta Sans',sans-serif;letter-spacing:-.04em}
.auth-formula{display:flex;align-items:center;flex-wrap:wrap;gap:10px;margin:22px 0 13px;color:var(--hf-text);font-size:12px;font-weight:800;letter-spacing:.04em}
.auth-formula svg{width:23px;height:20px;flex:none;stroke:#EF2323;stroke-width:2.2;fill:none;stroke-linecap:round;stroke-linejoin:round}
.auth-formula-divider{width:1px;height:17px;background:var(--hf-subtext);opacity:.4}
.auth-lead{max-width:550px;margin:0 0 22px;color:var(--hf-subtext);font-size:14px;line-height:1.6}
.auth-features{display:grid;gap:10px;margin-top:2px}
.auth-feature{display:grid;gap:4px;padding:13px;background:var(--hf-muted);border:1px solid var(--hf-border);border-radius:12px}
.auth-feature strong{font-size:12px}.auth-feature span{color:var(--hf-subtext);font-size:11px;line-height:1.5}
.auth-wave{position:absolute;left:0;right:0;bottom:0;height:42px;opacity:.8;pointer-events:none}
.auth-card{grid-column:span 6;align-self:center;background:var(--hf-surface);border:1px solid var(--hf-border);box-shadow:var(--shadow)}
.auth-switcher{display:grid;grid-template-columns:1fr 1fr;gap:4px;padding:4px;margin-bottom:25px;background:var(--hf-muted);border:1px solid var(--hf-border);border-radius:11px}
.auth-switcher a{padding:9px;text-align:center;color:var(--hf-subtext);font-size:12px;font-weight:700;text-decoration:none;border-radius:8px}
.auth-switcher a.active{color:var(--hf-text);background:var(--hf-surface);box-shadow:0 1px 3px rgba(15,23,42,.1)}
.auth-card h2{margin:0 0 6px;font:800 28px 'Plus Jakarta Sans',sans-serif;letter-spacing:-.04em}
.auth-subtitle{margin:0 0 21px;color:var(--hf-subtext);font-size:13px;line-height:1.5}
.auth-card form{display:grid;gap:14px}
.auth-card label{display:grid;gap:6px;color:var(--hf-subtext);font-size:11px;font-weight:700}
.auth-input-wrap{position:relative;display:flex;align-items:center}
.auth-input-wrap>svg{position:absolute;left:12px;width:17px;height:17px;fill:none;stroke:var(--hf-subtext);stroke-width:1.7;stroke-linecap:round;stroke-linejoin:round;pointer-events:none}
.auth-input-wrap input{width:100%;height:43px;padding:0 42px;color:var(--hf-text);background:var(--hf-canvas);border:1px solid var(--hf-border);border-radius:10px;font:inherit}
.auth-input-wrap input:focus{border-color:#EF2323;outline:3px solid rgba(239,35,35,.14)}
.auth-password-toggle{position:absolute;right:8px;padding:5px 7px;color:var(--hf-subtext);background:transparent;border:0;font-size:10px;font-weight:700}
.auth-row{display:flex;align-items:center;justify-content:space-between;gap:12px}
.auth-row label{display:flex;align-items:center;gap:7px;font-weight:500}.auth-row input{accent-color:#EF2323}
.auth-link{color:#EF2323;font-size:11px;font-weight:700;text-decoration:none}.auth-link:hover{text-decoration:underline}
.auth-submit{min-height:45px;padding:0 16px;color:#fff;background:linear-gradient(135deg,#EF2323 0%,#C41212 100%);border:1px solid rgba(239,35,35,.5);border-radius:12px;box-shadow:0 6px 20px rgba(239,35,35,.25);font-weight:700}
.auth-error{margin-bottom:14px;padding:10px 12px;color:#b42332;background:rgba(239,35,35,.1);border:1px solid rgba(239,35,35,.2);border-radius:9px;font-size:12px}
.auth-hint{color:var(--hf-subtext);font-size:10px;line-height:1.5}.auth-hint.invalid{color:#c41212}
.auth-account-switch{margin:19px 0 0;text-align:center;color:var(--hf-subtext);font-size:11px}
.auth-dialog{position:fixed;inset:0;z-index:50;display:none;place-items:center;padding:20px;background:rgba(0,0,0,.62)}.auth-dialog.open{display:grid}
.auth-dialog-card{width:min(100%,420px);padding:24px;color:var(--hf-text);background:var(--hf-surface);border:1px solid var(--hf-border);border-radius:16px;box-shadow:var(--shadow)}
.auth-dialog-card h3{margin:0 0 8px;font:700 19px 'Plus Jakarta Sans',sans-serif}.auth-dialog-card p{color:var(--hf-subtext);font-size:13px;line-height:1.6}.auth-dialog-card button{min-height:38px;padding:0 14px;color:#fff;background:#EF2323;border:0;border-radius:9px;font-weight:700}
html.dark .auth-showcase,html.dark .auth-card{background-image:radial-gradient(circle at 92% 94%,rgba(220,24,24,.25) 0%,rgba(220,24,24,.08) 38%,transparent 70%);box-shadow:inset -1px -1px 0 0 rgba(239,35,35,.22)}
html.dark .auth-dialog-card{background-image:radial-gradient(circle at 92% 94%,rgba(220,24,24,.15),transparent 70%)}
@media(max-width:850px){.auth-page{padding:14px 18px 28px}.auth-shell{grid-template-columns:1fr;gap:16px}.auth-showcase,.auth-card{grid-column:1}.auth-showcase{padding:24px 27px 52px}.auth-showcase h1{max-width:none;font-size:32px}.auth-features{grid-template-columns:repeat(3,minmax(0,1fr))}.auth-feature{padding:10px}.auth-wave{height:30px}}
@media(max-width:560px){.auth-page{padding:10px 12px 20px}.auth-topbar{margin-bottom:10px}.auth-showcase,.auth-card{padding:21px 18px}.auth-showcase h1{font-size:27px}.auth-lead{font-size:12px}.auth-features{grid-template-columns:1fr}.auth-feature{padding:10px}.auth-card h2{font-size:24px}.auth-formula{font-size:10px;gap:7px}}
</style>
</head>
<body>
<div class="auth-page">
<header class="auth-topbar"><a class="auth-brand" href="${pageContext.request.contextPath}/login"><span class="auth-brand-mark">H</span><span>Habit<span class="auth-brand-flow">Flow</span></span></a><button type="button" class="auth-theme-toggle" id="auth-theme-toggle" aria-label="Switch theme"><svg class="moon-icon" viewBox="0 0 24 24"><path d="M20 15A8.5 8.5 0 0 1 9 4a8.5 8.5 0 1 0 11 11Z"/></svg><svg class="sun-icon" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2m0 16v2M4.9 4.9l1.4 1.4m11.4 11.4 1.4 1.4M2 12h2m16 0h2M4.9 19.1l-1.4-1.4m11.4-11.4 1.4-1.4"/></svg></button></header>
<main class="auth-shell">
<section class="auth-showcase hf-crimson-card"><p class="auth-kicker">PERSONAL HABIT TRACKER · PRIVATE WORKSPACE</p><h1>Build lasting routines across every device.</h1><div class="auth-formula"><svg viewBox="0 0 24 20" aria-hidden="true"><path d="m2 16 6-6 4 3 8-9"/><path d="M15 4h5v5"/></svg><span>1% BETTER EVERY DAY</span><span class="auth-formula-divider"></span><span>1.01<sup>365</sup> = 37.78×</span></div><p class="auth-lead">Sign in to access your private daily routine, 7-day check-in matrix, deep-work focus timer, and 30-day consistency analytics.</p><div class="auth-features"><article class="auth-feature"><strong>Isolated Personal Workspaces</strong><span>Your habits, daily reflections, streak history, and goals stay inside your personal account.</span></article><article class="auth-feature"><strong>Real-Time Workspace Persistence</strong><span>Habit check-ins, notes, and focus sessions are saved to your account as you use them.</span></article><article class="auth-feature"><strong>7-Day Matrix, Focus Timer &amp; Analytics</strong><span>Track completions, log focus sessions, and review your consistency momentum.</span></article></div><svg class="auth-wave" viewBox="0 0 280 68" preserveAspectRatio="none" aria-hidden="true"><path d="M-12 48 C 72 31, 178 31, 292 24" stroke="#EF2323" stroke-opacity=".32"/><path d="M-12 34 C 46 14, 108 28, 176 23 C 226 19, 258 11, 292 3" stroke="#EF2323" stroke-opacity=".7" stroke-width="2"/></svg></section>
<section class="auth-card hf-crimson-card"><nav class="auth-switcher" aria-label="Sign in or create account"><a class="${mode ne 'register' ? 'active' : ''}" href="${pageContext.request.contextPath}/login">Sign in</a><a class="${mode eq 'register' ? 'active' : ''}" href="${pageContext.request.contextPath}/register">Create account</a></nav><p class="auth-kicker"><c:out value="${mode eq 'register' ? 'NEW PERSONAL WORKSPACE' : 'ACCOUNT ACCESS'}"/></p><h2><c:choose><c:when test="${mode eq 'register'}">Create your account</c:when><c:otherwise>Welcome back</c:otherwise></c:choose></h2><p class="auth-subtitle"><c:choose><c:when test="${mode eq 'register'}">Create a private account and start with a few simple habits.</c:when><c:otherwise>Sign in to continue your personal routine.</c:otherwise></c:choose></p>
<c:if test="${not empty error}"><div class="auth-error" role="alert"><c:out value="${error}"/></div></c:if>
<form method="post" action="${pageContext.request.contextPath}/${mode eq 'register' ? 'register' : 'login'}" id="auth-form"><input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>"/>
<c:if test="${mode eq 'register'}"><label>Full name<span class="auth-input-wrap"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="8" r="4"/><path d="M4 21a8 8 0 0 1 16 0"/></svg><input name="name" autocomplete="name" required minlength="2" maxlength="80" value="<c:out value='${param.name}'/>" placeholder="Your full name"/></span></label></c:if>
<label>Email<span class="auth-input-wrap"><svg viewBox="0 0 24 24" aria-hidden="true"><rect x="3" y="5" width="18" height="14" rx="2"/><path d="m4 7 8 6 8-6"/></svg><input type="email" name="email" autocomplete="email" required maxlength="254" value="<c:out value='${param.email}'/>" placeholder="you@example.com"/></span></label>
<label>Password<span class="auth-input-wrap"><svg viewBox="0 0 24 24" aria-hidden="true"><rect x="4" y="10" width="16" height="11" rx="2"/><path d="M8 10V7a4 4 0 1 1 8 0v3"/></svg><input id="auth-password" type="password" name="password" autocomplete="${mode eq 'register' ? 'new-password' : 'current-password'}" required minlength="10" maxlength="72" placeholder="At least 10 characters"/><button type="button" class="auth-password-toggle" data-password-toggle="auth-password">Show</button></span></label>
<c:if test="${mode eq 'register'}"><label>Confirm password<span class="auth-input-wrap"><svg viewBox="0 0 24 24" aria-hidden="true"><rect x="4" y="10" width="16" height="11" rx="2"/><path d="M8 10V7a4 4 0 1 1 8 0v3"/></svg><input id="auth-confirm-password" type="password" name="confirmPassword" autocomplete="new-password" required minlength="10" maxlength="72" placeholder="Enter the password again"/><button type="button" class="auth-password-toggle" data-password-toggle="auth-confirm-password">Show</button></span></label><small class="auth-hint" id="password-match">Use 10 or more characters. Passwords must match.</small></c:if>
<c:if test="${mode ne 'register'}"><div class="auth-row"><label><input type="checkbox" name="remember"/> Remember me</label><a class="auth-link" href="#forgot-password" id="forgot-password-link">Forgot password?</a></div></c:if>
<button type="submit" class="auth-submit"><c:out value="${mode eq 'register' ? 'Create account' : 'Sign in'}"/></button></form>
<p class="auth-account-switch"><c:choose><c:when test="${mode eq 'register'}">Already have an account? <a class="auth-link" href="${pageContext.request.contextPath}/login">Sign in</a></c:when><c:otherwise>New to HabitFlow? <a class="auth-link" href="${pageContext.request.contextPath}/register">Create account</a></c:otherwise></c:choose></p></section>
</main></div>
<div class="auth-dialog" id="forgot-password-dialog" role="dialog" aria-modal="true" aria-labelledby="forgot-password-title" aria-hidden="true"><section class="auth-dialog-card"><h3 id="forgot-password-title">Password recovery</h3><p>Password reset is unavailable because an email delivery service is not configured for this application.</p><button type="button" id="close-forgot-password">Close</button></section></div>
<script>
document.getElementById('auth-theme-toggle').addEventListener('click',function(){var dark=document.documentElement.classList.toggle('dark');try{localStorage.setItem('habitflow-theme',dark?'dark':'light')}catch(e){}document.querySelector('meta[name="theme-color"]').content=dark?'#080808':'#F8FAFC'});
document.querySelectorAll('[data-password-toggle]').forEach(function(button){button.addEventListener('click',function(){var input=document.getElementById(button.dataset.passwordToggle);var show=input.type==='password';input.type=show?'text':'password';button.textContent=show?'Hide':'Show'});});
var form=document.getElementById('auth-form'),password=document.getElementById('auth-password'),confirmation=document.getElementById('auth-confirm-password'),hint=document.getElementById('password-match');
function validatePassword(){if(!confirmation)return;var same=confirmation.value===password.value;confirmation.setCustomValidity(same?'':'Passwords do not match.');if(hint&&confirmation.value){hint.textContent=same?'Passwords match.':'Passwords do not match.';hint.classList.toggle('invalid',!same)}}
if(confirmation){password.addEventListener('input',validatePassword);confirmation.addEventListener('input',validatePassword);form.addEventListener('submit',function(event){if(password.value!==confirmation.value){event.preventDefault();validatePassword();confirmation.reportValidity()}})}
var dialog=document.getElementById('forgot-password-dialog'),link=document.getElementById('forgot-password-link'),close=document.getElementById('close-forgot-password');if(link){link.addEventListener('click',function(event){event.preventDefault();dialog.classList.add('open');dialog.setAttribute('aria-hidden','false');close.focus()});close.addEventListener('click',function(){dialog.classList.remove('open');dialog.setAttribute('aria-hidden','true');link.focus()});dialog.addEventListener('click',function(event){if(event.target===dialog){dialog.classList.remove('open');dialog.setAttribute('aria-hidden','true')}})}
</script></body></html>