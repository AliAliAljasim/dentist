<%@ page import="Helper.UserInfo" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
UserInfo user = (UserInfo) session.getAttribute("user");
if (user == null) { response.sendRedirect("login.jsp"); return; }

String appointmentService = System.getenv("APPOINTMENT_SERVICE");
if (appointmentService == null || appointmentService.isEmpty()) appointmentService = "localhost:8081";
String appointmentApiBase = "http://" + appointmentService + "/appointment-service/api";
String jwtToken = user.getToken();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Schedule – DentalCare</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    font-family: 'Inter', Arial, sans-serif;
    background: #f0f4f8;
    min-height: 100vh;
  }
  .navbar {
    background: linear-gradient(135deg, #1a8a7a, #0d5f73);
    padding: 0 32px;
    height: 64px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    box-shadow: 0 2px 12px rgba(0,0,0,0.15);
  }
  .navbar .brand { color: white; font-size: 20px; font-weight: 700; }
  .navbar .back-btn {
    color: rgba(255,255,255,0.85);
    text-decoration: none;
    font-size: 13px;
    font-weight: 500;
    display: flex;
    align-items: center;
    gap: 6px;
    transition: color 0.15s;
  }
  .navbar .back-btn:hover { color: white; }
  .main { max-width: 760px; margin: 40px auto; padding: 0 20px; }
  .page-title { margin-bottom: 28px; }
  .page-title h2 { font-size: 24px; font-weight: 700; color: #1a1a2e; }
  .page-title p  { color: #666; font-size: 14px; margin-top: 4px; }
  .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
  .panel {
    background: white;
    border-radius: 16px;
    padding: 28px;
    box-shadow: 0 2px 12px rgba(0,0,0,0.07);
  }
  .panel h3 { font-size: 16px; font-weight: 600; color: #1a1a2e; margin-bottom: 20px; padding-bottom: 12px; border-bottom: 1px solid #f0f0f0; }
  .field { margin-bottom: 18px; }
  .field label { display: block; font-size: 12px; font-weight: 600; color: #555; margin-bottom: 6px; letter-spacing: 0.4px; text-transform: uppercase; }
  .field input {
    width: 100%;
    padding: 11px 14px;
    border: 1.5px solid #e0e0e0;
    border-radius: 10px;
    font-size: 14px;
    font-family: inherit;
    outline: none;
    color: #333;
    transition: border-color 0.2s, box-shadow 0.2s;
  }
  .field input:focus {
    border-color: #1a8a7a;
    box-shadow: 0 0 0 3px rgba(26,138,122,0.12);
  }
  .btn-submit {
    width: 100%;
    padding: 12px;
    background: linear-gradient(135deg, #1a8a7a, #0d5f73);
    color: white;
    border: none;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    font-family: inherit;
    transition: opacity 0.2s, transform 0.1s;
    margin-top: 4px;
  }
  .btn-submit:hover { opacity: 0.9; transform: translateY(-1px); }
  .btn-load {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 9px 18px;
    background: #f0f4f8;
    color: #1a8a7a;
    border: 1.5px solid #1a8a7a;
    border-radius: 10px;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    font-family: inherit;
    transition: background 0.15s;
    margin-bottom: 16px;
  }
  .btn-load:hover { background: #e0f0ee; }
  .alert {
    padding: 10px 14px;
    border-radius: 8px;
    font-size: 13px;
    margin-bottom: 16px;
  }
  .alert.success { background: #e8f8f5; color: #1a8a7a; border: 1px solid #a8ddd6; }
  .alert.error   { background: #fff0f0; color: #cc3333; border: 1px solid #ffcccc; }
  .appt-item {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px 14px;
    background: #f8fafb;
    border-radius: 10px;
    margin-bottom: 8px;
    border-left: 3px solid #1a8a7a;
  }
  .appt-item .appt-icon { font-size: 20px; flex-shrink: 0; }
  .appt-item .appt-info { flex: 1; min-width: 0; }
  .appt-item .appt-info .date { font-weight: 600; font-size: 14px; color: #1a1a2e; }
  .appt-item .appt-info .service { font-size: 12px; color: #777; margin-top: 2px; }
  .status-msg { color: #999; font-size: 13px; padding: 4px 0; }
  @media (max-width: 600px) {
    .grid { grid-template-columns: 1fr; }
  }
</style>
</head>
<body>
<nav class="navbar">
  <div class="brand">🦷 DentalCare</div>
  <a class="back-btn" href="dashboard.jsp">← Back to Dashboard</a>
</nav>

<div class="main">
  <div class="page-title">
    <h2>Appointments</h2>
    <p>Book a new appointment or review your scheduled visits.</p>
  </div>

  <div class="grid">
    <div class="panel">
      <h3>📅 Book Appointment</h3>
      <% if ("1".equals(request.getParameter("success"))) { %>
      <div class="alert success">Appointment booked successfully!</div>
      <% } %>
      <% if ("1".equals(request.getParameter("error"))) { %>
      <div class="alert error">Booking failed. Please try again.</div>
      <% } %>
      <form action="ScheduleServlet" method="post">
        <div class="field">
          <label>Date</label>
          <input type="date" name="date" required/>
        </div>
        <div class="field">
          <label>Service</label>
          <select name="service" required style="width:100%;padding:11px 14px;border:1.5px solid #e0e0e0;border-radius:10px;font-size:14px;font-family:inherit;outline:none;color:#333;background:white;transition:border-color 0.2s,box-shadow 0.2s;" onfocus="this.style.borderColor='#1a8a7a';this.style.boxShadow='0 0 0 3px rgba(26,138,122,0.12)'" onblur="this.style.borderColor='#e0e0e0';this.style.boxShadow='none'">
            <option value="">-- Select a service --</option>
            <option value="Checkup - $50">Checkup - $50</option>
            <option value="Cleaning - $80">Cleaning - $80</option>
            <option value="X-Ray - $150">X-Ray - $150</option>
            <option value="Filling - $200">Filling - $200</option>
            <option value="Extraction - $250">Extraction - $250</option>
            <option value="Whitening - $300">Whitening - $300</option>
            <option value="Root Canal - $900">Root Canal - $900</option>
            <option value="Crown - $1,200">Crown - $1,200</option>
          </select>
        </div>
        <button type="submit" class="btn-submit">Book Appointment</button>
      </form>
    </div>

    <div class="panel">
      <h3>📋 My Appointments</h3>
      <button class="btn-load" onclick="loadAppointments()">↻ Load Appointments</button>
      <div id="apptResults"></div>
    </div>
  </div>
</div>

<script>
const JWT_TOKEN = "<%= jwtToken %>";

async function loadAppointments() {
  const div = document.getElementById("apptResults");
  div.innerHTML = '<p class="status-msg">Loading…</p>';
  try {
    const res = await fetch("/frontend/api/appointments", {
      headers: { "Authorization": "Bearer " + JWT_TOKEN }
    });
    if (!res.ok) { div.innerHTML = '<p class="status-msg">Could not load appointments.</p>'; return; }
    const appts = await res.json();
    if (appts.length === 0) { div.innerHTML = '<p class="status-msg">No appointments found.</p>'; return; }
    div.innerHTML = appts.map(a => {
      const svc = (a.service && a.service !== 'false' && a.service !== 'null') ? a.service : 'No service specified';
      const date = a.date || 'No date';
      return `<div class="appt-item">
        <div class="appt-icon">🗓️</div>
        <div class="appt-info">
          <div class="date">\${date}</div>
          <div class="service">\${svc}</div>
        </div>
      </div>`;
    }).join('');
  } catch(e) {
    div.innerHTML = '<p class="status-msg">Could not reach appointment service.</p>';
  }
}
</script>
</body>
</html>
