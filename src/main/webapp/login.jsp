<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Foodies</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;0,900;1,400&family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --bg:      #0f0e0c;
            --surface: #1a1815;
            --card:    #211f1c;
            --border:  #2e2b27;
            --accent:  #e8a03e;
            --accent2: #c45c2e;
            --text:    #f0ebe3;
            --muted:   #8a8278;
        }

        * { 
            margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
        }

        html, body {
            height: 100%;
            overflow: hidden;
        }

        body {
            background: var(--bg);
            color: var(--text);
            font-family: 'DM Sans', sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        /* Noise overlay */
        body::before {
            content: '';
            position: fixed;
            inset: 0;
            background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.035'/%3E%3C/svg%3E");
            pointer-events: none;
            z-index: 9999;
            opacity: 0.4;
        }

        /* Background gradient */
        body::after {
            content: '';
            position: fixed;
            inset: 0;
            background: radial-gradient(ellipse 80% 70% at 50% 50%, rgba(232,160,62,.08), transparent),
                        radial-gradient(ellipse 60% 50% at 20% 80%, rgba(196,92,46,.05), transparent);
            pointer-events: none;
            z-index: 0;
        }

        /* Login Container */
        .login-container {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 440px;
            padding: 2rem;
            opacity: 0;
            animation: fadeIn 0.6s ease 0.2s forwards;
        }

        /* Login Card */
        .login-card {
            background: rgba(26, 24, 21, 0.85);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(232, 160, 62, 0.15);
            border-radius: 20px;
            padding: 3rem 2.5rem;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.4);
            position: relative;
            overflow: hidden;
        }

        /* Decorative element */
        .login-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--accent), var(--accent2));
        }

        /* Brand */
        .brand {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.7rem;
            margin-bottom: 2rem;
        }

        .brand i {
            color: var(--accent);
            font-size: 1.5rem;
        }

        .brand span {
            font-family: 'Playfair Display', serif;
            font-size: 1.8rem;
            color: var(--accent);
            letter-spacing: 0.5px;
            font-weight: 700;
        }

        /* Heading */
        .login-header h4 {
            font-family: 'Playfair Display', serif;
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--text);
            margin-bottom: 0.5rem;
            text-align: center;
        }

        .login-header h4 span {
            background: linear-gradient(90deg, var(--accent), var(--accent2));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .login-header p {
            color: var(--muted);
            font-size: 0.9rem;
            text-align: center;
            margin-bottom: 2rem;
            line-height: 1.5;
        }

        /* Form */
        .login-form {
            display: flex;
            flex-direction: column;
            gap: 1.2rem;
        }

        /* Input Group */
        .input-group {
            position: relative;
        }

        .input-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 500;
            color: var(--muted);
            margin-bottom: 0.5rem;
            letter-spacing: 0.3px;
        }

        .input-group input,
        .input-group select {
            width: 100%;
            padding: 0.9rem 1rem;
            background: rgba(33, 31, 28, 0.6);
            border: 1px solid var(--border);
            border-radius: 10px;
            color: var(--text);
            font-family: 'DM Sans', sans-serif;
            font-size: 0.95rem;
            transition: border-color 0.2s, background 0.2s;
            outline: none;
        }

        .input-group input::placeholder {
            color: var(--muted);
            opacity: 0.6;
        }

        .input-group input:focus,
        .input-group select:focus {
            border-color: var(--accent);
            background: rgba(33, 31, 28, 0.8);
        }

        .input-group select {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%238a8278' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 1rem center;
            padding-right: 2.5rem;
        }

        .input-group select option {
            background: var(--card);
            color: var(--text);
        }

        /* Checkbox */
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.85rem;
            color: var(--muted);
            margin-top: -0.5rem;
        }

        .checkbox-group input[type="checkbox"] {
            width: auto;
            cursor: pointer;
            accent-color: var(--accent);
        }

        /* Messages */
        .message {
            padding: 0.8rem 1rem;
            border-radius: 8px;
            font-size: 0.85rem;
            text-align: center;
            margin-bottom: 0.5rem;
        }

        .message.error {
            background: rgba(220, 38, 38, 0.15);
            border: 1px solid rgba(220, 38, 38, 0.3);
            color: #fca5a5;
        }

        .message.success {
            background: rgba(34, 197, 94, 0.15);
            border: 1px solid rgba(34, 197, 94, 0.3);
            color: #86efac;
        }

        /* Button */
        .btn-login {
            width: 100%;
            padding: 1rem;
            background: var(--accent);
            color: #000;
            border: none;
            border-radius: 10px;
            font-family: 'DM Sans', sans-serif;
            font-size: 1rem;
            font-weight: 700;
            letter-spacing: 0.3px;
            cursor: pointer;
            transition: background 0.2s, transform 0.15s, box-shadow 0.2s;
            margin-top: 0.5rem;
        }

        .btn-login:hover {
            background: #f5b04a;
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(232, 160, 62, 0.35);
        }

        .btn-login:active {
            transform: translateY(0);
        }

        /* Links */
        .login-links {
            display: flex;
            flex-direction: column;
            gap: 0.8rem;
            margin-top: 1.5rem;
            text-align: center;
        }

        .login-links a {
            color: var(--muted);
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.2s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.4rem;
        }

        .login-links a:hover {
            color: var(--accent);
        }

        .login-links .back-link {
            font-size: 0.85rem;
        }

        .login-links .register-link {
            font-weight: 500;
        }

        /* Divider */
        .divider {
            height: 1px;
            background: var(--border);
            margin: 1.5rem 0;
        }

        /* Animations */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Responsive */
        @media (max-width: 600px) {
            .login-container {
                padding: 1rem;
            }

            .login-card {
                padding: 2rem 1.5rem;
            }

            .login-header h4 {
                font-size: 1.5rem;
            }

            .brand span {
                font-size: 1.5rem;
            }
        }

        @media (max-height: 700px) {
            html, body {
                overflow: auto;
            }

            .login-container {
                padding: 2rem 1rem;
            }

            .login-card {
                margin: 2rem 0;
            }
        }
    </style>
</head>
<body>

<div class="login-container">
    <div class="login-card">
        
        <!-- Brand -->
        <div class="brand">
            <i class="fa fa-utensils"></i>
            <span>Foodies.</span>
        </div>

        <!-- Header -->
        <div class="login-header">
            <h4>Welcome <span>Back</span></h4>
            <p>Login to explore restaurants and order your favorite food.</p>
        </div>

        <!-- Error Messages -->
        <% if(request.getParameter("error") != null) { %>
            <div class="message error">
                <% if(request.getParameter("error").equals("invalid_credentials")) { %>
                    <i class="fas fa-exclamation-circle"></i> Invalid email or password!
                <% } else if(request.getParameter("error").equals("wrong_usertype")) { %>
                    <i class="fas fa-exclamation-circle"></i> Wrong role selected!
                <% } else { %>
                    <i class="fas fa-exclamation-circle"></i> Database error. Please try again.
                <% } %>
            </div>
        <% } %>

        <!-- Success Message -->
        <% if(request.getParameter("msg") != null) { %>
            <div class="message success">
                <i class="fas fa-check-circle"></i> Login successful!
            </div>
        <% } %>

        <!-- Login Form -->
        <form action="login" class="login-form" method="post">
            
            <!-- Email -->
            <div class="input-group">
                <label for="email"><i class="fas fa-envelope"></i> Email Address</label>
                <input 
                    type="email" 
                    name="email" 
                    id="email" 
                    placeholder="Enter your email" 
                    required
                    autocomplete="email"
                >
            </div>

            <!-- Password -->
            <div class="input-group">
                <label for="password"><i class="fas fa-lock"></i> Password</label>
                <input 
                    type="password" 
                    name="password" 
                    id="password" 
                    placeholder="Enter your password" 
                    required
                    autocomplete="current-password"
                >
            </div>

            <!-- Show Password -->
            <div class="checkbox-group">
                <input type="checkbox" id="showPassword" onclick="togglePassword()">
                <label for="showPassword" style="margin: 0; cursor: pointer;">Show Password</label>
            </div>

            <!-- User Type -->
            <div class="input-group">
                <label for="usertype"><i class="fas fa-user-shield"></i> Login As</label>
                <select name="usertype" id="usertype" required>
                    <option value="" disabled selected>Select your role</option>
                    <option value="user">User</option>
                    <option value="admin">Admin</option>
                </select>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="btn-login">
                Log In <i class="fas fa-arrow-right"></i>
            </button>

        </form>

        <div class="divider"></div>

        <!-- Links -->
        <div class="login-links">
            <a href="welcome2.jsp" class="back-link">
                <i class="fas fa-arrow-left"></i> Back to Home
            </a>
            <a href="registration.jsp" class="register-link">
                Don't have an account? <span style="color: var(--accent);">Sign Up</span>
            </a>
        </div>

    </div>
</div>

<!-- Script -->
<script>
function togglePassword() {
    const pwd = document.getElementById("password");
    pwd.type = (pwd.type === "password") ? "text" : "password";
}
</script>

</body>
</html>
