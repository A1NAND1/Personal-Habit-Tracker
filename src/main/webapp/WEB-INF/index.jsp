<%-- Shivansh Singh: Servlet and JSP web UI. --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HabitFlow | Build better days</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles.css">
    <script defer src="${pageContext.request.contextPath}/assets/app.js"></script>
</head>
<body>
<div class="app-shell">
    <aside class="sidebar">
        <div class="brand"><span class="brand-mark">H</span><span>Habit<span>Flow</span></span></div>
        <nav>
            <a class="nav-link active" href="${pageContext.request.contextPath}/"><span>⌂</span> Dashboard</a>
            <a class="nav-link" href="#habits"><span>✓</span> My habits</a>
            <a class="nav-link" href="#add-habit"><span>＋</span> Add habit</a>
        </nav>
        <div class="sidebar-tip">
            <div class="tip-icon">✦</div>
            <strong>Small steps.</strong>
            <p>Consistency beats intensity. Show up today.</p>
        </div>
        <div class="profile"><div class="avatar">A</div><div><strong>My routine</strong><small>Personal workspace</small></div></div>
    </aside>

    <main class="content">
        <header class="topbar"><div><p class="eyebrow">${todayDay}, ${today}</p><h1>Good morning, achiever <span>✦</span></h1><p class="subtitle">Make today count, one habit at a time.</p></div><div class="date-pill">◎ <span id="live-date"></span></div></header>

        <c:if test="${not empty param.message}"><div class="toast success"><c:out value="${param.message}" /></div></c:if>
        <c:if test="${not empty param.error}"><div class="toast error"><c:out value="${param.error}" /></div></c:if>

        <section class="stats-grid">
            <div class="stat-card purple"><div class="stat-icon">◈</div><span>Active habits</span><strong>${stats.totalHabits}</strong><small>Keep building momentum</small></div>
            <div class="stat-card green"><div class="stat-icon">✓</div><span>Completed today</span><strong>${stats.completedToday}<em> / ${stats.totalHabits}</em></strong><small>Great start to the day</small></div>
            <div class="stat-card orange"><div class="stat-icon">♨</div><span>Best streak</span><strong>${stats.bestStreak}<em> days</em></strong><small>Protect your progress</small></div>
            <div class="stat-card blue"><div class="stat-icon">↗</div><span>Check-ins</span><strong>${stats.weeklyCompletions}</strong><small>Your consistency score</small></div>
        </section>

        <section class="section-heading" id="habits"><div><h2>Today’s habits</h2><p>Check in when you complete a habit.</p></div><button class="primary-btn" onclick="openModal()">＋ New habit</button></section>
        <section class="habit-list">
            <c:choose>
                <c:when test="${empty habits}">
                    <div class="empty-state"><div class="empty-icon">✦</div><h3>Your routine starts here</h3><p>Add your first habit and turn intention into progress.</p><button class="primary-btn" onclick="openModal()">Create first habit</button></div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="habit" items="${habits}">
                        <article class="habit-card">
                            <div class="habit-color" style="background:${habit.color}"></div>
                            <div class="habit-main"><div class="habit-title-row"><h3><c:out value="${habit.name}" /></h3><span class="category"><c:out value="${habit.category}" /></span></div><p><c:out value="${habit.description}" /></p><div class="habit-meta"><span>◷ <c:out value="${habit.frequency}" /></span><span>♨ ${habit.currentStreak} day streak</span><span>${habit.completionRate}% this month</span></div></div>
                            <form method="post" action="${pageContext.request.contextPath}/checkins" class="checkin-form"><input type="hidden" name="habitId" value="${habit.id}"><button class="check-btn ${habit.completedToday ? 'checked' : ''}" title="${not habit.scheduledToday ? 'Not scheduled today' : (habit.completedToday ? 'Undo check-in' : 'Mark complete')}" <c:if test="${not habit.scheduledToday}">disabled</c:if>>${habit.completedToday ? '✓' : '○'}</button></form>
                            <button class="delete-btn" data-id="${habit.id}" title="Delete habit">×</button>
                        </article>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </section>

        <section class="insight"><div class="insight-symbol">✦</div><div><strong>Consistency insight</strong><p><c:choose><c:when test="${stats.completedToday > 0}">You’re already in motion today. One more check-in keeps your identity strong.</c:when><c:otherwise>Every journey begins with one check-in. What will you complete first?</c:otherwise></c:choose></p></div></section>

        <footer>HabitFlow · Built with Java, Servlets, JDBC &amp; H2 <span>•</span> Make progress visible.</footer>
    </main>
</div>

<div class="modal-backdrop" id="habit-modal">
    <div class="modal"><button class="close-btn" onclick="closeModal()">×</button><div class="modal-kicker">NEW ROUTINE</div><h2>Create a habit</h2><p class="modal-subtitle">Choose something small enough to repeat and meaningful enough to matter.</p>
        <form method="post" action="${pageContext.request.contextPath}/habits" id="add-habit">
            <label>Habit name<input name="name" required maxlength="120" placeholder="e.g. Read for 20 minutes"></label>
            <label>Description<textarea name="description" maxlength="500" placeholder="Why does this habit matter to you?"></textarea></label>
            <div class="form-row"><label>Category<select name="category"><option>Mind</option><option>Body</option><option>Career</option><option>Wellness</option><option>Learning</option></select></label><label>Frequency<select name="frequency"><option>Daily</option><option>Weekdays</option><option>Weekly</option></select></label></div>
            <label>Accent color<div class="color-options"><label><input type="radio" name="color" value="#5B5FEF" checked><span style="background:#5B5FEF"></span></label><label><input type="radio" name="color" value="#0FA77A"><span style="background:#0FA77A"></span></label><label><input type="radio" name="color" value="#F08C46"><span style="background:#F08C46"></span></label><label><input type="radio" name="color" value="#2583D8"><span style="background:#2583D8"></span></label></div></label>
            <button class="primary-btn full" type="submit">Add to my routine ✦</button>
        </form>
    </div>
</div>
</body>
</html>
