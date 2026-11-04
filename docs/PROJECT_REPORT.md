# Personal Habit Tracker - Project Report

## 1. Introduction

This project is a Java web app for keeping track of daily habits. A user can create a habit, choose how often it should happen, and record a check-in. The dashboard shows the user's progress. The app is called HabitFlow in the web interface.

## 2. Problem statement

It can be hard to remember which habits were completed on each day. This app keeps the habit list and check-in history together so the user can review progress.

## 3. Objectives

- Add habits with a category and schedule.
- Save one check-in for a habit on each date.
- Show streaks, weekly check-ins, and recent completion rate.
- Store the data in a relational database.
- Use Java concepts such as classes, inheritance, collections, exceptions, JDBC, and Servlets.

## 4. Scope

This version is designed for one user running the app locally. It does not have user accounts, online syncing, or reminders.

## 5. Tools used

- Java 17
- Jakarta Servlets and JSP
- JDBC and H2 Database
- Maven
- HTML, CSS, and JavaScript
- Apache Tomcat 10.1 or newer

## 6. How the app is organized

1. The Servlets receive requests from the browser.
2. index.jsp displays the dashboard.
3. HabitService checks input and runs habit operations.
4. HabitDao describes the database operations, and JdbcHabitDao runs the SQL.
5. Database opens H2 connections and loads the schema when the app starts.

AppContextListener creates the service when Tomcat starts the app. It also closes the service's background executor when the app stops.

## 7. Java concepts used

- **OOP and inheritance:** Daily, weekday, and weekly schedules extend HabitSchedule and have their own schedule rules.
- **Factory:** HabitScheduleFactory creates the right schedule from the selected frequency.
- **Collections:** Lists, maps, and sets hold habit records and check-in dates.
- **JDBC:** Prepared statements send values to the database. Try-with-resources closes database objects.
- **Exceptions:** HabitValidationException is used when a form value is not valid.
- **Threads:** CompletableFuture runs dashboard statistics on a small executor.
- **Synchronization:** ReentrantReadWriteLock controls access to the shared service.
- **Servlets:** DashboardServlet, HabitServlet, and CheckInServlet handle browser requests.

## 8. Database

There are two tables: habits and habit_checkins. One habit can have multiple check-ins. The database has a unique key on the habit and date, so duplicate check-ins are not stored. A foreign key removes check-ins when their habit is deleted. More details are in [Database Design](DATABASE_DESIGN.md).

## 9. Main steps for a user

1. Open the dashboard.
2. Add a habit and choose its category and schedule.
3. Mark the habit complete on a scheduled day.
4. Check the streak and weekly progress.
5. Undo a check-in or delete a habit if needed.

## 10. Limitations and next steps

The project runs locally and is for one user. In a later version, we could add user accounts, reminders, a calendar view, and CSV export.

## 11. Team members

- **Shaswat Gupta:** OOP models: Habit.java, HabitMetrics.java, HabitStats.java, HabitSchedule.java, DailySchedule.java, WeekdaySchedule.java, WeeklySchedule.java, and HabitScheduleFactory.java.
- **Saransh Mishra:** Database schema (schema.sql), JDBC configuration (Database.java, AppContextListener.java), and DAO files (HabitDao.java, JdbcHabitDao.java).
- **Ayush Sharma:** Service validation, exception handling, collections, and testing (HabitService.java, HabitValidationException.java, HabitServiceTest.java).
- **Shivansh Singh:** Servlets and web UI (HabitServlet.java, DashboardServlet.java, CheckInServlet.java, index.jsp, styles.css, app.js).

## 12. Conclusion

We built a habit tracker with a Java web layer and an H2 database. The project helped us practise OOP, collections, exception handling, JDBC, and Servlets.
