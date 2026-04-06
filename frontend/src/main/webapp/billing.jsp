<%@ page import="java.util.List" %>
<%@ page import="Helper.BillingInfo" %>
<%@ page import="Helper.UserInfo" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
UserInfo user = (UserInfo) session.getAttribute("user");
if (user == null) { response.sendRedirect("login.jsp"); return; }
List<BillingInfo> bills = (List<BillingInfo>) request.getAttribute("bills");
double total = 0;
if (bills != null) for (BillingInfo b : bills) total += b.getAmount();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Billing – DentalCare</title>
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
    transition: color 0.15s;
  }
  .navbar .back-btn:hover { color: white; }
  .main { max-width: 760px; margin: 40px auto; padding: 0 20px; }
  .page-title { margin-bottom: 28px; }
  .page-title h2 { font-size: 24px; font-weight: 700; color: #1a1a2e; }
  .page-title p  { color: #666; font-size: 14px; margin-top: 4px; }
  /* Summary card */
  .summary-cards { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 24px; }
  .summary-card {
    background: white;
    border-radius: 14px;
    padding: 20px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.07);
    text-align: center;
  }
  .summary-card .s-label { font-size: 12px; color: #888; font-weight: 500; text-transform: uppercase; letter-spacing: 0.4px; margin-bottom: 8px; }
  .summary-card .s-value { font-size: 26px; font-weight: 700; color: #1a1a2e; }
  .summary-card.total .s-value { color: #1a8a7a; }
  /* Table panel */
  .panel {
    background: white;
    border-radius: 16px;
    padding: 28px;
    box-shadow: 0 2px 12px rgba(0,0,0,0.07);
  }
  .panel h3 { font-size: 16px; font-weight: 600; color: #1a1a2e; margin-bottom: 20px; }
  table { width: 100%; border-collapse: collapse; }
  thead tr { border-bottom: 2px solid #f0f0f0; }
  thead th {
    text-align: left;
    font-size: 11px;
    font-weight: 600;
    color: #999;
    text-transform: uppercase;
    letter-spacing: 0.6px;
    padding: 0 16px 12px;
  }
  tbody tr {
    border-bottom: 1px solid #f8f8f8;
    transition: background 0.12s;
  }
  tbody tr:hover { background: #f8fafb; }
  tbody td {
    padding: 14px 16px;
    font-size: 14px;
    color: #333;
  }
  tbody td:first-child { color: #999; font-size: 13px; }
  .amount-cell { font-weight: 600; color: #1a8a7a; }
  .badge {
    display: inline-block;
    background: #e8f8f5;
    color: #1a8a7a;
    padding: 3px 10px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 500;
  }
  .empty-state {
    text-align: center;
    padding: 48px 20px;
    color: #aaa;
  }
  .empty-state .empty-icon { font-size: 48px; margin-bottom: 12px; }
  .empty-state p { font-size: 14px; }
  @media (max-width: 500px) {
    .summary-cards { grid-template-columns: 1fr; }
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
    <h2>Billing</h2>
    <p>Your invoice history for <%= user.getUsername() %></p>
  </div>

  <div class="summary-cards">
    <div class="summary-card">
      <div class="s-label">Total Records</div>
      <div class="s-value"><%= bills != null ? bills.size() : 0 %></div>
    </div>
    <div class="summary-card total">
      <div class="s-label">Total Amount</div>
      <div class="s-value">$<%= String.format("%.2f", total) %></div>
    </div>
    <div class="summary-card">
      <div class="s-label">Status</div>
      <div class="s-value" style="font-size:20px;"><span class="badge">Active</span></div>
    </div>
  </div>

  <div class="panel">
    <h3>Invoice History</h3>
    <% if (bills != null && !bills.isEmpty()) { %>
    <table>
      <thead>
        <tr>
          <th>Bill ID</th>
          <th>Appointment ID</th>
          <th>Amount</th>
        </tr>
      </thead>
      <tbody>
        <% for (BillingInfo b : bills) { %>
        <tr>
          <td>#<%= b.getBillingId() %></td>
          <td>APT-<%= b.getAppointmentId() %></td>
          <td class="amount-cell">$<%= String.format("%.2f", b.getAmount()) %></td>
        </tr>
        <% } %>
      </tbody>
    </table>
    <% } else { %>
    <div class="empty-state">
      <div class="empty-icon">🧾</div>
      <p>No billing records found.</p>
    </div>
    <% } %>
  </div>
</div>
</body>
</html>
