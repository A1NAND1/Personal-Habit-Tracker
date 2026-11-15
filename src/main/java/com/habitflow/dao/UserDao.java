package com.habitflow.dao;

import com.habitflow.model.UserAccount;
import java.util.Optional;

public interface UserDao {
    UserAccount create(String email, String passwordHash, String displayName);
    UserAccount createGoogleAccount(String email, String passwordHash, String displayName, String googleSubject);
    Optional<UserWithPassword> findByEmail(String email);
    Optional<UserAccount> findByGoogleSubject(String googleSubject);
    boolean linkGoogleSubject(long userId, String email, String googleSubject);
    UserAccount updateProfile(long userId, String displayName, String theme);
    record UserWithPassword(UserAccount account, String passwordHash) { }
}
