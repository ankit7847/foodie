<%@page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Foodies</title>
    <link rel="icon" href="./Images/Restaurants/download.png" type="image/icon type">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;0,900;1,400&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">

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

        * { margin: 0; padding: 0; box-sizing: border-box; }
        html, body { height: 100%; overflow: hidden; }

        body {
            background: var(--bg);
            color: var(--text);
            font-family: 'DM Sans', sans-serif;
        }

        /* ── NOISE OVERLAY ── */
        body::before {
            content: '';
            position: fixed; inset: 0;
            background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.035'/%3E%3C/svg%3E");
            pointer-events: none; z-index: 9999; opacity: .4;
        }

        /* ── FULL-SCREEN LAYOUT ── */
        .welcome-page {
            display: grid;
            grid-template-columns: 1fr 1fr;
            height: 100vh;
            position: relative;
        }

        /* ── LEFT PANEL ── */
        .left-panel {
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 4rem 4rem 4rem 5rem;
            background: linear-gradient(145deg, #1c1108 0%, #2a1a08 50%, #1a1612 100%);
            overflow: hidden;
            z-index: 1;
        }

        .left-panel::before {
            content: '';
            position: absolute; inset: 0;
            background:
                radial-gradient(ellipse 70% 60% at 30% 40%, rgba(232,160,62,.13), transparent),
                radial-gradient(ellipse 50% 80% at 80% 80%, rgba(196,92,46,.08), transparent);
        }

        /* Rotating decorative ring */
        .ring-deco {
            position: absolute;
            width: 600px; height: 600px;
            border-radius: 50%;
            border: 1px solid rgba(232,160,62,.06);
            top: 50%; left: 50%;
            transform: translate(-50%, -50%);
            animation: spinRing 60s linear infinite;
            pointer-events: none;
        }
        .ring-deco::before {
            content: '';
            position: absolute; inset: 60px;
            border-radius: 50%;
            border: 1px solid rgba(232,160,62,.04);
        }
        .ring-deco::after {
            content: '';
            position: absolute; inset: 120px;
            border-radius: 50%;
            border: 1px solid rgba(232,160,62,.025);
        }
        @keyframes spinRing { to { transform: translate(-50%, -50%) rotate(360deg); } }

        .left-content { position: relative; z-index: 2; }

        /* Brand mark */
        .brand-mark {
            display: flex; align-items: center; gap: .7rem;
            margin-bottom: 3rem;
            opacity: 0; animation: fadeUp .6s ease .1s forwards;
        }
        .brand-mark i { color: var(--accent); font-size: 1.2rem; }
        .brand-mark span {
            font-family: 'Playfair Display', serif;
            font-size: 1.5rem; color: var(--accent);
            letter-spacing: .5px; font-weight: 700;
        }

        .welcome-eyebrow {
            display: inline-flex; align-items: center; gap: .5rem;
            font-size: .7rem; letter-spacing: 2px; text-transform: uppercase;
            color: var(--accent); margin-bottom: 1.5rem;
            background: rgba(232,160,62,.1); border: 1px solid rgba(232,160,62,.2);
            padding: .3rem .9rem; border-radius: 100px;
            opacity: 0; animation: fadeUp .6s ease .2s forwards;
        }

        .welcome-heading {
            font-family: 'Playfair Display', serif;
            font-size: clamp(2.8rem, 4.5vw, 4rem);
            line-height: 1.05; font-weight: 900;
            letter-spacing: -1px;
            margin-bottom: 1.4rem;
            opacity: 0; animation: fadeUp .6s ease .3s forwards;
        }

        .welcome-heading em {
            font-style: italic;
            background: linear-gradient(90deg, var(--accent), var(--accent2));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .welcome-sub {
            color: var(--muted); font-size: .95rem;
            line-height: 1.8; max-width: 400px;
            margin-bottom: 2.5rem;
            opacity: 0; animation: fadeUp .6s ease .4s forwards;
        }

        /* CTA Buttons */
        .cta-group {
            display: flex; flex-direction: column; gap: .9rem;
            max-width: 340px;
            opacity: 0; animation: fadeUp .6s ease .5s forwards;
        }

        .btn-primary {
            background: var(--accent); color: #000;
            border: none; border-radius: 12px;
            padding: 1rem 2rem;
            font-family: 'DM Sans', sans-serif;
            font-size: .95rem; font-weight: 700;
            letter-spacing: .3px; cursor: pointer; text-decoration: none;
            display: flex; align-items: center; justify-content: center; gap: .7rem;
            transition: background .2s, transform .15s, box-shadow .2s;
        }
        .btn-primary:hover {
            background: #f5b04a;
            transform: translateY(-2px);
            box-shadow: 0 10px 32px rgba(232,160,62,.38);
        }

        .btn-ghost {
            background: transparent; color: var(--text);
            border: 1px solid var(--border); border-radius: 12px;
            padding: 1rem 2rem;
            font-family: 'DM Sans', sans-serif;
            font-size: .95rem; font-weight: 500;
            cursor: pointer; text-decoration: none;
            display: flex; align-items: center; justify-content: center; gap: .7rem;
            transition: border-color .2s, color .2s;
        }
        .btn-ghost:hover { border-color: var(--accent); color: var(--accent); }

        /* Divider */
        .or-divider {
            display: flex; align-items: center; gap: 1rem;
            color: var(--muted); font-size: .75rem; letter-spacing: 1px;
            text-transform: uppercase;
        }
        .or-divider::before, .or-divider::after {
            content: ''; flex: 1; height: 1px; background: var(--border);
        }

        /* Bottom trust line */
        .trust-row {
            display: flex; align-items: center; gap: 1.5rem;
            margin-top: 3rem; padding-top: 2rem;
            border-top: 1px solid var(--border);
            opacity: 0; animation: fadeUp .6s ease .65s forwards;
        }
        .trust-item {
            display: flex; align-items: center; gap: .5rem;
            font-size: .75rem; color: var(--muted);
        }
        .trust-item i { color: var(--accent); font-size: .7rem; }

        /* ── RIGHT PANEL ── */
        .right-panel {
            position: relative;
            background: var(--surface);
            overflow: hidden;
            display: flex; align-items: center; justify-content: center;
        }

        /* Mosaic grid */
        .mosaic {
            display: grid;
            grid-template-columns: 1.1fr 1fr;
            grid-template-rows: 1.2fr 1fr 1fr;
            gap: 8px;
            width: 100%; height: 100%;
            padding: 0;
        }

        .mosaic-item {
            overflow: hidden; position: relative;
            opacity: 0; animation: fadeIn .7s ease forwards;
        }

        .mosaic-item:nth-child(1) {
            grid-column: 1; grid-row: 1 / 3;
            animation-delay: .3s;
        }
        .mosaic-item:nth-child(2) {
            grid-column: 2; grid-row: 1;
            animation-delay: .45s;
        }
        .mosaic-item:nth-child(3) {
            grid-column: 2; grid-row: 2;
            animation-delay: .55s;
        }
        .mosaic-item:nth-child(4) {
            grid-column: 1; grid-row: 3;
            animation-delay: .65s;
        }
        .mosaic-item:nth-child(5) {
            grid-column: 2; grid-row: 3;
            animation-delay: .75s;
        }

        .mosaic-item img {
            width: 100%; height: 100%;
            object-fit: cover;
            transition: transform .6s ease;
        }
        .mosaic-item:hover img { transform: scale(1.07); }

        /* Overlay labels on mosaic */
        .mosaic-label {
            position: absolute; bottom: .6rem; left: .7rem;
            background: rgba(15,14,12,.82);
            border: 1px solid rgba(232,160,62,.25);
            border-radius: 100px;
            padding: .22rem .75rem;
            font-size: .66rem; font-weight: 600;
            color: var(--accent); letter-spacing: .5px;
            text-transform: uppercase;
        }

        /* Central floating card */
        .float-card {
            position: absolute;
            bottom: 2.5rem; left: 50%; transform: translateX(-50%);
            background: rgba(26,24,21,.92);
            backdrop-filter: blur(16px);
            border: 1px solid rgba(232,160,62,.2);
            border-radius: 16px;
            padding: 1rem 1.8rem;
            display: flex; align-items: center; gap: 1.2rem;
            white-space: nowrap;
            z-index: 10;
            opacity: 0; animation: floatUp .7s ease .9s forwards;
        }
        .float-card-stat { text-align: center; }
        .float-card-num {
            font-family: 'Playfair Display', serif;
            font-size: 1.4rem; font-weight: 700;
            color: var(--accent); display: block;
            line-height: 1;
        }
        .float-card-label {
            font-size: .64rem; color: var(--muted);
            text-transform: uppercase; letter-spacing: 1px;
        }
        .float-divider {
            width: 1px; height: 36px; background: var(--border);
        }

        /* Right-panel gradient overlay */
        .right-panel::after {
            content: '';
            position: absolute; inset: 0;
            background:
                linear-gradient(to bottom, rgba(26,24,21,.35) 0%, transparent 30%),
                linear-gradient(to top, rgba(26,24,21,.6) 0%, transparent 40%);
            pointer-events: none;
            z-index: 2;
        }
        .float-card { z-index: 5; }
        .mosaic { z-index: 1; }

        /* ── ANIMATIONS ── */
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(22px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to   { opacity: 1; }
        }
        @keyframes floatUp {
            from { opacity: 0; transform: translateX(-50%) translateY(16px); }
            to   { opacity: 1; transform: translateX(-50%) translateY(0); }
        }

        /* ── PAGE TRANSITION (exit) ── */
        body.exiting {
            animation: pageExit .4s ease forwards;
        }
        @keyframes pageExit {
            to { opacity: 0; transform: scale(.97); }
        }

        /* ── RESPONSIVE ── */
        @media (max-width: 900px) {
            html, body { overflow: auto; }
            .welcome-page { grid-template-columns: 1fr; height: auto; }
            .left-panel { padding: 3rem 2rem; order: 2; }
            .right-panel { height: 50vh; order: 1; }
            .float-card { bottom: 1.5rem; padding: .8rem 1.3rem; }
            .float-card-num { font-size: 1.1rem; }
        }
        @media (max-width: 500px) {
            .welcome-heading { font-size: 2.4rem; }
            .trust-row { flex-wrap: wrap; gap: 1rem; }
        }
    </style>
</head>
<body>

<div class="welcome-page">

    <!-- ── LEFT PANEL ── -->
    <div class="left-panel">
        <div class="ring-deco"></div>
        <div class="left-content">

            <!-- Brand -->
            <div class="brand-mark">
                <i class="fa fa-utensils"></i>
                <span>Foodies.</span>
            </div>

            <!-- Eyebrow -->
            <div class="welcome-eyebrow">
                <i class="fas fa-fire-flame-curved"></i> Welcome to Foodies
            </div>

            <!-- Heading -->
            <h1 class="welcome-heading">
                Your Table<br>is <em>Ready,</em><br>Always.
            </h1>

            <!-- Subtext -->
            <p class="welcome-sub">
                From street-side biryanis to fine-dining experiences —
                explore the best food Bhubaneswar has to offer,
                delivered right to your door in 30 minutes.
            </p>

            <!-- CTA Buttons -->
            <div class="cta-group">
                <a href="./login.jsp" class="btn-primary" onclick="exitTo(event, 'login.jsp')">
                    <i class="fas fa-utensils"></i> Get Started &nbsp;—&nbsp; Order Now
                </a>
                <div class="or-divider">or</div>
                <a href="./register.jsp" class="btn-ghost" onclick="exitTo(event, 'register.jsp')">
                    <i class="fas fa-user-plus"></i> Create a Free Account
                </a>
            </div>

            <!-- Trust signals -->
            <div class="trust-row">
                <div class="trust-item">
                    <i class="fas fa-shield-halved"></i>
                    <span>Secure Payments</span>
                </div>
                <div class="trust-item">
                    <i class="fas fa-clock"></i>
                    <span>30 min Delivery</span>
                </div>
                <div class="trust-item">
                    <i class="fas fa-star"></i>
                    <span>50+ Restaurants</span>
                </div>
            </div>

        </div>
    </div>

    <!-- ── RIGHT PANEL ── -->
    <div class="right-panel">

        <div class="mosaic">
            <div class="mosaic-item">
                <img src="./Images/Restaurants/barbeque.jpg" alt="Barbeque Nation">
                <span class="mosaic-label">Barbeque Nation</span>
            </div>
            <div class="mosaic-item">
                <img src="./Images/Dishes/Chicken-Biryani.jpg" alt="Biryani">
                <span class="mosaic-label">Biryani</span>
            </div>
            <div class="mosaic-item">
                <img src="./Images/Dishes/panner tikka.jpg" alt="Paneer Tikka">
                <span class="mosaic-label">Paneer Tikka</span>
            </div>
            <div class="mosaic-item">
                <img src="./Images/Restaurants/paradise.jpg" alt="Paradise">
                <span class="mosaic-label">Paradise</span>
            </div>
            <div class="mosaic-item">
                <img src="./Images/Dishes/garlicprawns.jpg" alt="Garlic Prawns">
                <span class="mosaic-label">Garlic Prawns</span>
            </div>
        </div>

        <!-- Floating stats card -->
        <div class="float-card">
            <div class="float-card-stat">
                <span class="float-card-num">50+</span>
                <span class="float-card-label">Restaurants</span>
            </div>
            <div class="float-divider"></div>
            <div class="float-card-stat">
                <span class="float-card-num">200+</span>
                <span class="float-card-label">Menu Items</span>
            </div>
            <div class="float-divider"></div>
            <div class="float-card-stat">
                <span class="float-card-num">30<small style="font-size:.8rem">min</small></span>
                <span class="float-card-label">Avg Delivery</span>
            </div>
        </div>

    </div>

</div>

<script>
    function exitTo(e, href) {
        e.preventDefault();
        document.body.classList.add('exiting');
        setTimeout(() => { window.location.href = href; }, 380);
    }
</script>

</body>
</html>
