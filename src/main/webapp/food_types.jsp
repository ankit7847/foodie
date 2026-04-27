<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- <%@page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%> --%>
<%@page import="java.sql.*,com.db.ConnectionProvider"%>
<%@ page import="java.util.Base64" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Food Types - Foodies</title>
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

        /* ── HERO BANNER ── */
        .hero {
            position: relative; overflow: hidden;
            min-height: 380px;
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

        /* ── SECTION LABELS ── */
        .section-header {
            display: flex; align-items: flex-end; justify-content: space-between;
            padding: 3.5rem 4rem 1.8rem;
        }

        .section-label {
            display: flex; flex-direction: column; gap: .4rem;
        }

        .section-label .eyebrow {
            font-size: .7rem; letter-spacing: 2.5px; text-transform: uppercase;
            color: var(--accent); font-weight: 600;
        }

        .section-label h2 {
            font-family: 'Playfair Display', serif;
            font-size: clamp(1.6rem, 3vw, 2.2rem);
            font-weight: 700; line-height: 1.2;
        }

        .see-all {
            color: var(--muted); font-size: .8rem; text-decoration: none;
            letter-spacing: .5px; text-transform: uppercase;
            display: flex; align-items: center; gap: .4rem;
            transition: color .2s;
        }
        .see-all:hover { color: var(--accent); }

        /* ── CATEGORY FILTER PILLS ── */
        .filter-bar {
            padding: 0 4rem 2rem;
            display: flex; gap: .7rem; flex-wrap: wrap;
        }

        .pill {
            padding: .4rem 1rem; border-radius: 100px;
            border: 1px solid var(--border); background: transparent;
            color: var(--muted); font-size: .78rem; cursor: pointer;
            font-family: 'DM Sans', sans-serif; letter-spacing: .3px;
            transition: all .2s;
        }
        .pill:hover, .pill.active {
            background: var(--accent); border-color: var(--accent);
            color: #000; font-weight: 600;
        }

        /* ── DISH GRID ── */
        .dish-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 1.5rem; padding: 0 4rem 2rem;
        }

        .dish-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 16px; overflow: hidden;
            cursor: pointer; transition: transform .25s, border-color .25s, box-shadow .25s;
            position: relative;
        }

        .dish-card:hover {
            transform: translateY(-6px);
            border-color: rgba(232,160,62,.35);
            box-shadow: 0 20px 50px rgba(0,0,0,.5), 0 0 0 1px rgba(232,160,62,.1);
        }

        .dish-img-wrap {
            position: relative; overflow: hidden;
            height: 190px;
        }

        .dish-img-wrap img {
            width: 100%; height: 100%; object-fit: cover;
            transition: transform .4s;
        }

        .dish-card:hover .dish-img-wrap img { transform: scale(1.07); }

        .dish-badge {
            position: absolute; top: 10px; left: 10px;
            font-size: .65rem; font-weight: 700; letter-spacing: 1px;
            text-transform: uppercase; padding: .25rem .6rem; border-radius: 6px;
        }
        .badge-veg   { background: var(--green); color: #fff; }
        .badge-nonveg{ background: var(--red);   color: #fff; }
        .badge-special{ background: var(--accent); color: #000; }

        .dish-fav {
            position: absolute; top: 10px; right: 10px;
            background: rgba(0,0,0,.55); border: none; border-radius: 50%;
            width: 32px; height: 32px; display: flex; align-items: center; justify-content: center;
            cursor: pointer; color: var(--muted); font-size: .85rem;
            transition: color .2s, background .2s;
        }
        .dish-fav:hover { color: #e05; background: rgba(0,0,0,.8); }
        .dish-fav.liked { color: #e05; }

        .dish-info { padding: 1rem 1.1rem 1.2rem; }

        .dish-meta {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: .4rem;
        }

        .dish-cat {
            font-size: .68rem; color: var(--accent);
            text-transform: uppercase; letter-spacing: 1px; font-weight: 600;
        }

        .dish-rating {
            display: flex; align-items: center; gap: .25rem;
            font-size: .75rem; color: var(--accent);
        }

        .dish-name {
            font-family: 'Playfair Display', serif;
            font-size: 1.05rem; font-weight: 700;
            margin-bottom: .35rem; line-height: 1.3;
        }

        .dish-desc {
            font-size: .78rem; color: var(--muted);
            line-height: 1.55; margin-bottom: .9rem;
        }

        .dish-footer {
            display: flex; align-items: center; justify-content: space-between;
        }

        .dish-price {
            font-size: 1.1rem; font-weight: 700; color: var(--text);
        }
        .dish-price span {
            font-size: .7rem; color: var(--muted); font-weight: 400; margin-left: 2px;
        }

        .add-btn {
            background: var(--accent); color: #000;
            border: none; border-radius: 8px;
            padding: .4rem .9rem; font-size: .78rem; font-weight: 700;
            cursor: pointer; letter-spacing: .3px;
            transition: background .2s, transform .15s;
            font-family: 'DM Sans', sans-serif;
        }
        .add-btn:hover { background: #f5b04a; transform: scale(1.05); }

        /* ── DIVIDER ── */
        .divider {
            margin: 1rem 4rem;
            border: none; border-top: 1px solid var(--border);
        }

        /* ── YOUTUBE PLAYLIST ── */
        .playlist-section { padding: 0 4rem 5rem; }

        .playlist-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.5rem; margin-top: .5rem;
        }

        .video-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 14px; overflow: hidden;
            transition: transform .25s, border-color .25s, box-shadow .25s;
            cursor: pointer;
        }

        .video-card:hover {
            transform: translateY(-5px);
            border-color: rgba(232,160,62,.3);
            box-shadow: 0 16px 40px rgba(0,0,0,.45);
        }

        .video-thumb {
            position: relative; overflow: hidden;
            padding-top: 56.25%; /* 16:9 */
        }

        .video-thumb iframe {
            position: absolute; inset: 0;
            width: 100%; height: 100%;
            border: none;
        }

        .video-thumb .play-overlay {
            position: absolute; inset: 0;
            background: rgba(0,0,0,.4);
            display: flex; align-items: center; justify-content: center;
            transition: opacity .25s;
        }
        .video-card:hover .play-overlay { opacity: 0; }

        .play-btn-big {
            width: 54px; height: 54px; border-radius: 50%;
            background: var(--accent);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.2rem; color: #000;
            box-shadow: 0 4px 20px rgba(232,160,62,.4);
        }

        .video-info { padding: 1rem 1.1rem 1.2rem; }

        .video-tag {
            display: inline-block;
            font-size: .65rem; font-weight: 700; letter-spacing: 1px;
            text-transform: uppercase; color: var(--accent);
            background: rgba(232,160,62,.1); padding: .2rem .55rem;
            border-radius: 5px; margin-bottom: .55rem;
        }

        .video-title {
            font-family: 'Playfair Display', serif;
            font-size: .98rem; font-weight: 700;
            line-height: 1.35; margin-bottom: .35rem;
        }

        .video-meta {
            display: flex; align-items: center; gap: 1rem;
            font-size: .72rem; color: var(--muted);
        }

        .video-meta i { font-size: .65rem; }

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
        .footer-logo span {
            font-family: 'Playfair Display', serif;
            font-size: 1.25rem; color: var(--accent);
        }

        .footer-col h5 {
            font-size: .7rem; letter-spacing: 2px; text-transform: uppercase;
            color: var(--accent); margin-bottom: 1rem; font-weight: 600;
        }

        .footer-col ul { list-style: none; }
        .footer-col ul li { margin-bottom: .55rem; }
        .footer-col ul li a {
            color: var(--muted); text-decoration: none; font-size: .82rem;
            transition: color .2s;
        }
        .footer-col ul li a:hover { color: var(--text); }

        .social-links { display: flex; gap: .8rem; margin-top: .5rem; }
        .social-links a {
            width: 34px; height: 34px; border-radius: 8px;
            border: 1px solid var(--border);
            display: flex; align-items: center; justify-content: center;
            color: var(--muted); font-size: .82rem; text-decoration: none;
            transition: all .2s;
        }
        .social-links a:hover {
            border-color: var(--accent); color: var(--accent);
            background: rgba(232,160,62,.08);
        }

        .footer-bottom {
            padding-top: 1.5rem;
            display: flex; align-items: center; justify-content: space-between;
            font-size: .75rem; color: var(--muted);
        }

        /* ── SCROLL ANIMATIONS ── */
        .reveal {
            opacity: 0; transform: translateY(28px);
            transition: opacity .55s ease, transform .55s ease;
        }
        .reveal.visible { opacity: 1; transform: translateY(0); }

        /* ── RESPONSIVE ── */
        @media (max-width: 900px) {
            header { padding: 0 1.5rem; }
            .navbar { display: none; }
            .hero { padding: 3.5rem 1.5rem; }
            .section-header, .filter-bar, .dish-grid,
            .playlist-section, .divider { padding-left: 1.5rem; padding-right: 1.5rem; }
            .dish-grid { grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); }
            .footer-grid { grid-template-columns: 1fr 1fr; }
            .footer { padding: 2.5rem 1.5rem 1.5rem; }
        }

        @media (max-width: 500px) {
            .dish-grid { grid-template-columns: 1fr; }
            .playlist-grid { grid-template-columns: 1fr; }
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
        <a class="active" href="./food_types.jsp">Food Types</a>
        <a href="./contact.jsp">Contact Us</a>
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
        <div class="hero-eyebrow"><i class="fas fa-fire"></i> Curated for you</div>
        <h1>Explore Every<br><em>Flavour & Cuisine</em></h1>
        <p>Browse dishes by type — from smoky BBQ and spicy biryanis to sweet desserts — plus handpicked cooking videos to inspire your next meal.</p>
    </div>
</section>

<!-- ══════════════════════════════════════
     DISH TYPES SECTION
══════════════════════════════════════ -->
<div class="section-header reveal">
    <div class="section-label">
        <span class="eyebrow"><i class="fas fa-bowl-food"></i> &nbsp;Categories</span>
        <h2>Dishes by Type</h2>
    </div>
    <a href="./dishes.jsp" class="see-all">View all dishes <i class="fas fa-arrow-right"></i></a>
</div>

<!-- Filter Pills -->
<div class="filter-bar reveal" id="filter-bar">
    <button class="pill active" data-filter="all">All</button>
    <button class="pill" data-filter="biryani">Biryani</button>
    <button class="pill" data-filter="starters">Starters</button>
    <button class="pill" data-filter="fastfood">Fast Food</button>
    <button class="pill" data-filter="seafood">Seafood</button>
    <button class="pill" data-filter="vegetarian">Vegetarian</button>
    <button class="pill" data-filter="desserts">Desserts</button>
    <button class="pill" data-filter="breakfast">Breakfast</button>
    <button class="pill" data-filter="chinese">Chinese</button>
</div>

<!-- Dish Grid (static showcase — replace img src & data attrs from DB as needed) -->
<div class="dish-grid" id="dish-grid">

    <!-- BIRYANI -->
    <div class="dish-card reveal" data-category="biryani">
        <div class="dish-img-wrap">
            <img src="./Images/Dishes/Chicken-Biryani.jpg" alt="Chicken Biryani">
            <span class="dish-badge badge-nonveg">Non-Veg</span>
            <button class="dish-fav" onclick="toggleFav(this)"><i class="fas fa-heart"></i></button>
        </div>
        <div class="dish-info">
            <div class="dish-meta">
                <span class="dish-cat">Biryani</span>
                <span class="dish-rating"><i class="fas fa-star"></i> 4.8</span>
            </div>
            <div class="dish-name">Chicken Dum Biryani</div>
            <div class="dish-desc">Slow-cooked aromatic rice layered with tender chicken, saffron & fried onions.</div>
            <div class="dish-footer">
                <div class="dish-price">₹280 <span>/ plate</span></div>
                <button class="add-btn" onclick="addToCart('Chicken Dum Biryani')">+ Add</button>
            </div>
        </div>
    </div>

    <div class="dish-card reveal" data-category="biryani">
        <div class="dish-img-wrap">
            <img src="./Images/Dishes/vegpulao.jpg" alt="Veg Biryani">
            <span class="dish-badge badge-veg">Veg</span>
            <button class="dish-fav" onclick="toggleFav(this)"><i class="fas fa-heart"></i></button>
        </div>
        <div class="dish-info">
            <div class="dish-meta">
                <span class="dish-cat">Biryani</span>
                <span class="dish-rating"><i class="fas fa-star"></i> 4.5</span>
            </div>
            <div class="dish-name">Veg Dum Biryani</div>
            <div class="dish-desc">Fresh garden vegetables slow-cooked with basmati rice and whole spices.</div>
            <div class="dish-footer">
                <div class="dish-price">₹200 <span>/ plate</span></div>
                <button class="add-btn" onclick="addToCart('Veg Dum Biryani')">+ Add</button>
            </div>
        </div>
    </div>

    <!-- STARTERS -->
    <div class="dish-card reveal" data-category="starters">
        <div class="dish-img-wrap">
            <img src="./Images/Dishes/chicken.jpeg" alt="Chicken Lollipop">
            <span class="dish-badge badge-nonveg">Non-Veg</span>
            <button class="dish-fav" onclick="toggleFav(this)"><i class="fas fa-heart"></i></button>
        </div>
        <div class="dish-info">
            <div class="dish-meta">
                <span class="dish-cat">Starters</span>
                <span class="dish-rating"><i class="fas fa-star"></i> 4.7</span>
            </div>
            <div class="dish-name">Chicken Lollipop</div>
            <div class="dish-desc">Crispy fried chicken wings glazed in a fiery Indo-Chinese sauce.</div>
            <div class="dish-footer">
                <div class="dish-price">₹220 <span>/ 6 pcs</span></div>
                <button class="add-btn" onclick="addToCart('Chicken Lollipop')">+ Add</button>
            </div>
        </div>
    </div>

    <div class="dish-card reveal" data-category="starters">
        <div class="dish-img-wrap">
            <img src="./Images/Dishes/panner tikka.jpg" alt="Paneer Tikka">
            <span class="dish-badge badge-veg">Veg</span>
            <button class="dish-fav" onclick="toggleFav(this)"><i class="fas fa-heart"></i></button>
        </div>
        <div class="dish-info">
            <div class="dish-meta">
                <span class="dish-cat">Starters</span>
                <span class="dish-rating"><i class="fas fa-star"></i> 4.6</span>
            </div>
            <div class="dish-name">Paneer Tikka</div>
            <div class="dish-desc">Chargrilled cottage cheese skewers marinated in tandoori spices and yoghurt.</div>
            <div class="dish-footer">
                <div class="dish-price">₹190 <span>/ plate</span></div>
                <button class="add-btn" onclick="addToCart('Paneer Tikka')">+ Add</button>
            </div>
        </div>
    </div>

    <!-- SEAFOOD -->
    <div class="dish-card reveal" data-category="seafood">
        <div class="dish-img-wrap">
            <img src="./Images/Dishes/garlicprawns.jpg" alt="Garlic Prawns">
            <span class="dish-badge badge-nonveg">Non-Veg</span>
            <button class="dish-fav" onclick="toggleFav(this)"><i class="fas fa-heart"></i></button>
        </div>
        <div class="dish-info">
            <div class="dish-meta">
                <span class="dish-cat">Seafood</span>
                <span class="dish-rating"><i class="fas fa-star"></i> 4.9</span>
            </div>
            <div class="dish-name">Garlic Butter Prawns</div>
            <div class="dish-desc">Juicy tiger prawns tossed in rich garlic butter with fresh herbs and lemon.</div>
            <div class="dish-footer">
                <div class="dish-price">₹380 <span>/ plate</span></div>
                <button class="add-btn" onclick="addToCart('Garlic Butter Prawns')">+ Add</button>
            </div>
        </div>
    </div>

    <!-- FAST FOOD -->
    <div class="dish-card reveal" data-category="fastfood">
        <div class="dish-img-wrap">
            <img src="./Images/Dishes/margherita-pizza.jpg" alt="Pizza">
            <span class="dish-badge badge-special">Chef's Pick</span>
            <button class="dish-fav" onclick="toggleFav(this)"><i class="fas fa-heart"></i></button>
        </div>
        <div class="dish-info">
            <div class="dish-meta">
                <span class="dish-cat">Fast Food</span>
                <span class="dish-rating"><i class="fas fa-star"></i> 4.5</span>
            </div>
            <div class="dish-name">Loaded Margherita Pizza</div>
            <div class="dish-desc">Classic thin-crust pizza with San Marzano tomato sauce and fresh mozzarella.</div>
            <div class="dish-footer">
                <div class="dish-price">₹320 <span>/ 8" pizza</span></div>
                <button class="add-btn" onclick="addToCart('Margherita Pizza')">+ Add</button>
            </div>
        </div>
    </div>

    <!-- BREAKFAST -->
    <div class="dish-card reveal" data-category="breakfast">
        <div class="dish-img-wrap">
            <img src="./Images/Dishes/dosa.jpg" alt="Masala Dosa">
            <span class="dish-badge badge-veg">Veg</span>
            <button class="dish-fav" onclick="toggleFav(this)"><i class="fas fa-heart"></i></button>
        </div>
        <div class="dish-info">
            <div class="dish-meta">
                <span class="dish-cat">Breakfast</span>
                <span class="dish-rating"><i class="fas fa-star"></i> 4.7</span>
            </div>
            <div class="dish-name">Masala Dosa</div>
            <div class="dish-desc">Golden crispy rice crêpe stuffed with spiced potato filling, served with chutneys & sambar.</div>
            <div class="dish-footer">
                <div class="dish-price">₹90 <span>/ plate</span></div>
                <button class="add-btn" onclick="addToCart('Masala Dosa')">+ Add</button>
            </div>
        </div>
    </div>

    <!-- DB-DRIVEN DISHES (dynamic) -->
    <%
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = ConnectionProvider.getConnection();
            String sql = "SELECT * FROM dishes LIMIT 8";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                int    did   = rs.getInt("dish_id");
                String dname = rs.getString("dish_name");
                String ddesc = rs.getString("description");
                double dprice= rs.getDouble("price");
                String dtype = rs.getString("dish_type");
                byte[] dimg  = rs.getBytes("dish_image");
                String b64   = (dimg != null) ? Base64.getEncoder().encodeToString(dimg) : "";
                String cat   = (dtype != null) ? dtype.toLowerCase().replace(" ","") : "other";
    %>
    <div class="dish-card reveal" data-category="<%= cat %>">
        <div class="dish-img-wrap">
            <% if (!b64.isEmpty()) { %>
            <img src="data:image/jpeg;base64,<%= b64 %>" alt="<%= dname %>">
            <% } else { %>
            <img src="./Images/Dishes/default.jpg" alt="<%= dname %>">
            <% } %>
            <button class="dish-fav" onclick="toggleFav(this)"><i class="fas fa-heart"></i></button>
        </div>
        <div class="dish-info">
            <div class="dish-meta">
                <span class="dish-cat"><%= dtype != null ? dtype : "Dish" %></span>
                <span class="dish-rating"><i class="fas fa-star"></i> 4.5</span>
            </div>
            <div class="dish-name"><%= dname %></div>
            <div class="dish-desc"><%= ddesc != null ? ddesc : "" %></div>
            <div class="dish-footer">
                <div class="dish-price">₹<%= (int)dprice %></div>
                <button class="add-btn" onclick="addToCart('<%= dname %>')">+ Add</button>
            </div>
        </div>
    </div>
    <%
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            if (rs   != null) try { rs.close();    } catch(Exception e) {}
            if (pstmt!= null) try { pstmt.close(); } catch(Exception e) {}
            if (conn != null) try { conn.close();  } catch(Exception e) {}
        }
    %>

</div><!-- /dish-grid -->

<hr class="divider">

<!-- ══════════════════════════════════════
     YOUTUBE VIDEO PLAYLIST SECTION
══════════════════════════════════════ -->
<div class="section-header reveal">
    <div class="section-label">
        <span class="eyebrow"><i class="fab fa-youtube"></i> &nbsp;Watch &amp; Cook</span>
        <h2>Food Video Playlist</h2>
    </div>
    <a href="https://www.youtube.com/@foodies" target="_blank" class="see-all">Visit Channel <i class="fas fa-arrow-right"></i></a>
</div>

<section class="playlist-section">
    <div class="playlist-grid">

        <!-- VIDEO 1: Biryani -->
        <div class="video-card reveal">
            <div class="video-thumb">
                <iframe width="560" height="315" 
                	src="https://www.youtube.com/embed/aleED1mc5kI?si=SS-ZSU8e1DpaMCSf" 
                	title="YouTube video player" frameborder="0" 
                	allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
                	referrerpolicy="strict-origin-when-cross-origin" allowfullscreen>
                </iframe>
            </div>
            <div class="video-info">
                <span class="video-tag">Biryani</span>
                <div class="video-title">Perfect Chicken Dum Biryani at Home</div>
                <div class="video-meta">
                    <span><i class="fas fa-clock"></i> 22 min</span>
                    <span><i class="fas fa-signal"></i> Intermediate</span>
                    <span><i class="fas fa-eye"></i> 4.2M views</span>
                </div>
            </div>
        </div>

        <!-- VIDEO 2: Starters -->
        <div class="video-card reveal">
            <div class="video-thumb">
                <iframe width="560" height="315" src="https://www.youtube.com/embed/SdXOUltjho4?si=BM0V6A_-RkNlDFeD" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
            </div>
            <div class="video-info">
                <span class="video-tag">Starters</span>
                <div class="video-title">Restaurant-Style Paneer Tikka — No Tandoor Needed</div>
                <div class="video-meta">
                    <span><i class="fas fa-clock"></i> 18 min</span>
                    <span><i class="fas fa-signal"></i> Easy</span>
                    <span><i class="fas fa-eye"></i> 2.8M views</span>
                </div>
            </div>
        </div>

        <!-- VIDEO 3: Seafood -->
        <div class="video-card reveal">
            <div class="video-thumb">
                <iframe width="560" height="315" src="https://www.youtube.com/embed/fEzDJ8Md0yc?si=AprVJDtbQVVs17_R" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
            </div>
            <div class="video-info">
                <span class="video-tag">Seafood</span>
                <div class="video-title">Garlic Butter Prawns in 15 Minutes</div>
                <div class="video-meta">
                    <span><i class="fas fa-clock"></i> 15 min</span>
                    <span><i class="fas fa-signal"></i> Easy</span>
                    <span><i class="fas fa-eye"></i> 1.9M views</span>
                </div>
            </div>
        </div>

        <!-- VIDEO 4: Fast Food -->
        <div class="video-card reveal">
            <div class="video-thumb">
                <iframe
                    src="https://www.youtube.com/embed/1-SJGQ2HLp8"
                    title="Homemade Pizza"
                    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                    allowfullscreen loading="lazy">
                </iframe>
            </div>
            <div class="video-info">
                <span class="video-tag">Fast Food</span>
                <div class="video-title">Perfect Homemade Pizza Dough &amp; Sauce</div>
                <div class="video-meta">
                    <span><i class="fas fa-clock"></i> 30 min</span>
                    <span><i class="fas fa-signal"></i> Intermediate</span>
                    <span><i class="fas fa-eye"></i> 5.1M views</span>
                </div>
            </div>
        </div>

        <!-- VIDEO 5: Breakfast -->
        <div class="video-card reveal">
            <div class="video-thumb">
                <iframe width="560" height="315" src="https://www.youtube.com/embed/J75VQSxOtdo?si=fYFNsZsbQjFVLKMX" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
            </div>
            <div class="video-info">
                <span class="video-tag">Breakfast</span>
                <div class="video-title">Crispy Masala Dosa — South Indian Classic</div>
                <div class="video-meta">
                    <span><i class="fas fa-clock"></i> 40 min</span>
                    <span><i class="fas fa-signal"></i> Intermediate</span>
                    <span><i class="fas fa-eye"></i> 3.4M views</span>
                </div>
            </div>
        </div>

        <!-- VIDEO 6: Chinese -->
        <div class="video-card reveal">
            <div class="video-thumb">
                <iframe width="560" height="315" src="https://www.youtube.com/embed/suXQ2mPfhSg?si=cJqQ-HRT_qwCic7w" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
            </div>
            <div class="video-info">
                <span class="video-tag">Chinese</span>
                <div class="video-title">Indo-Chinese Schezwan Fried Rice</div>
                <div class="video-meta">
                    <span><i class="fas fa-clock"></i> 20 min</span>
                    <span><i class="fas fa-signal"></i> Easy</span>
                    <span><i class="fas fa-eye"></i> 2.2M views</span>
                </div>
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
    /* ── Filter pills ── */
    const pills   = document.querySelectorAll('.pill');
    const cards   = document.querySelectorAll('.dish-card');

    pills.forEach(pill => {
        pill.addEventListener('click', () => {
            pills.forEach(p => p.classList.remove('active'));
            pill.classList.add('active');

            const filter = pill.dataset.filter;
            cards.forEach(card => {
                const match = filter === 'all' || card.dataset.category === filter;
                card.style.display = match ? '' : 'none';
            });
        });
    });

    /* ── Favourite toggle ── */
    function toggleFav(btn) {
        btn.classList.toggle('liked');
        const icon = btn.querySelector('i');
        icon.style.transform = 'scale(1.4)';
        setTimeout(() => icon.style.transform = '', 250);
    }

    /* ── Add to cart notification ── */
    function addToCart(name) {
        const toast = document.createElement('div');
        toast.textContent = `✓  "${name}" added to cart`;
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
            toast.style.opacity   = '1';
        });
        setTimeout(() => {
            toast.style.opacity   = '0';
            toast.style.transform = 'translateY(80px)';
            setTimeout(() => toast.remove(), 300);
        }, 2500);
    }

    /* ── Scroll reveal ── */
    const observer = new IntersectionObserver(entries => {
        entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
    }, { threshold: 0.12 });
    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
</script>

</body>
</html>
