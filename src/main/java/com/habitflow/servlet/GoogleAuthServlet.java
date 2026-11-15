package com.habitflow.servlet;

import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.json.gson.GsonFactory;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.habitflow.model.UserAccount;
import com.habitflow.service.AuthService;
import com.habitflow.web.SecurityFilter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.time.Duration;
import java.util.Base64;
import java.util.List;
import java.util.Map;
import java.util.StringJoiner;

@WebServlet(urlPatterns = {"/auth/google", "/auth/google/callback", "/auth/google/link"})
public final class GoogleAuthServlet extends HttpServlet {
    private static final String STATE = "google_oauth_state";
    private static final String NONCE = "google_oauth_nonce";
    private static final String MODE = "google_oauth_mode";
    private static final String LINK_USER = "google_oauth_link_user_id";
    private static final int REMEMBER_ME_SECONDS = 30 * 24 * 60 * 60;
    private static final SecureRandom RANDOM = new SecureRandom();
    private static final HttpClient HTTP = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(10)).followRedirects(HttpClient.Redirect.NEVER).build();

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = path(req);
        if ("/auth/google/callback".equals(path)) { callback(req, resp); return; }
        if (!"/auth/google".equals(path)) { resp.sendError(HttpServletResponse.SC_NOT_FOUND); return; }
        String mode = "register".equalsIgnoreCase(req.getParameter("mode")) ? "register" : "login";
        if (!configured()) { showAuthError(req, resp, mode, "Google Sign-In is not configured yet. Please use Email and Password."); return; }
        begin(req, resp, mode, null);
    }

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!"/auth/google/link".equals(path(req))) { resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED); return; }
        UserAccount current = (UserAccount) req.getSession(false).getAttribute(SecurityFilter.ACCOUNT);
        if (current == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }
        if (!configured()) { resp.sendRedirect(req.getContextPath() + "/?error=Google+Sign-In+is+not+configured"); return; }
        try {
            authService(req).verifyPasswordForLink(current, req.getParameter("password"));
            begin(req, resp, "link", current.id());
        } catch (IllegalArgumentException e) {
            resp.sendRedirect(req.getContextPath() + "/?error=Password+could+not+be+verified");
        }
    }

    private void begin(HttpServletRequest req, HttpServletResponse resp, String mode, Long linkUserId) throws IOException {
        HttpSession session = req.getSession(true);
        String state = randomToken();
        String nonce = randomToken();
        session.setAttribute(STATE, state);
        session.setAttribute(NONCE, nonce);
        session.setAttribute(MODE, mode);
        if (linkUserId == null) session.removeAttribute(LINK_USER);
        else session.setAttribute(LINK_USER, linkUserId);

        String redirectUri = redirectUri(req);
        String query = form(Map.of(
                "client_id", setting("GOOGLE_CLIENT_ID"),
                "redirect_uri", redirectUri,
                "response_type", "code",
                "scope", "openid email profile",
                "state", state,
                "nonce", nonce,
                "prompt", "select_account"));
        resp.sendRedirect("https://accounts.google.com/o/oauth2/v2/auth?" + query);
    }

    private void callback(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Object storedState = session == null ? null : session.getAttribute(STATE);
        Object storedNonce = session == null ? null : session.getAttribute(NONCE);
        Object storedMode = session == null ? null : session.getAttribute(MODE);
        Object linkUserId = session == null ? null : session.getAttribute(LINK_USER);
        if (session != null) {
            session.removeAttribute(STATE); session.removeAttribute(NONCE);
            session.removeAttribute(MODE); session.removeAttribute(LINK_USER);
        }
        String mode = "register".equals(storedMode) ? "register" : "login";
        if (!constantTimeEquals(storedState, req.getParameter("state"))) {
            showAuthError(req, resp, mode, "Google sign-in could not be verified. Please try again."); return;
        }
        if (req.getParameter("error") != null) {
            if ("link".equals(storedMode)) { resp.sendRedirect(req.getContextPath() + "/?error=Google+account+connection+cancelled"); return; }
            showAuthError(req, resp, mode, "Google sign-in was cancelled. You can use Email and Password instead."); return;
        }
        if (storedNonce == null || req.getParameter("code") == null || req.getParameter("code").isBlank() || !configured()) {
            showAuthError(req, resp, mode, "Google sign-in could not be completed. Please try again."); return;
        }
        try {
            GoogleIdentity identity = exchangeAndVerify(req.getParameter("code"), redirectUri(req), (String) storedNonce);
            if ("link".equals(storedMode)) {
                UserAccount current = (UserAccount) session.getAttribute(SecurityFilter.ACCOUNT);
                if (current == null || !(linkUserId instanceof Long) || current.id() != (Long) linkUserId) {
                    resp.sendRedirect(req.getContextPath() + "/login?error=Please+sign+in+again+before+connecting+Google"); return;
                }
                authService(req).linkVerifiedGoogle(current, identity.subject(), identity.email());
                rotateSession(req, resp, current);
                resp.sendRedirect(req.getContextPath() + "/?message=Google+account+connected");
                return;
            }
            UserAccount account = authService(req).loginWithVerifiedGoogle(identity.subject(), identity.email(), identity.name());
            rotateSession(req, resp, account);
            resp.sendRedirect(req.getContextPath() + "/");
        } catch (Exception e) {
            getServletContext().log("Google sign-in was rejected or unavailable", e);
            if ("link".equals(storedMode)) resp.sendRedirect(req.getContextPath() + "/?error=Google+account+could+not+be+connected");
            else showAuthError(req, resp, mode, safeAuthMessage(e));
        }
    }

    private GoogleIdentity exchangeAndVerify(String code, String redirectUri, String expectedNonce) throws Exception {
        String body = form(Map.of("code", code, "client_id", setting("GOOGLE_CLIENT_ID"),
                "client_secret", setting("GOOGLE_CLIENT_SECRET"), "redirect_uri", redirectUri,
                "grant_type", "authorization_code"));
        HttpRequest request = HttpRequest.newBuilder(URI.create("https://oauth2.googleapis.com/token"))
                .timeout(Duration.ofSeconds(15)).header("Content-Type", "application/x-www-form-urlencoded")
                .POST(HttpRequest.BodyPublishers.ofString(body)).build();
        HttpResponse<String> response = HTTP.send(request, HttpResponse.BodyHandlers.ofString());
        if (response.statusCode() != 200) throw new SecurityException("Google token exchange failed");
        JsonObject tokenResponse = JsonParser.parseString(response.body()).getAsJsonObject();
        if (!tokenResponse.has("id_token") || tokenResponse.get("id_token").isJsonNull()) throw new SecurityException("Google ID token was missing");

        GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                GoogleNetHttpTransport.newTrustedTransport(), GsonFactory.getDefaultInstance())
                .setAudience(List.of(setting("GOOGLE_CLIENT_ID"))).build();
        GoogleIdToken idToken = verifier.verify(tokenResponse.get("id_token").getAsString());
        if (idToken == null) throw new SecurityException("Google ID token verification failed");
        GoogleIdToken.Payload payload = idToken.getPayload();
        Object nonce = payload.get("nonce");
        if (!constantTimeEquals(expectedNonce, nonce == null ? null : nonce.toString())) throw new SecurityException("Google nonce verification failed");
        if (!Boolean.TRUE.equals(payload.getEmailVerified())) throw new SecurityException("Google email is not verified");
        String email = payload.getEmail();
        String subject = payload.getSubject();
        if (email == null || email.isBlank() || subject == null || subject.isBlank()) throw new SecurityException("Google identity is incomplete");
        Object name = payload.get("name");
        return new GoogleIdentity(subject, email, name == null ? null : name.toString());
    }

    private void rotateSession(HttpServletRequest req, HttpServletResponse resp, UserAccount account) {
        HttpSession session = req.getSession(false);
        if (session == null) session = req.getSession(true);
        req.changeSessionId();
        session.removeAttribute(STATE); session.removeAttribute(NONCE); session.removeAttribute(MODE); session.removeAttribute(LINK_USER);
        session.setAttribute(SecurityFilter.ACCOUNT, account);
        session.setAttribute(SecurityFilter.CSRF, SecurityFilter.newToken());
        session.setMaxInactiveInterval(REMEMBER_ME_SECONDS);
        String path = req.getContextPath().isEmpty() ? "/" : req.getContextPath();
        String cookie = "JSESSIONID=" + session.getId() + "; Path=" + path + "; Max-Age=" + REMEMBER_ME_SECONDS + "; HttpOnly; SameSite=Lax";
        if (req.isSecure() || "production".equalsIgnoreCase(System.getenv("APP_ENV"))) cookie += "; Secure";
        resp.setHeader("Set-Cookie", cookie);
    }

    private String redirectUri(HttpServletRequest req) {
        String explicit = setting("GOOGLE_REDIRECT_URI");
        if (explicit != null && !explicit.isBlank()) return explicit.trim();
        if ("production".equalsIgnoreCase(System.getenv("APP_ENV"))) throw new IllegalStateException("GOOGLE_REDIRECT_URI must be configured in production");
        String scheme = req.isSecure() ? "https" : "http";
        String forwardedProto = req.getHeader("X-Forwarded-Proto");
        if (forwardedProto != null && (forwardedProto.equalsIgnoreCase("http") || forwardedProto.equalsIgnoreCase("https"))) scheme = forwardedProto.toLowerCase();
        String host = req.getServerName();
        if (host == null || !host.matches("[A-Za-z0-9.-]+")) throw new IllegalStateException("Invalid OAuth callback host");
        int port = req.getServerPort();
        String authority = (port == 80 && "http".equals(scheme)) || (port == 443 && "https".equals(scheme)) ? host : host + ":" + port;
        return scheme + "://" + authority + req.getContextPath() + "/auth/google/callback";
    }

    private boolean configured() {
        return setting("GOOGLE_CLIENT_ID") != null && setting("GOOGLE_CLIENT_SECRET") != null
                && (!"production".equalsIgnoreCase(System.getenv("APP_ENV")) || setting("GOOGLE_REDIRECT_URI") != null);
    }
    private String setting(String name) {
        String value = System.getenv(name);
        if (value == null || value.isBlank()) value = System.getProperty(name);
        return value == null || value.isBlank() ? null : value.trim();
    }
    private AuthService authService(HttpServletRequest req) { return (AuthService) getServletContext().getAttribute("authService"); }
    private String path(HttpServletRequest req) { return req.getRequestURI().substring(req.getContextPath().length()); }
    private String randomToken() { byte[] bytes = new byte[32]; RANDOM.nextBytes(bytes); return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes); }
    private String form(Map<String, String> values) {
        StringJoiner result = new StringJoiner("&");
        values.forEach((key, value) -> result.add(encode(key) + "=" + encode(value)));
        return result.toString();
    }
    private String encode(String value) { return URLEncoder.encode(value, StandardCharsets.UTF_8); }
    private boolean constantTimeEquals(Object expected, String actual) {
        if (!(expected instanceof String value) || actual == null) return false;
        return MessageDigest.isEqual(value.getBytes(StandardCharsets.UTF_8), actual.getBytes(StandardCharsets.UTF_8));
    }
    private String safeAuthMessage(Exception error) {
        String message = error.getMessage();
        if (message != null && message.startsWith("This email already has")) return message;
        return "Google sign-in could not be completed. Please try again or use Email and Password.";
    }
    private void showAuthError(HttpServletRequest req, HttpServletResponse resp, String mode, String error) throws ServletException, IOException {
        req.setAttribute("mode", mode); req.setAttribute("error", error);
        HttpSession session = req.getSession(true);
        req.setAttribute(SecurityFilter.CSRF, session.getAttribute(SecurityFilter.CSRF));
        req.getRequestDispatcher("/WEB-INF/auth.jsp").forward(req, resp);
    }
    private record GoogleIdentity(String subject, String email, String name) { }
}
