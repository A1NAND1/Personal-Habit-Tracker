# Database Design

The project uses an H2 database. Database.initialize() reads schema.sql when the web app starts. Local database files are saved in data/habitflow.

## Tables and relationship

One habit can have several check-ins. Each check-in belongs to one habit.

    habits (one) -------- (many) habit_checkins
      id                         habit_id
                                 checkin_date

## habits table

| Column | Type | Use |
| --- | --- | --- |
| id | BIGINT identity | Primary key for each habit |
| name | VARCHAR(120) | Required habit name |
| description | VARCHAR(500) | Optional description |
| category | VARCHAR(40) | Habit category |
| frequency | VARCHAR(20) | Daily, Weekdays, or Weekly |
| color | VARCHAR(20) | Habit accent color |
| created_at | DATE | Date when the habit was added |

## habit_checkins table

| Column | Type | Use |
| --- | --- | --- |
| id | BIGINT identity | Primary key for each check-in |
| habit_id | BIGINT | Links to habits.id |
| checkin_date | DATE | Date the habit was completed |
| note | VARCHAR(250) | Optional note |

The unique key on (habit_id, checkin_date) allows only one check-in for the same habit on the same date. The foreign key uses ON DELETE CASCADE, so deleting a habit also removes its check-ins.

## JDBC code

JdbcHabitDao uses prepared statements for database queries. It uses try-with-resources to close connections and query results. Check-in dates are grouped by habit in a map, and each habit's dates are stored in a set. HabitMetrics uses those dates to calculate streaks and the completion rate.

HabitService uses a read-write lock because multiple Servlet requests can reach the service at the same time. The database's unique key also protects check-in records from duplicates.

## Team members

- **Shaswat Gupta:** OOP models: Habit.java, HabitMetrics.java, HabitStats.java, HabitSchedule.java, DailySchedule.java, WeekdaySchedule.java, WeeklySchedule.java, and HabitScheduleFactory.java.
- **Saransh Mishra:** Database schema (schema.sql), JDBC configuration (Database.java, AppContextListener.java), and DAO files (HabitDao.java, JdbcHabitDao.java).
- **Ayush Sharma:** Service validation, exception handling, collections, and testing (HabitService.java, HabitValidationException.java, HabitServiceTest.java).
- **Shivansh Singh:** Servlets and web UI (HabitServlet.java, DashboardServlet.java, CheckInServlet.java, index.jsp, styles.css, app.js).
