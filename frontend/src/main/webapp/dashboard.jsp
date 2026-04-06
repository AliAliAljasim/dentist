<%@ page import="Helper.UserInfo" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
UserInfo user = (UserInfo) session.getAttribute("user");
if (user == null) { response.sendRedirect("login.jsp"); return; }

String searchService = System.getenv("SEARCH_SERVICE");
if (searchService == null || searchService.isEmpty()) searchService = "localhost:8082";
String dentistApiBase = "http://" + searchService + "/search-service/api";
String jwtToken = user.getToken();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Dashboard – DentalCare</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    font-family: 'Inter', Arial, sans-serif;
    background: #f0f4f8;
    min-height: 100vh;
  }
  /* Top navbar */
  .navbar {
    background: linear-gradient(135deg, #1a8a7a, #0d5f73);
    padding: 0 32px;
    height: 64px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    box-shadow: 0 2px 12px rgba(0,0,0,0.15);
  }
  .navbar .brand { color: white; font-size: 20px; font-weight: 700; letter-spacing: -0.3px; }
  .navbar .brand span { opacity: 0.75; font-weight: 400; }
  .navbar .user-pill {
    background: rgba(255,255,255,0.15);
    color: white;
    padding: 6px 14px;
    border-radius: 20px;
    font-size: 13px;
    font-weight: 500;
  }
  /* Main layout */
  .main { max-width: 900px; margin: 40px auto; padding: 0 20px; }
  .greeting { margin-bottom: 28px; }
  .greeting h2 { font-size: 26px; font-weight: 700; color: #1a1a2e; }
  .greeting p  { color: #666; font-size: 14px; margin-top: 4px; }
  /* Quick-action cards */
  .cards { display: grid; grid-template-columns: repeat(3, 1fr); gap: 18px; margin-bottom: 32px; }
  .card {
    background: white;
    border-radius: 16px;
    padding: 28px 24px;
    text-decoration: none;
    box-shadow: 0 2px 12px rgba(0,0,0,0.07);
    transition: transform 0.18s, box-shadow 0.18s;
    display: flex;
    flex-direction: column;
    gap: 10px;
  }
  .card:hover { transform: translateY(-4px); box-shadow: 0 8px 24px rgba(0,0,0,0.12); }
  .card .icon { font-size: 32px; }
  .card .card-title { font-size: 15px; font-weight: 600; color: #1a1a2e; }
  .card .card-desc  { font-size: 13px; color: #888; line-height: 1.5; }
  .card.schedule { border-top: 4px solid #1a8a7a; }
  .card.billing  { border-top: 4px solid #f0a500; }
  .card.logout   { border-top: 4px solid #e05555; }
  /* Search panel */
  .panel {
    background: white;
    border-radius: 16px;
    padding: 28px;
    box-shadow: 0 2px 12px rgba(0,0,0,0.07);
  }
  .panel h3 { font-size: 17px; font-weight: 600; color: #1a1a2e; margin-bottom: 16px; }
  .search-row { display: flex; gap: 10px; }
  .search-row select {
    padding: 11px 14px;
    border: 1.5px solid #e0e0e0;
    border-radius: 10px;
    font-size: 14px;
    font-family: inherit;
    outline: none;
    color: #333;
    background: white;
    transition: border-color 0.2s, box-shadow 0.2s;
  }
  .search-row input {
    flex: 1;
    padding: 11px 16px;
    border: 1.5px solid #e0e0e0;
    border-radius: 10px;
    font-size: 14px;
    font-family: inherit;
    outline: none;
    transition: border-color 0.2s, box-shadow 0.2s;
    color: #333;
  }
  .search-row input:focus {
    border-color: #1a8a7a;
    box-shadow: 0 0 0 3px rgba(26,138,122,0.12);
  }
  .search-row select:focus {
    border-color: #1a8a7a;
    box-shadow: 0 0 0 3px rgba(26,138,122,0.12);
  }
  .search-row button {
    padding: 11px 22px;
    background: linear-gradient(135deg, #1a8a7a, #0d5f73);
    color: white;
    border: none;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    font-family: inherit;
    transition: opacity 0.2s, transform 0.1s;
    white-space: nowrap;
  }
  .search-row button:hover { opacity: 0.9; transform: translateY(-1px); }
  #results { margin-top: 16px; }
  .result-item {
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 12px 16px;
    background: #f8fafb;
    border-radius: 10px;
    margin-bottom: 8px;
    border-left: 3px solid #1a8a7a;
  }
  .result-item .avatar {
    width: 38px; height: 38px;
    background: linear-gradient(135deg, #1a8a7a, #0d5f73);
    border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
    color: white; font-size: 16px; flex-shrink: 0;
  }
  .result-item .info { flex: 1; min-width: 0; }
  .result-item .info .name { font-weight: 600; font-size: 14px; color: #1a1a2e; }
  .result-item .info .detail { font-size: 12px; color: #777; margin-top: 2px; }
  .status-msg { color: #999; font-size: 13px; padding: 8px 0; }
  @media (max-width: 640px) {
    .cards { grid-template-columns: 1fr; }
    .navbar { padding: 0 16px; }
    .main { margin: 20px auto; }
  }
</style>
</head>
<body>
<nav class="navbar">
  <div class="brand">🦷 DentalCare <span>System</span></div>
  <div class="user-pill">👤 <%= user.getUsername() %></div>
</nav>

<div class="main">
  <div class="greeting">
    <h2>Good day, <%= user.getUsername() %></h2>
    <p>What would you like to do today?</p>
  </div>

  <div class="cards">
    <a class="card schedule" href="schedule.jsp">
      <div class="icon">📅</div>
      <div class="card-title">Schedule Appointment</div>
      <div class="card-desc">Book a new appointment and view your upcoming visits.</div>
    </a>
    <a class="card billing" href="BillingServlet">
      <div class="icon">💳</div>
      <div class="card-title">View Billing</div>
      <div class="card-desc">Check your invoices and payment history.</div>
    </a>
    <a class="card logout" href="login.jsp">
      <div class="icon">🚪</div>
      <div class="card-title">Sign Out</div>
      <div class="card-desc">Securely log out of your account.</div>
    </a>
  </div>

  <div class="panel">
    <h3>Search Dentists</h3>
    <div class="search-row">
      <select id="searchType" aria-label="Search type">
        <option value="name">Name</option>
        <option value="specialty">Specialty</option>
      </select>
      <input type="text" id="dentistName" placeholder="Search dentists…"/>
      <button onclick="searchDentist()">Search</button>
    </div>
    <div id="results"></div>
  </div>
</div>

<script>
const JWT_TOKEN = "<%= jwtToken %>";

async function searchDentist() {
  const term = document.getElementById("dentistName").value.trim();
  const searchType = document.getElementById("searchType").value;
  const div = document.getElementById("results");
  if (!term) return;
  div.innerHTML = '<p class="status-msg">Searching…</p>';
  try {
    const res = await fetch("/frontend/api/search/dentists?" + searchType + "=" + encodeURIComponent(term), {
      headers: { "Authorization": "Bearer " + JWT_TOKEN }
    });
    if (!res.ok) { div.innerHTML = '<p class="status-msg">Search failed. Please try again.</p>'; return; }
    const dentists = await res.json();
    if (dentists.length === 0) { div.innerHTML = '<p class="status-msg">No dentists found matching your search.</p>'; return; }
    div.innerHTML = dentists.map(d =>
      `<div class="result-item">
        <div class="avatar">🦷</div>
        <div class="info">
          <div class="name">\${d.name}</div>
          <div class="detail">\${d.clinic}\${d.specialty ? ' &nbsp;·&nbsp; ' + d.specialty : ''}</div>
        </div>
      </div>`
    ).join('');
  } catch(e) {
    div.innerHTML = '<p class="status-msg">Could not reach search service.</p>';
  }
}

document.getElementById("dentistName").addEventListener("keydown", e => {
  if (e.key === "Enter") searchDentist();
});
</script>
</body>
</html>
