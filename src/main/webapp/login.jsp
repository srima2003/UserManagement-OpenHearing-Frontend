<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - User System</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f0f2f5; margin: 0; }
        .login-box { background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); width: 320px; text-align: center; }
        h2 { margin-bottom: 20px; color: #333; }
        input { width: 100%; padding: 12px; margin: 10px 0; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; font-size: 14px; }
        button { width: 100%; padding: 12px; background-color: #2c3e9e; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; font-weight: bold; margin-top: 10px; }
        button:hover { background-color: #1a2a7e; }
        .error { color: #dc3545; font-size: 13px; display: none; margin-bottom: 10px; }
        .footer { margin-top: 20px; font-size: 12px; color: #888; }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>Sign In</h2>
        <div id="errorMsg" class="error">Invalid Credentials</div>
        
        <form onsubmit="return false;">
            <input type="email" id="email" value="admin@test.com" placeholder="Email Address" required>
            <input type="password" id="password" value="admin123" placeholder="Password" required>
            <button onclick="handleLogin()">Login</button>
        </form>
        <div class="footer">User Management System v1.0</div>
    </div>

    <script>
        async function handleLogin() {
            const email = document.getElementById("email").value;
            const password = document.getElementById("password").value;
            const errorMsg = document.getElementById("errorMsg");

            // Clear previous errors
            errorMsg.style.display = "none";

            try {
                // Call Backend API on port 8085
                const response = await fetch('http://localhost:8085/api/auth/login', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ email: email, password: password })
                });

                if (response.ok) {
                    const data = await response.json();
                    localStorage.setItem("userToken", data.token);
                    // Redirect to dashboard.jsp on success
                    window.location.href = "dashboard.jsp"; 
                } else {
                    errorMsg.innerText = "Invalid Username or Password";
                    errorMsg.style.display = "block";
                }
            } catch (error) {
                console.error("Error:", error);
                errorMsg.innerText = "Cannot connect to Backend (Is Port 8085 running?)";
                errorMsg.style.display = "block";
            }
        }
    </script>
</body>
</html>