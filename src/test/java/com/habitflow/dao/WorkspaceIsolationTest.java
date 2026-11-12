package com.habitflow.dao;

import com.habitflow.config.Database;
import com.habitflow.service.AuthService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.UUID;
import static org.junit.jupiter.api.Assertions.*;

class WorkspaceIsolationTest {
    @BeforeEach void setup() {
        System.setProperty("habit.tracker.environment","test");
        System.setProperty("habit.tracker.jdbc.url","jdbc:h2:mem:workspace_"+UUID.randomUUID().toString().replace("-","")+";DB_CLOSE_DELAY=-1");
        System.setProperty("habit.tracker.jdbc.user","sa"); System.setProperty("habit.tracker.jdbc.password",""); Database.initialize();
    }
    @Test void privateDataIsAccountScopedAndAvailableThroughAnotherDatabaseClient() {
        JdbcUserDao users=new JdbcUserDao(); AuthService auth=new AuthService(users);
        var alice=auth.register("alice@example.test","a-long-test-password","Alice");
        var bob=auth.register("bob@example.test","another-test-password","Bob");
        assertNotEquals(alice.id(),bob.id());
        assertTrue(users.findByEmail("alice@example.test").orElseThrow().passwordHash().startsWith("$2"));
        assertEquals(alice.id(),auth.login("ALICE@example.test","a-long-test-password").id());
        assertThrows(IllegalArgumentException.class,()->auth.login("alice@example.test","wrong-password"));
        long habitId=new JdbcHabitDao().save(alice.id(),"Read","A chapter","Learning","Daily","#5B5FEF");
        JdbcWorkspaceDao writer=new JdbcWorkspaceDao(); LocalDate today=LocalDate.now();
        writer.saveHistoricalCheckin(alice.id(),habitId,today,true);
        writer.saveNote(alice.id(),habitId,today,"Read for 20 minutes");
        writer.saveMetadata(alice.id(),habitId,"Morning",1,2,today);
        writer.saveFocus(alice.id(),habitId,Timestamp.valueOf(LocalDateTime.now().minusMinutes(25)),25);

        // A second DAO instance checks persisted reads; this does not emulate a browser or device.
        Map<String,Object> onSecondClient=new JdbcWorkspaceDao().load(alice.id());
        assertTrue(((Map<?,?>)onSecondClient.get("done")).containsKey(habitId+"|"+today));
        Map<?,?> aliceMetadata=(Map<?,?>)((Map<?,?>)onSecondClient.get("metadata")).get(String.valueOf(habitId));
        assertEquals("Read for 20 minutes",((Map<?,?>)aliceMetadata.get("notes")).get(today.toString()));
        assertEquals(25,((Map<?,?>)onSecondClient.get("focus")).get("totalMinutes"));

        Map<String,Object> bobWorkspace=new JdbcWorkspaceDao().load(bob.id());
        assertTrue(((Map<?,?>)bobWorkspace.get("done")).isEmpty());
        assertTrue(((Map<?,?>)bobWorkspace.get("metadata")).isEmpty());
        assertEquals(0,((Map<?,?>)bobWorkspace.get("focus")).get("totalMinutes"));
        assertTrue(new JdbcHabitDao().findAllWithProgress(bob.id(),today).isEmpty());
        assertTrue(new JdbcHabitDao().findById(bob.id(),habitId).isEmpty());
    }
}
