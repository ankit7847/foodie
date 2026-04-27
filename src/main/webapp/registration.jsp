<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register - Foodies</title>
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
            min-height: 100%;
        }

        body {
            background: var(--bg);
            color: var(--text);
            font-family: 'DM Sans', sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            padding: 2rem 0;
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

        /* Registration Container */
        .register-container {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 600px;
            padding: 2rem;
            opacity: 0;
            animation: fadeIn 0.6s ease 0.2s forwards;
        }

        /* Registration Card */
        .register-card {
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
        .register-card::before {
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
        .register-header h2 {
            font-family: 'Playfair Display', serif;
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--text);
            margin-bottom: 0.5rem;
            text-align: center;
        }

        .register-header h2 span {
            background: linear-gradient(90deg, var(--accent), var(--accent2));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .register-header p {
            color: var(--muted);
            font-size: 0.9rem;
            text-align: center;
            margin-bottom: 2rem;
            line-height: 1.5;
        }

        /* Form */
        .register-form {
            display: flex;
            flex-direction: column;
            gap: 1.2rem;
        }

        /* Form Grid */
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        /* Input Group */
        .input-group {
            position: relative;
        }

        .input-group.full-width {
            grid-column: 1 / -1;
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
        .input-group select,
        .input-group textarea {
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

        .input-group textarea {
            resize: vertical;
            min-height: 80px;
        }

        .input-group input::placeholder,
        .input-group textarea::placeholder {
            color: var(--muted);
            opacity: 0.6;
        }

        .input-group input:focus,
        .input-group select:focus,
        .input-group textarea:focus {
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

        /* Date input styling */
        .input-group input[type="date"] {
            color-scheme: dark;
        }

        .input-group input[type="date"]::-webkit-calendar-picker-indicator {
            filter: invert(0.6);
            cursor: pointer;
        }

        /* Button */
        .btn-register {
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

        .btn-register:hover {
            background: #f5b04a;
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(232, 160, 62, 0.35);
        }

        .btn-register:active {
            transform: translateY(0);
        }

        /* Links */
        .register-links {
            display: flex;
            flex-direction: column;
            gap: 0.8rem;
            margin-top: 1.5rem;
            text-align: center;
        }

        .register-links a {
            color: var(--muted);
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.2s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.4rem;
        }

        .register-links a:hover {
            color: var(--accent);
        }

        .register-links .back-link {
            font-size: 0.85rem;
        }

        .register-links .login-link {
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
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }

            .register-container {
                padding: 1rem;
            }

            .register-card {
                padding: 2rem 1.5rem;
            }

            .register-header h2 {
                font-size: 1.5rem;
            }

            .brand span {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>

<div class="register-container">
    <div class="register-card">
        
        <!-- Brand -->
        <div class="brand">
            <i class="fa fa-utensils"></i>
            <span>Foodies.</span>
        </div>

        <!-- Header -->
        <div class="register-header">
            <h2>Create <span>Account</span></h2>
            <p>Join Foodies and start ordering delicious meals today</p>
        </div>

        <!-- Registration Form -->
        <form action="RegistrationServlet" class="register-form" method="post">
            
            <!-- Row 1: Username & Email -->
            <div class="form-row">
                <div class="input-group">
                    <label for="username"><i class="fas fa-user"></i> Username</label>
                    <input 
                        type="text" 
                        name="username" 
                        id="username" 
                        placeholder="Choose a username" 
                        required
                        autocomplete="username"
                    >
                </div>

                <div class="input-group">
                    <label for="email"><i class="fas fa-envelope"></i> Email Address</label>
                    <input 
                        type="email" 
                        name="email" 
                        id="email" 
                        placeholder="your@email.com" 
                        required
                        autocomplete="email"
                    >
                </div>
            </div>

            <!-- Row 2: Password & Full Name -->
            <div class="form-row">
                <div class="input-group">
                    <label for="password"><i class="fas fa-lock"></i> Password</label>
                    <input 
                        type="password" 
                        name="password" 
                        id="password" 
                        placeholder="Create a password" 
                        required
                        autocomplete="new-password"
                    >
                </div>

                <div class="input-group">
                    <label for="fullname"><i class="fas fa-id-card"></i> Full Name</label>
                    <input 
                        type="text" 
                        name="fullname" 
                        id="fullname" 
                        placeholder="Enter your full name" 
                        required
                        autocomplete="name"
                    >
                </div>
            </div>

            <!-- Row 3: Phone & Date of Birth -->
            <div class="form-row">
                <div class="input-group">
                    <label for="phonenumber"><i class="fas fa-phone"></i> Phone Number</label>
                    <input 
                        type="text" 
                        name="phonenumber" 
                        id="phonenumber" 
                        placeholder="Enter phone number"
                        autocomplete="tel"
                    >
                </div>

                <div class="input-group">
                    <label for="dob"><i class="fas fa-calendar"></i> Date of Birth</label>
                    <input 
                        type="date" 
                        name="dob" 
                        id="dob"
                    >
                </div>
            </div>

            <!-- Gender -->
            <div class="input-group">
                <label for="gender"><i class="fas fa-venus-mars"></i> Gender</label>
                <select name="gender" id="gender">
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                    <option value="Other">Other</option>
                </select>
            </div>

            <!-- Address (Full Width) -->
            <div class="input-group full-width">
                <label for="address"><i class="fas fa-map-marker-alt"></i> Address</label>
                <textarea 
                    name="address" 
                    id="address" 
                    placeholder="Enter your delivery address"
                ></textarea>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="btn-register">
                Create Account <i class="fas fa-arrow-right"></i>
            </button>

        </form>

        <div class="divider"></div>

        <!-- Links -->
        <div class="register-links">
            <a href="welcome2.jsp" class="back-link">
                <i class="fas fa-arrow-left"></i> Back to Home
            </a>
            <a href="login.jsp" class="login-link">
                Already have an account? <span style="color: var(--accent);">Log In</span>
            </a>
        </div>

    </div>
</div>

</body>
</html>
