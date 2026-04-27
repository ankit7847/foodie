<%@page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page import="java.sql.*,com.db.ConnectionProvider"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - Foodies</title>
    <link rel="icon" href="./Images/Restaurants/download.png" type="image/icon type">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg:        #0f0e0c;
            --surface:   #1a1815;
            --card:      #211f1c;
            --border:    #2e2b27;
            --accent:    #e8a03e;
            --accent2:   #c45c2e;
            --text:      #f0ebe3;
            --muted:     #8a8278;
            --tag-bg:    #2a2520;
            --red:       #d94f38;
            --green:     #5a9a6f;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        html { scroll-behavior: smooth; }

        body {
            background: var(--bg);
            color: var(--text);
            font-family: 'DM Sans', sans-serif;
            overflow-x: hidden;
        }

        /* ── NOISE OVERLAY ── */
        body::before {
            content: '';
            position: fixed; inset: 0;
            background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.035'/%3E%3C/svg%3E");
            pointer-events: none; z-index: 9999; opacity: .4;
        }

        /* ── HEADER ── */
        header {
            position: sticky; top: 0; z-index: 100;
            background: rgba(15,14,12,.92);
            backdrop-filter: blur(18px);
            border-bottom: 1px solid var(--border);
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 4rem; height: 68px;
        }

        .logo { display: flex; align-items: center; gap: .6rem; text-decoration: none; }
        .logo img { height: 36px; }
        .logo span {
            font-family: 'Playfair Display', serif;
            font-size: 1.4rem; color: var(--accent);
            letter-spacing: .5px;
        }

        .navbar { display: flex; gap: 2rem; }
        .navbar a {
            color: var(--muted); text-decoration: none;
            font-size: .85rem; font-weight: 500; letter-spacing: .5px;
            text-transform: uppercase; transition: color .2s;
            position: relative;
        }
        .navbar a::after {
            content: ''; position: absolute; left: 0; bottom: -4px;
            width: 0; height: 1px; background: var(--accent);
            transition: width .3s;
        }
        .navbar a:hover, .navbar a.active { color: var(--accent); }
        .navbar a:hover::after, .navbar a.active::after { width: 100%; }

        .header-icons { display: flex; align-items: center; gap: 1.2rem; }
        .header-icons a { color: var(--muted); font-size: 1rem; transition: color .2s; }
        .header-icons a:hover { color: var(--accent); }

        /* ── HERO ── */
        .hero {
            position: relative; overflow: hidden;
            min-height: 360px;
            display: flex; align-items: center;
            padding: 5rem 4rem;
        }

        .hero-bg {
            position: absolute; inset: 0;
            background: linear-gradient(135deg, #1c1108 0%, #2a1a08 40%, #0f1c14 100%);
        }

        .hero-bg::after {
            content: '';
            position: absolute; inset: 0;
            background: radial-gradient(ellipse 60% 80% at 70% 50%, rgba(232,160,62,.12), transparent),
                        radial-gradient(ellipse 40% 60% at 20% 80%, rgba(196,92,46,.08), transparent);
        }

        .hero-deco {
            position: absolute; right: -80px; top: -80px;
            width: 600px; height: 600px;
            border-radius: 50%;
            border: 1px solid rgba(232,160,62,.07);
            pointer-events: none;
        }
        .hero-deco::before {
            content: ''; position: absolute; inset: 40px;
            border-radius: 50%; border: 1px solid rgba(232,160,62,.05);
        }

        .hero-content { position: relative; z-index: 1; max-width: 580px; }

        .hero-eyebrow {
            display: inline-flex; align-items: center; gap: .5rem;
            font-size: .72rem; letter-spacing: 2px; text-transform: uppercase;
            color: var(--accent); margin-bottom: 1.2rem;
            background: rgba(232,160,62,.1); border: 1px solid rgba(232,160,62,.2);
            padding: .3rem .8rem; border-radius: 100px;
        }

        .hero h1 {
            font-family: 'Playfair Display', serif;
            font-size: clamp(2.4rem, 5vw, 3.8rem);
            line-height: 1.1; font-weight: 900;
            margin-bottom: 1rem;
        }

        .hero h1 em {
            font-style: normal;
            background: linear-gradient(90deg, var(--accent), var(--accent2));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .hero p {
            color: var(--muted); font-size: 1rem;
            line-height: 1.7; max-width: 420px;
        }

        /* ── SCROLL ANIMATIONS ── */
        .reveal {
            opacity: 0; transform: translateY(28px);
            transition: opacity .55s ease, transform .55s ease;
        }
        .reveal.visible { opacity: 1; transform: translateY(0); }

        /* ── CONTACT LAYOUT ── */
        .contact-section {
            padding: 5rem 4rem;
            display: grid;
            grid-template-columns: 1fr 1.4fr;
            gap: 4rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        /* ── INFO COLUMN ── */
        .contact-info { display: flex; flex-direction: column; gap: 2rem; }

        .section-eyebrow {
            font-size: .7rem; letter-spacing: 2.5px; text-transform: uppercase;
            color: var(--accent); font-weight: 600; margin-bottom: .4rem;
        }

        .contact-info h2 {
            font-family: 'Playfair Display', serif;
            font-size: clamp(1.8rem, 3vw, 2.4rem);
            font-weight: 700; line-height: 1.2;
            margin-bottom: .8rem;
        }

        .contact-info > p {
            color: var(--muted); font-size: .9rem;
            line-height: 1.75; margin-bottom: .5rem;
        }

        /* Info cards */
        .info-cards { display: flex; flex-direction: column; gap: 1rem; }

        .info-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 1.1rem 1.3rem;
            display: flex; align-items: flex-start; gap: 1rem;
            transition: border-color .25s, box-shadow .25s;
        }
        .info-card:hover {
            border-color: rgba(232,160,62,.35);
            box-shadow: 0 8px 30px rgba(0,0,0,.4);
        }

        .info-icon {
            width: 40px; height: 40px; border-radius: 10px;
            background: rgba(232,160,62,.12);
            border: 1px solid rgba(232,160,62,.2);
            display: flex; align-items: center; justify-content: center;
            color: var(--accent); font-size: .9rem; flex-shrink: 0;
        }

        .info-text h4 {
            font-size: .78rem; font-weight: 600;
            text-transform: uppercase; letter-spacing: 1px;
            color: var(--accent); margin-bottom: .25rem;
        }

        .info-text p, .info-text a {
            font-size: .85rem; color: var(--muted);
            line-height: 1.5; text-decoration: none;
            transition: color .2s;
        }
        .info-text a:hover { color: var(--text); }

        /* Social row */
        .social-row { display: flex; gap: .7rem; flex-wrap: wrap; margin-top: .5rem; }
        .social-pill {
            display: flex; align-items: center; gap: .5rem;
            padding: .45rem 1rem; border-radius: 100px;
            border: 1px solid var(--border);
            color: var(--muted); font-size: .78rem; text-decoration: none;
            transition: all .2s;
        }
        .social-pill:hover {
            border-color: var(--accent); color: var(--accent);
            background: rgba(232,160,62,.07);
        }

        /* ── FORM COLUMN ── */
        .contact-form-wrap {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 2.5rem 2.2rem;
        }

        .form-header { margin-bottom: 2rem; }
        .form-header h3 {
            font-family: 'Playfair Display', serif;
            font-size: 1.5rem; font-weight: 700;
            margin-bottom: .4rem;
        }
        .form-header p { font-size: .82rem; color: var(--muted); }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.1rem;
        }

        .form-group { display: flex; flex-direction: column; gap: .45rem; }
        .form-group.full { grid-column: 1 / -1; }

        .form-group label {
            font-size: .72rem; font-weight: 600;
            text-transform: uppercase; letter-spacing: 1px;
            color: var(--muted);
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 10px;
            color: var(--text);
            font-family: 'DM Sans', sans-serif;
            font-size: .88rem;
            padding: .75rem 1rem;
            outline: none;
            transition: border-color .2s, box-shadow .2s;
            resize: none;
        }
        .form-group input::placeholder,
        .form-group textarea::placeholder { color: #4a4540; }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(232,160,62,.1);
        }

        .form-group select option { background: var(--surface); }

        .form-group textarea { min-height: 130px; }

        /* Star rating */
        .rating-row {
            display: flex; gap: .3rem; margin-top: .1rem;
        }
        .rating-row input { display: none; }
        .rating-row label {
            font-size: 1.4rem; cursor: pointer;
            color: var(--border); transition: color .15s;
            text-transform: none; letter-spacing: 0;
        }
        .rating-row input:checked ~ label,
        .rating-row label:hover,
        .rating-row label:hover ~ label { color: var(--accent); }
        /* Reverse trick for CSS-only stars */
        .rating-row { flex-direction: row-reverse; justify-content: flex-end; }
        .rating-row label:hover,
        .rating-row label:hover ~ label,
        .rating-row input:checked ~ label { color: var(--accent); }

        /* Submit button */
        .submit-btn {
            width: 100%; margin-top: 1.5rem;
            background: var(--accent); color: #000;
            border: none; border-radius: 10px;
            padding: .9rem 1.5rem;
            font-family: 'DM Sans', sans-serif;
            font-size: .9rem; font-weight: 700;
            letter-spacing: .4px; cursor: pointer;
            display: flex; align-items: center; justify-content: center; gap: .6rem;
            transition: background .2s, transform .15s, box-shadow .2s;
        }
        .submit-btn:hover {
            background: #f5b04a;
            transform: translateY(-2px);
            box-shadow: 0 8px 28px rgba(232,160,62,.35);
        }
        .submit-btn:active { transform: translateY(0); }

        /* ── FAQ SECTION ── */
        .faq-section {
            padding: 0 4rem 5rem;
            max-width: 1200px; margin: 0 auto;
        }

        .faq-section .section-header-inner {
            display: flex; flex-direction: column; gap: .4rem;
            margin-bottom: 2rem;
        }

        .faq-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
            gap: 1.1rem;
        }

        .faq-item {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 14px; overflow: hidden;
            transition: border-color .25s;
        }
        .faq-item:hover { border-color: rgba(232,160,62,.25); }

        .faq-question {
            width: 100%; background: none; border: none; color: var(--text);
            font-family: 'DM Sans', sans-serif;
            font-size: .9rem; font-weight: 600;
            text-align: left; cursor: pointer;
            display: flex; align-items: center; justify-content: space-between;
            padding: 1.1rem 1.3rem; gap: 1rem;
            transition: color .2s;
        }
        .faq-question:hover { color: var(--accent); }
        .faq-question i { font-size: .75rem; color: var(--muted); transition: transform .3s; flex-shrink: 0; }
        .faq-item.open .faq-question i { transform: rotate(180deg); color: var(--accent); }

        .faq-answer {
            max-height: 0; overflow: hidden;
            transition: max-height .35s ease, padding .3s;
        }
        .faq-item.open .faq-answer { max-height: 200px; }

        .faq-answer p {
            color: var(--muted); font-size: .83rem;
            line-height: 1.7;
            padding: 0 1.3rem 1.2rem;
        }

        /* ── MAP STRIP ── */
        .map-strip {
            margin: 0 4rem 5rem;
            border-radius: 18px; overflow: hidden;
            border: 1px solid var(--border);
            height: 320px;
            position: relative;
        }

        .map-strip iframe {
            width: 100%; height: 100%; border: none;
            filter: grayscale(0.6) invert(0.85) hue-rotate(180deg) brightness(0.85) contrast(1.1);
        }

        .map-label {
            position: absolute; bottom: 1.2rem; left: 1.5rem;
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 10px; padding: .7rem 1rem;
            display: flex; align-items: center; gap: .7rem;
            font-size: .8rem; font-weight: 600;
            pointer-events: none;
        }
        .map-label i { color: var(--accent); }

        /* ── DIVIDER ── */
        .divider { margin: 1rem 4rem; border: none; border-top: 1px solid var(--border); }

        /* ── FOOTER ── */
        footer {
            background: var(--surface);
            border-top: 1px solid var(--border);
            padding: 3.5rem 4rem 2rem;
        }

        .footer-grid {
            display: grid;
            grid-template-columns: 1.4fr repeat(4, 1fr);
            gap: 2.5rem; padding-bottom: 2.5rem;
            border-bottom: 1px solid var(--border);
        }

        .footer-brand p {
            font-size: .82rem; color: var(--muted);
            line-height: 1.7; margin-top: .7rem; max-width: 220px;
        }

        .footer-logo { display: flex; align-items: center; gap: .5rem; }
        .footer-logo span { font-family: 'Playfair Display', serif; font-size: 1.25rem; color: var(--accent); }

        .footer-col h5 {
            font-size: .7rem; letter-spacing: 2px; text-transform: uppercase;
            color: var(--accent); margin-bottom: 1rem; font-weight: 600;
        }
        .footer-col ul { list-style: none; }
        .footer-col ul li { margin-bottom: .55rem; }
        .footer-col ul li a {
            color: var(--muted); text-decoration: none; font-size: .82rem; transition: color .2s;
        }
        .footer-col ul li a:hover { color: var(--text); }

        .social-links { display: flex; gap: .8rem; margin-top: .5rem; flex-wrap: wrap; }
        .social-links a {
            width: 34px; height: 34px; border-radius: 8px;
            border: 1px solid var(--border);
            display: flex; align-items: center; justify-content: center;
            color: var(--muted); font-size: .82rem; text-decoration: none;
            transition: all .2s;
        }
        .social-links a:hover { border-color: var(--accent); color: var(--accent); background: rgba(232,160,62,.08); }

        .footer-bottom {
            padding-top: 1.5rem;
            display: flex; align-items: center; justify-content: space-between;
            font-size: .75rem; color: var(--muted);
        }

        /* ── RESPONSIVE ── */
        @media (max-width: 900px) {
            header { padding: 0 1.5rem; }
            .navbar { display: none; }
            .hero { padding: 3.5rem 1.5rem; }
            .contact-section { grid-template-columns: 1fr; padding: 3rem 1.5rem; gap: 2.5rem; }
            .faq-section, .map-strip, .divider { padding-left: 1.5rem; padding-right: 1.5rem; margin-left: 1.5rem; margin-right: 1.5rem; }
            .faq-section { padding-left: 0; padding-right: 0; }
            .map-strip { margin: 0 1.5rem 3rem; }
            .footer-grid { grid-template-columns: 1fr 1fr; }
            footer { padding: 2.5rem 1.5rem 1.5rem; }
        }

        @media (max-width: 600px) {
            .form-grid { grid-template-columns: 1fr; }
            .faq-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>

<%
    String user_id = (String) session.getAttribute("user_id");
%>

<body>

<!-- ── HEADER ── -->
<header>
    <a href="./index.jsp" class="logo">
        <i class="fa fa-utensils" style="color:var(--accent)"></i>
        <span>Foodies.</span>
    </a>
    <nav class="navbar">
        <a href="./index.jsp">Home</a>
        <a href="./food_types.jsp">Food Types</a>
        <a class="active" href="./contact.jsp">Contact Us</a>
        <a href="cart.jsp?id=<%= user_id %>">My Cart</a>
        <a href="orders.jsp?id=<%= user_id %>">Orders</a>
    </nav>
    <div class="header-icons">
        <a href="#"><i class="fas fa-search"></i></a>
        <a href="#"><i class="fas fa-heart"></i></a>
        <a href="login.jsp"><i class="fas fa-sign-in-alt"></i></a>
    </div>
</header>

<!-- ── HERO ── -->
<section class="hero">
    <div class="hero-bg"></div>
    <div class="hero-deco"></div>
    <div class="hero-content reveal">
        <div class="hero-eyebrow"><i class="fas fa-envelope-open-text"></i> We'd love to hear from you</div>
        <h1>Get in Touch<br><em>With Foodies.</em></h1>
        <p>Questions about your order, feedback on a meal, or just want to say hi — our team is always ready to help you out.</p>
    </div>
</section>

<!-- ── MAIN CONTACT SECTION ── -->
<section class="contact-section">

    <!-- LEFT: Info -->
    <div class="contact-info reveal">
        <div>
            <div class="section-eyebrow"><i class="fas fa-location-dot"></i> &nbsp;Reach us</div>
            <h2>We're Here<br>For You, Always</h2>
            <p>Whether it's a late-night craving query or a complaint about cold noodles, we take every message seriously. Reach us through any channel below.</p>
        </div>

        <div class="info-cards">
            <div class="info-card">
                <div class="info-icon"><i class="fas fa-location-dot"></i></div>
                <div class="info-text">
                    <h4>Our Address</h4>
                    <p>Plot No. 12, Saheed Nagar<br>Bhubaneswar, Odisha – 751007</p>
                </div>
            </div>
            <div class="info-card">
                <div class="info-icon"><i class="fas fa-phone-flip"></i></div>
                <div class="info-text">
                    <h4>Phone & WhatsApp</h4>
                    <a href="tel:+919876543210">+91 98765 43210</a><br>
                    <a href="tel:+919876543211">+91 98765 43211</a>
                </div>
            </div>
            <div class="info-card">
                <div class="info-icon"><i class="fas fa-envelope"></i></div>
                <div class="info-text">
                    <h4>Email Us</h4>
                    <a href="mailto:hello@foodies.in">hello@foodies.in</a><br>
                    <a href="mailto:support@foodies.in">support@foodies.in</a>
                </div>
            </div>
            <div class="info-card">
                <div class="info-icon"><i class="fas fa-clock"></i></div>
                <div class="info-text">
                    <h4>Working Hours</h4>
                    <p>Mon – Fri: 9:00 AM – 11:00 PM<br>Sat – Sun: 10:00 AM – Midnight</p>
                </div>
            </div>
        </div>

        <div>
            <p style="font-size:.72rem;letter-spacing:1.5px;text-transform:uppercase;color:var(--accent);font-weight:600;margin-bottom:.8rem;">Follow us on</p>
            <div class="social-row">
                <a href="https://www.instagram.com/" class="social-pill" target="_blank"><i class="fab fa-instagram"></i> Instagram</a>
                <a href="https://twitter.com/" class="social-pill" target="_blank"><i class="fab fa-twitter"></i> Twitter</a>
                <a href="https://www.facebook.com/" class="social-pill" target="_blank"><i class="fab fa-facebook-f"></i> Facebook</a>
                <a href="https://www.youtube.com/" class="social-pill" target="_blank"><i class="fab fa-youtube"></i> YouTube</a>
            </div>
        </div>
    </div>

    <!-- RIGHT: Form -->
    <div class="contact-form-wrap reveal">
        <div class="form-header">
            <h3>Send us a Message</h3>
            <p>We typically respond within 2–4 hours on business days.</p>
        </div>

      <form action="saveMessage.jsp" method="post">
            <div class="form-grid">

                <div class="form-group">
                    <label for="fname">First Name</label>
                    <input type="text" id="fname" name="fname" placeholder="Aryan" required>
                </div>

                <div class="form-group">
                    <label for="lname">Last Name</label>
                    <input type="text" id="lname" name="lname" placeholder="Sharma">
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" placeholder="you@example.com" required>
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="tel" id="phone" name="phone" placeholder="+91 9XXXXXXXXX">
                </div>

                <div class="form-group full">
                    <label for="subject">Subject</label>
                    <select id="subject" name="subject">
                        <option value="">Select a topic…</option>
                        <option value="order">Order Issue</option>
                        <option value="delivery">Delivery Problem</option>
                        <option value="payment">Payment Query</option>
                        <option value="feedback">Food Feedback</option>
                        <option value="partnership">Restaurant Partnership</option>
                        <option value="other">Other</option>
                    </select>
                </div>

                <div class="form-group full">
                    <label>Your Experience Rating</label>
                    <div class="rating-row">
                        <input type="radio" name="rating" id="s5" value="5"><label for="s5" title="5 stars">&#9733;</label>
                        <input type="radio" name="rating" id="s4" value="4"><label for="s4" title="4 stars">&#9733;</label>
                        <input type="radio" name="rating" id="s3" value="3"><label for="s3" title="3 stars">&#9733;</label>
                        <input type="radio" name="rating" id="s2" value="2"><label for="s2" title="2 stars">&#9733;</label>
                        <input type="radio" name="rating" id="s1" value="1"><label for="s1" title="1 star">&#9733;</label>
                    </div>
                </div>

                <div class="form-group full">
                    <label for="message">Your Message</label>
                    <textarea id="message" name="message" placeholder="Tell us what's on your mind — we're all ears (and taste buds)." required></textarea>
                </div>

            </div>

            <button type="submit" class="submit-btn">
                <i class="fas fa-paper-plane"></i> Send Message
            </button>
        </form>
    </div>

</section>

<hr class="divider">

<!-- ── MAP STRIP ── -->
<div class="map-strip reveal">
    <iframe
        src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d119744.46220620116!2d85.75787955!3d20.30096895!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3a1909d2d5170aa5%3A0xfc580e2b68b33fa8!2sBhubaneswar%2C%20Odisha!5e0!3m2!1sen!2sin!4v1716000000000!5m2!1sen!2sin"
        allowfullscreen loading="lazy"
        referrerpolicy="no-referrer-when-downgrade">
    </iframe>
    <div class="map-label">
        <i class="fas fa-location-dot"></i> Saheed Nagar, Bhubaneswar
    </div>
</div>

<hr class="divider">

<!-- ── FAQ SECTION ── -->
<section class="faq-section">
    <div class="section-header-inner reveal">
        <span class="section-eyebrow" style="font-size:.7rem;letter-spacing:2.5px;text-transform:uppercase;color:var(--accent);font-weight:600;"><i class="fas fa-circle-question"></i> &nbsp;FAQs</span>
        <h2 style="font-family:'Playfair Display',serif;font-size:clamp(1.6rem,3vw,2.2rem);font-weight:700;">Frequently Asked Questions</h2>
    </div>

    <div class="faq-grid">

        <div class="faq-item reveal">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do I track my order?
                <i class="fas fa-chevron-down"></i>
            </button>
            <div class="faq-answer">
                <p>Once your order is placed, you'll receive a tracking link via SMS and email. You can also check live status under <strong>My Orders</strong> in your account.</p>
            </div>
        </div>

        <div class="faq-item reveal">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is your cancellation policy?
                <i class="fas fa-chevron-down"></i>
            </button>
            <div class="faq-answer">
                <p>Orders can be cancelled within 5 minutes of placement for a full refund. After that, cancellations are subject to the restaurant's policy and may incur a partial charge.</p>
            </div>
        </div>

        <div class="faq-item reveal">
            <button class="faq-question" onclick="toggleFaq(this)">
                How long does delivery take?
                <i class="fas fa-chevron-down"></i>
            </button>
            <div class="faq-answer">
                <p>Average delivery time is 30–45 minutes depending on your location and restaurant distance. Estimated time is always shown at checkout before you confirm.</p>
            </div>
        </div>

        <div class="faq-item reveal">
            <button class="faq-question" onclick="toggleFaq(this)">
                Do you offer refunds for wrong orders?
                <i class="fas fa-chevron-down"></i>
            </button>
            <div class="faq-answer">
                <p>Absolutely. If you received an incorrect or incomplete order, raise a request within 1 hour of delivery. Our team will process a full refund or re-delivery at no extra cost.</p>
            </div>
        </div>

        <div class="faq-item reveal">
            <button class="faq-question" onclick="toggleFaq(this)">
                Can I schedule an order in advance?
                <i class="fas fa-chevron-down"></i>
            </button>
            <div class="faq-answer">
                <p>Yes! On the checkout page, tap <em>Schedule Delivery</em> and pick a date and time up to 2 days in advance. Perfect for parties and special occasions.</p>
            </div>
        </div>

        <div class="faq-item reveal">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do I become a restaurant partner?
                <i class="fas fa-chevron-down"></i>
            </button>
            <div class="faq-answer">
                <p>We'd love to have you! Fill out the contact form above and select <strong>Restaurant Partnership</strong> as the subject. Our partnerships team will reach out within 48 hours.</p>
            </div>
        </div>

    </div>
</section>

<!-- ── FOOTER ── -->
<footer>
    <div class="footer-grid">
        <div class="footer-brand">
            <div class="footer-logo">
                <i class="fa fa-utensils" style="color:var(--accent)"></i>
                <span>Foodies.</span>
            </div>
            <p>Connecting food lovers with the best restaurants and home recipes since 2021.</p>
        </div>
        <div class="footer-col">
            <h5>Foodies</h5>
            <ul>
                <li><a href="#">About Us</a></li>
                <li><a href="#">Our Services</a></li>
                <li><a href="#">Privacy Policy</a></li>
                <li><a href="#">Payment Policy</a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h5>Get Help</h5>
            <ul>
                <li><a href="#">FAQ</a></li>
                <li><a href="#">Delivery</a></li>
                <li><a href="orders.jsp?id=<%= user_id %>">My Orders</a></li>
                <li><a href="#">Order Status</a></li>
                <li><a href="#">Payment Options</a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h5>Order Now</h5>
            <ul>
                <li><a href="./dishes.jsp">Biryanis</a></li>
                <li><a href="./dishes.jsp">Restaurants</a></li>
                <li><a href="./dishes.jsp">Starters</a></li>
                <li><a href="./dishes.jsp">Fast Food</a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h5>Follow Us</h5>
            <div class="social-links">
                <a href="https://www.facebook.com/"><i class="fab fa-facebook-f"></i></a>
                <a href="https://twitter.com/"><i class="fab fa-twitter"></i></a>
                <a href="https://www.instagram.com/"><i class="fab fa-instagram"></i></a>
                <a href="https://www.linkedin.com/"><i class="fab fa-linkedin-in"></i></a>
                <a href="https://www.youtube.com/"><i class="fab fa-youtube"></i></a>
            </div>
        </div>
    </div>
    <div class="footer-bottom">
        <span>&copy; 2024 Foodies. All rights reserved.</span>
        <span>Made with <i class="fas fa-heart" style="color:var(--red);font-size:.65rem"></i> in Bhubaneswar</span>
    </div>
</footer>

<!-- ── JAVASCRIPT ── -->
<script>
    /* Scroll reveal */
    const observer = new IntersectionObserver(entries => {
        entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
    }, { threshold: 0.1 });
    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

    /* FAQ accordion */
    function toggleFaq(btn) {
        const item = btn.closest('.faq-item');
        const isOpen = item.classList.contains('open');
        document.querySelectorAll('.faq-item.open').forEach(i => i.classList.remove('open'));
        if (!isOpen) item.classList.add('open');
    }

    /* Form submit toast */
    function handleSubmit(e) {
        e.preventDefault();
        const btn = e.target.querySelector('.submit-btn');
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Sending…';
        btn.disabled = true;

        setTimeout(() => {
            btn.innerHTML = '<i class="fas fa-check"></i> Message Sent!';
            btn.style.background = 'var(--green)';

            showToast('✔  Your message has been sent! We\'ll respond soon.');

            setTimeout(() => {
                btn.innerHTML = '<i class="fas fa-paper-plane"></i> Send Message';
                btn.style.background = '';
                btn.disabled = false;
                e.target.reset();
            }, 3000);
        }, 1800);
    }

    function showToast(msg) {
        const toast = document.createElement('div');
        toast.textContent = msg;
        Object.assign(toast.style, {
            position: 'fixed', bottom: '28px', right: '28px',
            background: 'var(--accent)', color: '#000',
            padding: '.75rem 1.3rem', borderRadius: '10px',
            fontFamily: "'DM Sans', sans-serif", fontWeight: '600',
            fontSize: '.82rem', zIndex: '9000',
            boxShadow: '0 8px 30px rgba(0,0,0,.4)',
            transform: 'translateY(80px)', opacity: '0',
            transition: 'all .3s'
        });
        document.body.appendChild(toast);
        requestAnimationFrame(() => {
            toast.style.transform = 'translateY(0)';
            toast.style.opacity = '1';
        });
        setTimeout(() => {
            toast.style.opacity = '0';
            toast.style.transform = 'translateY(80px)';
            setTimeout(() => toast.remove(), 300);
        }, 3500);
    }
</script>

</body>
</html>
