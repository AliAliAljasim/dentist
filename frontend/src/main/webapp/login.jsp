<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Dental System – Login</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    font-family: 'Inter', Arial, sans-serif;
    background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
  }
  .wrapper {
    display: flex;
    width: 820px;
    max-width: 100%;
    background: white;
    border-radius: 20px;
    overflow: hidden;
    box-shadow: 0 25px 60px rgba(0,0,0,0.4);
  }
  .branding {
    flex: 1;
    background: linear-gradient(160deg, #1a8a7a, #0d5f73);
    padding: 50px 40px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    color: white;
  }
  .branding .tooth-icon {
    font-size: 56px;
    margin-bottom: 20px;
  }
  .branding h1 { font-size: 28px; font-weight: 700; margin-bottom: 12px; }
  .branding p  { font-size: 15px; opacity: 0.85; line-height: 1.6; }
  .branding .features { margin-top: 32px; }
  .branding .features li {
    list-style: none;
    padding: 6px 0;
    font-size: 14px;
    opacity: 0.9;
    display: flex;
    align-items: center;
    gap: 8px;
  }
  .branding .features li::before { content: "✓"; font-weight: 700; color: #7fffd4; }
  .form-side {
    flex: 1;
    padding: 50px 40px;
    display: flex;
    flex-direction: column;
    justify-content: center;
  }
  .form-side h2 { font-size: 24px; font-weight: 700; color: #1a1a2e; margin-bottom: 6px; }
  .form-side .subtitle { color: #888; font-size: 14px; margin-bottom: 32px; }
  .field { margin-bottom: 20px; }
  .field label { display: block; font-size: 13px; font-weight: 600; color: #444; margin-bottom: 6px; letter-spacing: 0.4px; }
  .field input {
    width: 100%;
    padding: 12px 16px;
    border: 1.5px solid #e0e0e0;
    border-radius: 10px;
    font-size: 14px;
    font-family: inherit;
    transition: border-color 0.2s, box-shadow 0.2s;
    outline: none;
    color: #333;
  }
  .field input:focus {
    border-color: #1a8a7a;
    box-shadow: 0 0 0 3px rgba(26,138,122,0.12);
  }
  .btn-login {
    width: 100%;
    padding: 13px;
    background: linear-gradient(135deg, #1a8a7a, #0d5f73);
    color: white;
    border: none;
    border-radius: 10px;
    font-size: 15px;
    font-weight: 600;
    cursor: pointer;
    letter-spacing: 0.3px;
    transition: opacity 0.2s, transform 0.1s;
    margin-top: 4px;
  }
  .btn-login:hover { opacity: 0.92; transform: translateY(-1px); }
  .btn-login:active { transform: translateY(0); }
  .error-msg {
    background: #fff0f0;
    border: 1px solid #ffcccc;
    color: #cc3333;
    padding: 10px 14px;
    border-radius: 8px;
    font-size: 13px;
    margin-top: 16px;
    text-align: center;
  }
  @media (max-width: 600px) {
    .branding { display: none; }
    .form-side { padding: 40px 28px; }
  }
</style>
</head>
<body>
<div class="wrapper">
  <div class="branding">
    <div class="tooth-icon">🦷</div>
    <h1>DentalCare System</h1>
    <p>Your complete dental practice management platform. Schedule appointments, search dentists, and track billing — all in one place.</p>
    <ul class="features">
      <li>Book & manage appointments</li>
      <li>Search dentist specialists</li>
      <li>View billing & invoices</li>
      <li>Secure JWT authentication</li>
    </ul>
  </div>
  <div class="form-side">
    <h2>Welcome back</h2>
    <p class="subtitle">Sign in to your account to continue</p>
    <form action="LoginServlet" method="post">
      <div class="field">
        <label>USERNAME</label>
        <input type="text" name="username" placeholder="Enter your username" required/>
      </div>
      <div class="field">
        <label>PASSWORD</label>
        <input type="password" name="password" placeholder="Enter your password" required/>
      </div>
      <button type="submit" class="btn-login">Sign In</button>
    </form>
    <% if (request.getParameter("error") != null) { %>
    <div class="error-msg">Invalid username or password. Please try again.</div>
    <% } %>
  </div>
</div>
</body>
</html>
