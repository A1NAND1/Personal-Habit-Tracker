# Personal Habit Tracker

## Project overview

This is our Java subject project. It is a small web app where a user can add habits and mark them complete each day. The dashboard shows streaks and recent progress. The app name shown in the interface is HabitFlow.

The project uses Java Servlets and JSP for the web pages. JDBC connects the app to an H2 database. Maven builds the project, and Tomcat runs it.

## Main features

- Add a habit with a name, description, category, frequency, and color.
- Set a habit to repeat every day, on weekdays, or once a week.
- Mark a habit complete for today or undo the check-in.
- View current streaks, best streaks, weekly check-ins, and completion rate.
- Save habits and check-ins in a local H2 database.

## Requirements

- JDK 17 or newer
- Maven 3.9 or newer
- Apache Tomcat 10.1 or newer

## Run the project

Open a terminal in this folder and build the WAR file:

    mvn clean package

Copy target/habitflow.war into Tomcat's webapps folder and start Tomcat. On Windows, use bin\startup.bat to start it and bin\shutdown.bat to stop it. Then open:

    http://localhost:8080/habitflow/

The app creates the database and tables on its first run. The local database files are stored in data/.

## Project folders

    src/main/java/com/habitflow/
      config/       Database connection and app startup
      dao/          Database interface and JDBC code
      model/        Habit data, schedules, and progress calculations
      service/      Validation and habit operations
      servlet/      Web request handlers
    src/main/resources/schema.sql
    src/main/webapp/
    docs/

## Java topics in this project

- **OOP:** HabitSchedule has daily, weekday, and weekly schedule classes. The factory selects a schedule.
- **Interfaces:** HabitDao separates the service from the database implementation.
- **Collections:** Lists, maps, and sets store habits and their check-in dates.
- **JDBC:** JdbcHabitDao uses prepared statements to read and update the H2 database.
- **Servlets and JSP:** Servlets handle requests and index.jsp displays the dashboard.
- **Exceptions:** The service checks input and reports invalid values with HabitValidationException.
- **Threads and locks:** Dashboard statistics use CompletableFuture; a read-write lock protects shared service operations.

## Team members

- **Shaswat Gupta:** OOP models: Habit.java, HabitMetrics.java, HabitStats.java, HabitSchedule.java, DailySchedule.java, WeekdaySchedule.java, WeeklySchedule.java, and HabitScheduleFactory.java.
- **Saransh Mishra:** Database schema (schema.sql), JDBC configuration (Database.java, AppContextListener.java), and DAO files (HabitDao.java, JdbcHabitDao.java).
- **Ayush Sharma:** Service validation, exception handling, collections, and testing (HabitService.java, HabitValidationException.java, HabitServiceTest.java).
- **Shivansh Singh:** Servlets and web UI (HabitServlet.java, DashboardServlet.java, CheckInServlet.java, index.jsp, styles.css, app.js).

## Project documents

- [Project report](docs/PROJECT_REPORT.md)
- [Database design](docs/DATABASE_DESIGN.md)
- [Project presentation](docs/HabitFlow_Project_Presentation_v2.pptx)
