package com.habitflow.service;

import at.favre.lib.crypto.bcrypt.BCrypt;
import com.habitflow.dao.UserDao;
import com.habitflow.model.UserAccount;
import java.util.Locale;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.regex.Pattern;

public final class AuthService {
    private static final Pattern EMAIL=Pattern.compile("^[^\\s@]{1,64}@[^\\s@.]+(?:\\.[^\\s@.]+)+$");
    private final UserDao users;
    public AuthService(UserDao users) { this.users=users; }
    public UserAccount register(String email,String password,String name) {
        String cleanEmail=normalizeEmail(email), cleanName=cleanName(name);
        validatePassword(password);
        String hash=BCrypt.withDefaults().hashToString(12,password.toCharArray());
        return users.create(cleanEmail,hash,cleanName);
    }
    public UserAccount login(String email,String password) {
        String cleanEmail=normalizeEmail(email);
        var match=users.findByEmail(cleanEmail);
        if(match.isPresent() && password!=null && BCrypt.verifyer().verify(password.toCharArray(),match.get().passwordHash()).verified) return match.get().account();
        throw new IllegalArgumentException("Email or password is incorrect");
    }
    public UserAccount loginWithVerifiedGoogle(String googleSubject,String verifiedEmail,String verifiedName) {
        String subject=googleSubject==null?"":googleSubject.trim();
        if(subject.isEmpty() || subject.length()>255) throw new IllegalArgumentException("Google did not provide a valid account identifier");
        String cleanEmail=normalizeEmail(verifiedEmail);
        var linked=users.findByGoogleSubject(subject);
        if(linked.isPresent()) return linked.get();
        if(users.findByEmail(cleanEmail).isPresent()) {
            throw new IllegalArgumentException("This email already has a HabitFlow password account. Sign in with your password, then connect Google in Account Settings.");
        }
        String fallbackName=cleanEmail.substring(0,cleanEmail.indexOf('@')).replace('.',' ').replace('_',' ');
        String cleanName=verifiedName==null||verifiedName.isBlank()?fallbackName:verifiedName.trim();
        if(cleanName.length()>80) cleanName=cleanName.substring(0,80);
        if(cleanName.length()<2) cleanName="HabitFlow User";
        byte[] randomBytes=new byte[32]; new SecureRandom().nextBytes(randomBytes);
        String randomSecret=Base64.getUrlEncoder().withoutPadding().encodeToString(randomBytes);
        String hash=BCrypt.withDefaults().hashToString(12,randomSecret.toCharArray());
        try { return users.createGoogleAccount(cleanEmail,hash,cleanName,subject); }
        catch(IllegalArgumentException race) {
            return users.findByGoogleSubject(subject).orElseThrow(() -> race);
        }
    }
    public void verifyPasswordForLink(UserAccount current,String password) {
        if(current==null || login(current.email(),password).id()!=current.id()) {
            throw new IllegalArgumentException("Enter your HabitFlow password to connect Google.");
        }
    }
    public void linkVerifiedGoogle(UserAccount current,String googleSubject,String verifiedEmail) {
        if(current==null) throw new IllegalArgumentException("Sign in with your HabitFlow password before connecting Google.");
        String email=normalizeEmail(verifiedEmail);
        if(!email.equals(normalizeEmail(current.email()))) {
            throw new IllegalArgumentException("Use the Google account with the same verified email as this HabitFlow account.");
        }
        var linked=users.findByGoogleSubject(googleSubject);
        if(linked.isPresent() && linked.get().id()!=current.id()) {
            throw new IllegalArgumentException("This Google account is already linked to another HabitFlow account.");
        }
        if(linked.isEmpty() && !users.linkGoogleSubject(current.id(),email,googleSubject)) {
            throw new IllegalArgumentException("A Google account is already linked, or the HabitFlow account could not be verified.");
        }
    }
    private String normalizeEmail(String email) {
        String value=email==null?"":email.trim().toLowerCase(Locale.ROOT);
        if(value.length()>254 || !EMAIL.matcher(value).matches()) throw new IllegalArgumentException("Enter a valid email address");
        return value;
    }
    private String cleanName(String name) {
        String value=name==null?"":name.trim();
        if(value.length()<2 || value.length()>80 || value.chars().anyMatch(Character::isISOControl)) throw new IllegalArgumentException("Name must be between 2 and 80 characters");
        return value;
    }
    private void validatePassword(String password) {
        if(password==null || password.length()<10 || password.getBytes(java.nio.charset.StandardCharsets.UTF_8).length>72 || password.chars().anyMatch(Character::isISOControl)) throw new IllegalArgumentException("Password must be 10 or more characters and no more than 72 UTF-8 bytes");
    }
}
