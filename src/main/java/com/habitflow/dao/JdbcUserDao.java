package com.habitflow.dao;

import com.habitflow.config.Database;
import com.habitflow.model.AccountSettings;
import com.habitflow.model.UserAccount;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Optional;

public final class JdbcUserDao implements UserDao {
    @Override public UserAccount create(String email, String passwordHash, String displayName) {
        String sql = "INSERT INTO users(email,password_hash,display_name,full_name) VALUES (?,?,?,?)";
        try (Connection c=Database.getConnection(); PreparedStatement p=c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            c.setAutoCommit(false);
            p.setString(1,email); p.setString(2,passwordHash); p.setString(3,displayName); p.setString(4,displayName); p.executeUpdate();
            long id;
            try (ResultSet r=p.getGeneratedKeys()) { if (!r.next()) throw new SQLException("No generated user id"); id=r.getLong(1); }
            saveDefaults(c,id);
            saveStarterHabits(c,id);
            c.commit(); return new UserAccount(id,email,displayName);
        } catch (SQLException e) {
            if ("23505".equals(e.getSQLState())) throw new IllegalArgumentException("An account with that email already exists");
            throw new IllegalStateException("Unable to create account",e);
        }
    }
    private void saveDefaults(Connection c,long userId) throws SQLException {
        try (PreparedStatement p=c.prepareStatement("INSERT INTO user_preferences(user_id) VALUES (?)")) { p.setLong(1,userId); p.executeUpdate(); }
    }
    private void saveStarterHabits(Connection c,long userId) throws SQLException {
        String sql="INSERT INTO habits(user_id,name,description,category,frequency,color,created_at) VALUES (?,?,?,?,?,?,?)";
        String[][] starters={
            {"Read for 10 minutes","Spend a little time with a book or article.","Learning","Daily","#2583D8"},
            {"Move for 15 minutes","Take a walk or do a short stretch.","Body","Daily","#0FA77A"},
            {"Plan tomorrow","Write down one priority for the next day.","Mind","Weekdays","#7C3AED"}
        };
        try(PreparedStatement p=c.prepareStatement(sql)) {
            for(String[] habit:starters) {
                p.setLong(1,userId); p.setString(2,habit[0]); p.setString(3,habit[1]);
                p.setString(4,habit[2]); p.setString(5,habit[3]); p.setString(6,habit[4]);
                p.setDate(7,Date.valueOf(LocalDate.now())); p.addBatch();
            }
            p.executeBatch();
        }
    }
    @Override public Optional<UserWithPassword> findByEmail(String email) {
        String sql="SELECT id,email,display_name,password_hash FROM users WHERE email=?";
        try (Connection c=Database.getConnection(); PreparedStatement p=c.prepareStatement(sql)) {
            p.setString(1,email); try (ResultSet r=p.executeQuery()) { return r.next()?Optional.of(new UserWithPassword(new UserAccount(r.getLong("id"),r.getString("email"),r.getString("display_name")),r.getString("password_hash"))):Optional.empty(); }
        } catch (SQLException e) { throw new IllegalStateException("Unable to read account",e); }
    }
    @Override public UserAccount updateProfile(long userId,String displayName,String theme) {
        AccountSettings settings=findSettings(userId);
        return updateProfile(userId,displayName,settings.fullName(),settings.workspaceName(),
                settings.dailyReminderTime(),settings.weeklyGoalDays(),theme);
    }
    public UserAccount updateProfile(long userId,String displayName,String fullName,String workspaceName,
                                    LocalTime reminderTime,int weeklyGoalDays,String theme) {
        try (Connection c=Database.getConnection()) {
            c.setAutoCommit(false);
            try {
                try (PreparedStatement p=c.prepareStatement("UPDATE users SET display_name=?,full_name=? WHERE id=?")) { p.setString(1,displayName); p.setString(2,fullName); p.setLong(3,userId); if(p.executeUpdate()!=1) throw new SQLException("Account not found"); }
                try (PreparedStatement p=c.prepareStatement("UPDATE user_preferences SET theme=?,theme_selected=TRUE,workspace_name=?,daily_reminder_time=?,weekly_goal_days=?,updated_at=CURRENT_TIMESTAMP WHERE user_id=?")) {
                    p.setString(1,theme); p.setString(2,workspaceName);
                    if(reminderTime==null) p.setNull(3,Types.TIME); else p.setTime(3,Time.valueOf(reminderTime));
                    p.setInt(4,weeklyGoalDays); p.setLong(5,userId);
                    if(p.executeUpdate()!=1) throw new SQLException("Account preferences not found");
                }
                String email; try (PreparedStatement p=c.prepareStatement("SELECT email FROM users WHERE id=?")) { p.setLong(1,userId); try(ResultSet r=p.executeQuery()){if(!r.next())throw new SQLException("Account not found");email=r.getString(1);} }
                c.commit(); return new UserAccount(userId,email,displayName);
            } catch(SQLException e) { c.rollback(); throw e; }
        } catch (SQLException e) { throw new IllegalStateException("Unable to save profile",e); }
    }
    public AccountSettings findSettings(long userId) {
        String sql="SELECT u.full_name,p.workspace_name,p.daily_reminder_time,p.weekly_goal_days FROM users u JOIN user_preferences p ON p.user_id=u.id WHERE u.id=?";
        try(Connection c=Database.getConnection();PreparedStatement p=c.prepareStatement(sql)) {
            p.setLong(1,userId);
            try(ResultSet r=p.executeQuery()) {
                if(!r.next()) throw new SQLException("Account settings not found");
                Time reminder=r.getTime("daily_reminder_time");
                return new AccountSettings(r.getString("full_name"),r.getString("workspace_name"),
                        reminder==null?null:reminder.toLocalTime(),r.getInt("weekly_goal_days"));
            }
        } catch(SQLException e) { throw new IllegalStateException("Unable to read account settings",e); }
    }
}
