<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Base64" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.db.ConnectionProvider,com.Entity.Restaurant" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurant - Foodies</title>
    <link rel="icon" href="./Images/Restaurants/download.png" type="image/icon type">
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

        * { margin: 0; padding: 0; box-sizing: border-box; }
        html { scroll-behavior: smooth; }

        body {
            background: var(--bg);
            color: var(--text);
            font-family: 'DM Sans', sans-serif;
            overflow-x: hidden;
        }

        body::before {
            content: '';
            position: fixed; inset: 0;
            background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.035'/%3E%3C/svg%3E");
            pointer-events: none; z-index: 9999; opacity: .4;
        }

        /* HEADER */
        header {
            position: sticky; top: 0; z-index: 1000;
            background: rgba(15,14,12,.92);
            backdrop-filter: blur(18px);
            border-bottom: 1px solid var(--border);
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 4rem; height: 68px;
        }
        .logo {
            display: flex; align-items: center; gap: .6rem;
            font-family: 'Playfair Display', serif;
            font-size: 1.4rem; color: var(--accent);
            text-decoration: none; font-weight: 700;
        }
        .navbar { display: flex; gap: 2rem; }
        .navbar a {
            color: var(--muted); text-decoration: none;
            font-size: .85rem; font-weight: 500;
            letter-spacing: .5px; text-transform: uppercase;
            transition: color .2s; position: relative;
        }
        .navbar a::after {
            content: ''; position: absolute; left: 0; bottom: -4px;
            width: 0; height: 1px; background: var(--accent); transition: width .3s;
        }
        .navbar a:hover, .navbar a.active { color: var(--accent); }
        .navbar a:hover::after { width: 100%; }
        .header-icons { display: flex; align-items: center; gap: 1.2rem; }
        .header-icons a { color: var(--muted); font-size: 1rem; transition: color .2s; text-decoration: none; }
        .header-icons a:hover { color: var(--accent); }
        #menu-bars { display: none; cursor: pointer; color: var(--muted); font-size: 1.2rem; }

        /* HERO BANNER */
        .hero {
            position: relative; overflow: hidden;
            min-height: 320px;
            display: flex; align-items: flex-end;
            padding: 3rem 4rem;
        }
        .hero-bg-img {
            position: absolute; inset: 0;
            background: linear-gradient(135deg, #1c1108 0%, #2a1a08 40%, #0f1c14 100%);
        }
        .hero-bg-img img {
            width: 100%; height: 100%; object-fit: cover;
            opacity: .25;
            position: absolute; inset: 0;
        }
        .hero-bg-img::after {
            content: '';
            position: absolute; inset: 0;
            background: linear-gradient(to top, rgba(15,14,12,1) 0%, rgba(15,14,12,.4) 60%, transparent 100%);
        }
        .hero-content {
            position: relative; z-index: 1;
            display: flex; align-items: flex-end; gap: 2rem; width: 100%;
        }
        .hero-logo {
            width: 100px; height: 100px;
            border-radius: 50%;
            border: 3px solid var(--accent);
            object-fit: cover;
            flex-shrink: 0;
            box-shadow: 0 0 0 6px rgba(232,160,62,.15);
        }
        .hero-text .eyebrow {
            display: inline-flex; align-items: center; gap: .5rem;
            font-size: .7rem; letter-spacing: 2px; text-transform: uppercase;
            color: var(--accent); margin-bottom: .6rem;
            background: rgba(232,160,62,.1); border: 1px solid rgba(232,160,62,.2);
            padding: .25rem .8rem; border-radius: 100px;
        }
        .hero-text h1 {
            font-family: 'Playfair Display', serif;
            font-size: clamp(2rem, 4vw, 3rem);
            font-weight: 900; line-height: 1.1;
            margin-bottom: .5rem;
        }
        .hero-text p { color: var(--muted); font-size: .9rem; }

        /* FILTER BAR */
        .filter-bar {
            padding: 2rem 4rem 1rem;
            display: flex; gap: .7rem; flex-wrap: wrap;
            align-items: center;
        }
        .filter-label {
            font-size: .7rem; letter-spacing: 2px; text-transform: uppercase;
            color: var(--muted); margin-right: .5rem;
        }
        .pill {
            padding: .4rem 1.1rem; border-radius: 100px;
            border: 1px solid var(--border); background: transparent;
            color: var(--muted); font-size: .78rem; cursor: pointer;
            font-family: 'DM Sans', sans-serif; letter-spacing: .3px;
            transition: all .2s;
        }
        .pill:hover, .pill.active {
            background: var(--accent); border-color: var(--accent);
            color: #000; font-weight: 600;
        }

        /* SECTION HEADER */
        .section-header {
            display: flex; align-items: center; justify-content: space-between;
            padding: 2rem 4rem .8rem;
        }
        .section-title {
            font-family: 'Playfair Display', serif;
            font-size: 1.5rem; font-weight: 700;
            display: flex; align-items: center; gap: .8rem;
        }
        .section-title .tag {
            font-size: .65rem; font-weight: 700; letter-spacing: 1px;
            text-transform: uppercase; color: var(--accent);
            background: rgba(232,160,62,.1); padding: .25rem .6rem;
            border-radius: 6px; font-family: 'DM Sans', sans-serif;
        }
        .item-count {
            font-size: .75rem; color: var(--muted);
        }

        /* DISH GRID */
        .dish-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 1.5rem;
            padding: 0 4rem 1rem;
        }

        .dish-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 16px; overflow: hidden;
            transition: transform .25s, border-color .25s, box-shadow .25s;
            opacity: 0; animation: fadeUp .5s ease forwards;
        }
        .dish-card:hover {
            transform: translateY(-6px);
            border-color: rgba(232,160,62,.4);
            box-shadow: 0 20px 50px rgba(0,0,0,.5), 0 0 0 1px rgba(232,160,62,.1);
        }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .dish-img {
            width: 100%; height: 190px;
            object-fit: cover;
            transition: transform .4s;
        }
        .dish-card:hover .dish-img { transform: scale(1.06); }
        .dish-img-wrap { overflow: hidden; position: relative; height: 190px; }

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
            margin-bottom: .8rem; line-height: 1.3;
        }
        .dish-footer {
            display: flex; align-items: center; justify-content: space-between;
        }
        .dish-price {
            font-size: 1.15rem; font-weight: 700; color: var(--accent);
        }
        .add-btn {
            background: var(--accent); color: #000;
            border: none; border-radius: 8px;
            padding: .45rem 1rem; font-size: .78rem; font-weight: 700;
            cursor: pointer; letter-spacing: .3px;
            transition: background .2s, transform .15s;
            font-family: 'DM Sans', sans-serif;
        }
        .add-btn:hover { background: #f5b04a; transform: scale(1.05); }

        /* EMPTY STATE */
        .empty-state {
            padding: 3rem; text-align: center;
            color: var(--muted); font-size: .9rem;
            border: 1px dashed var(--border);
            border-radius: 16px; margin: 0 4rem 2rem;
        }
        .empty-state i { font-size: 2rem; color: var(--border); margin-bottom: 1rem; display: block; }

        /* DIVIDER */
        .section-divider {
            margin: .5rem 4rem;
            border: none; border-top: 1px solid var(--border);
        }

        /* FOOTER */
        .footer {
            background: var(--surface);
            border-top: 1px solid var(--border);
            padding: 3rem 4rem 2rem;
            margin-top: 3rem;
        }
        .footer .row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 2rem; padding-bottom: 2rem;
            border-bottom: 1px solid var(--border);
        }
        .footer-col h4 {
            font-size: .7rem; letter-spacing: 2px; text-transform: uppercase;
            color: var(--accent); margin-bottom: 1rem; font-weight: 600;
        }
        .footer-col ul { list-style: none; }
        .footer-col ul li { margin-bottom: .5rem; }
        .footer-col ul li a {
            color: var(--muted); text-decoration: none;
            font-size: .82rem; transition: color .2s;
        }
        .footer-col ul li a:hover { color: var(--text); }
        .social-links { display: flex; gap: .7rem; }
        .social-links a {
            width: 34px; height: 34px; border-radius: 8px;
            border: 1px solid var(--border);
            display: flex; align-items: center; justify-content: center;
            color: var(--muted); text-decoration: none; transition: all .2s;
        }
        .social-links a:hover { border-color: var(--accent); color: var(--accent); }
        .footer-bottom {
            padding-top: 1.5rem;
            display: flex; justify-content: space-between;
            font-size: .75rem; color: var(--muted);
        }
        .brand-name {
            font-family: 'Playfair Display', serif;
            font-size: 1.1rem; color: var(--accent);
        }

        /* TOAST */
        .toast {
            position: fixed; bottom: 28px; right: 28px;
            background: var(--accent); color: #000;
            padding: .75rem 1.3rem; border-radius: 10px;
            font-weight: 600; font-size: .82rem;
            z-index: 9000; box-shadow: 0 8px 30px rgba(0,0,0,.4);
            transform: translateY(80px); opacity: 0;
            transition: all .3s;
        }
        .toast.show { transform: translateY(0); opacity: 1; }

        /* ABOUT MODAL */
        .about {
            position: fixed; top: 0; right: -100%;
            width: 100%; height: 100%;
            background: rgba(15,14,12,.98);
            backdrop-filter: blur(20px);
            z-index: 10001; transition: right .4s; overflow-y: auto;
        }
        .about.active { right: 0; }
        .about .closebtn {
            position: absolute; top: 2rem; right: 3rem;
            font-size: 3rem; color: var(--text); text-decoration: none;
        }
        .about-overlay { padding: 5rem 10%; max-width: 900px; margin: 0 auto; }
        .about-overlay h1 {
            font-family: 'Playfair Display', serif;
            font-size: 3rem; color: var(--accent); margin-bottom: 2rem;
        }
        .about-overlay p { font-size: 1.1rem; line-height: 1.8; color: var(--muted); }

        /* SEARCH */
        #search-form {
            position: fixed; top: -120%; left: 0;
            width: 100%; height: 100%;
            background: rgba(15,14,12,.95); backdrop-filter: blur(20px);
            display: flex; align-items: center; justify-content: center;
            z-index: 10000; transition: top .3s;
        }
        #search-form.active { top: 0; }
        #search-form input {
            width: 50%; padding: 1rem 2rem;
            background: var(--surface); border: 2px solid var(--border);
            border-radius: 50px; color: var(--text); font-size: 1.2rem; outline: none;
        }
        #search-form input:focus { border-color: var(--accent); }
        #search-form label { color: var(--accent); font-size: 2rem; margin-left: 1rem; cursor: pointer; }
        #search-form #close1 {
            position: absolute; top: 2rem; right: 3rem;
            font-size: 3rem; color: var(--text); cursor: pointer;
        }

        /* RESPONSIVE */
        @media (max-width: 900px) {
            header { padding: 0 1.5rem; }
            .navbar { display: none; }
            #menu-bars { display: block; }
            .navbar.active {
                display: flex; flex-direction: column;
                position: fixed; top: 68px; left: 0;
                width: 280px; height: calc(100vh - 68px);
                background: rgba(26,24,21,.98);
                backdrop-filter: blur(20px);
                padding: 2rem; border-right: 1px solid var(--border);
                gap: 1.5rem;
            }
            .hero { padding: 2rem 1.5rem; }
            .filter-bar, .section-header, .dish-grid,
            .empty-state, .section-divider, .footer { padding-left: 1.5rem; padding-right: 1.5rem; }
            .dish-grid { grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); }
        }
        @media (max-width: 500px) {
            .dish-grid { grid-template-columns: 1fr; }
            .hero-content { flex-direction: column; align-items: flex-start; gap: 1rem; }
        }
    </style>
</head>
<body>

<%
    String user_id = (String) session.getAttribute("user_id");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    Restaurant rest = new Restaurant();

    try {
        conn = ConnectionProvider.getConnection();
        String id = request.getParameter("id");
        String sql = "SELECT * FROM restaurants WHERE restaurant_id = " + id;
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            rest.id = rs.getInt("restaurant_id");
            rest.name = rs.getString("restaurant_name");
            rest.description = rs.getString("description");
            rest.createdOn = rs.getTimestamp("created_on");
            byte[] img1 = rs.getBytes("restaurant_image");
            byte[] img2 = rs.getBytes("restaurant_logo");
            rest.restaurantImage = (img1 != null) ? Base64.getEncoder().encodeToString(img1) : "";
            rest.restaurantLogo  = (img2 != null) ? Base64.getEncoder().encodeToString(img2) : "";
        }
    } catch (Exception ex) {
        ex.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>

<!-- HEADER -->
<header>
    <a href="./index.jsp" class="logo"><i class="fa fa-utensils"></i> Foodies.</a>
    <nav class="navbar" id="navbar">
        <a href="./index.jsp">Home</a>
        <a href="./dishes.jsp">Dishes</a>
        <a href="#" onclick="openAbout()">About</a>
        <a href="./contact.jsp">Contact</a>
        <a href="cart.jsp?id=<%=user_id%>">My Cart</a>
        <a href="orders.jsp?id=<%=user_id%>">Orders</a>
    </nav>
    <div class="header-icons">
        <i class="fas fa-bars" id="menu-bars"></i>
        <a href="#" onclick="document.getElementById('search-form').classList.add('active')">
            <i class="fas fa-search"></i>
        </a>
        <a href="login.jsp"><i class="fas fa-sign-in-alt"></i></a>
    </div>
</header>

<!-- SEARCH -->
<form action="" id="search-form">
    <input type="search" placeholder="Search here..." id="search-box">
    <label for="search-box" class="fas fa-search"></label>
    <i class="fas fa-times" id="close1" onclick="document.getElementById('search-form').classList.remove('active')"></i>
</form>

<!-- HERO -->
<section class="hero">
    <div class="hero-bg-img">
        <% if (!rest.restaurantImage.isEmpty()) { %>
        <img src="data:image/jpeg;base64,<%=rest.restaurantImage%>" alt="<%=rest.name%>">
        <% } %>
    </div>
    <div class="hero-content">
        <% if (!rest.restaurantLogo.isEmpty()) { %>
        <img class="hero-logo" src="data:image/jpeg;base64,<%=rest.restaurantLogo%>" alt="logo">
        <% } %>
        <div class="hero-text">
            <div class="eyebrow"><i class="fas fa-utensils"></i> Restaurant Menu</div>
            <h1><%=rest.name%></h1>
            <p><%=rest.description != null ? rest.description : "Explore our delicious menu" %></p>
        </div>
    </div>
</section>

<!-- FILTER PILLS -->
<div class="filter-bar">
    <span class="filter-label">Filter:</span>
    <button class="pill active" data-filter="all">All Items</button>
    <button class="pill" data-filter="biryani">🍚 Biryani</button>
    <button class="pill" data-filter="starter">🍗 Starters</button>
    <button class="pill" data-filter="roti">🫓 Roti's</button>
    <button class="pill" data-filter="curry">🍛 Curry's</button>
</div>

<%
    // Helper method — fetch foods by category
    String[] categories   = {"biryani", "starter", "roti", "curry"};
    String[] catLabels    = {"Biryani's", "Starters", "Roti's", "Curry's"};
    String[] catIcons     = {"🍚", "🍗", "🫓", "🍛"};

    for (int c = 0; c < categories.length; c++) {
        String cat = categories[c];
        String label = catLabels[c];
        String icon  = catIcons[c];

        // Count items
        Connection cConn = ConnectionProvider.getConnection();
        PreparedStatement cPs = cConn.prepareStatement(
            "SELECT COUNT(*) FROM foods WHERE restaurant_id = ? AND category = ?");
        cPs.setInt(1, rest.id);
        cPs.setString(2, cat);
        ResultSet cRs = cPs.executeQuery();
        int count = 0;
        if (cRs.next()) count = cRs.getInt(1);
        cRs.close(); cPs.close(); cConn.close();
%>

<!-- SECTION: <%=label%> -->
<div class="section-header" data-section="<%=cat%>">
    <div class="section-title">
        <%=icon%> <%=label%>
        <span class="tag"><%=count%> items</span>
    </div>
</div>

<% if (count == 0) { %>
<div class="empty-state" data-section="<%=cat%>">
    <i class="fas fa-bowl-food"></i>
    No <%=label.toLowerCase()%> available at this restaurant yet.
</div>
<% } else { %>

<div class="dish-grid" data-section="<%=cat%>">
<%
        Connection dConn = ConnectionProvider.getConnection();
        PreparedStatement dPs = dConn.prepareStatement(
            "SELECT * FROM foods WHERE restaurant_id = ? AND category = ?");
        dPs.setInt(1, rest.id);
        dPs.setString(2, cat);
        ResultSet dRs = dPs.executeQuery();
        int delay = 0;
        while (dRs.next()) {
            int    foodId   = dRs.getInt("food_id");
            String foodName = dRs.getString("food_name");
            double price    = dRs.getDouble("price");
            Blob   blob     = dRs.getBlob("food_profile");
            String enc      = "";
            if (blob != null) enc = Base64.getEncoder().encodeToString(blob.getBytes(1,(int)blob.length()));
            delay += 80;
%>
    <div class="dish-card" data-category="<%=cat%>" style="animation-delay:<%=delay%>ms">
        <div class="dish-img-wrap">
            <img class="dish-img"
                 src="<%=enc.isEmpty() ? "./Images/Dishes/default.jpg" : "data:image/jpeg;base64," + enc%>"
                 alt="<%=foodName%>">
        </div>
        <div class="dish-info">
            <div class="dish-meta">
                <span class="dish-cat"><%=label%></span>
                <span class="dish-rating"><i class="fas fa-star"></i> 4.5</span>
            </div>
            <div class="dish-name"><%=foodName%></div>
            <div class="dish-footer">
                <div class="dish-price">&#8377;<%=price%></div>
                <form id="addToCartForm<%=foodId%>" action="AddToCartServlet" method="post" style="display:inline">
                    <input type="hidden" name="foodId" value="<%=foodId%>">
                    <button type="button" class="add-btn" onclick="addToCart('<%=foodId%>', '<%=foodName%>')">+ Add</button>
                </form>
            </div>
        </div>
    </div>
<%
        }
        dRs.close(); dPs.close(); dConn.close();
%>
</div>

<% } %>

<hr class="section-divider">

<% } // end for loop %>

<!-- ABOUT MODAL -->
<div id="about" class="about">
    <a href="#" class="closebtn" onclick="closeNav()">&times;</a>
    <div class="about-overlay">
        <h1>About Us</h1>
        <p>Launched in 2021, our technology platform connects customers, restaurant partners and delivery partners, serving their multiple needs. Customers use our platform to search and discover restaurants, order food delivery, book a table and make payments while dining-out.</p>
    </div>
</div>

<!-- FOOTER -->
<footer class="footer">
    <div class="row">
        <div class="footer-col">
            <div class="brand-name">🍴 Foodies.</div>
            <p style="color:var(--muted);font-size:.82rem;margin-top:.5rem;line-height:1.6">
                5th Floor, Patia, Bhubaneswar, Odisha - 751021<br>support@foodies.com
            </p>
        </div>
        <div class="footer-col">
            <h4>Foodies</h4>
            <ul>
                <li><a href="#">About Us</a></li>
                <li><a href="#">Our Services</a></li>
                <li><a href="#">Privacy Policy</a></li>
                <li><a href="#">Payment Policy</a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h4>Get Help</h4>
            <ul>
                <li><a href="#">FAQ</a></li>
                <li><a href="#">Delivery</a></li>
                <li><a href="orders.jsp?id=<%=user_id%>">My Orders</a></li>
                <li><a href="#">Order Status</a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h4>Follow Us</h4>
            <div class="social-links">
                <a href="#"><i class="fab fa-facebook-f"></i></a>
                <a href="#"><i class="fab fa-twitter"></i></a>
                <a href="#"><i class="fab fa-instagram"></i></a>
                <a href="#"><i class="fab fa-linkedin-in"></i></a>
            </div>
        </div>
    </div>
    <div class="footer-bottom">
        <span>&copy; 2024 Foodies. All rights reserved.</span>
        <span>Made with ❤️ in Bhubaneswar</span>
    </div>
</footer>

<!-- TOAST -->
<div class="toast" id="toast"></div>

<!-- JS -->
<script>
    // Filter pills
    const pills = document.querySelectorAll('.pill');
    pills.forEach(pill => {
        pill.addEventListener('click', () => {
            pills.forEach(p => p.classList.remove('active'));
            pill.classList.add('active');
            const filter = pill.dataset.filter;
            document.querySelectorAll('[data-section]').forEach(el => {
                if (filter === 'all' || el.dataset.section === filter) {
                    el.style.display = '';
                } else {
                    el.style.display = 'none';
                }
            });
        });
    });

    // Add to cart
    function addToCart(foodId, name) {
        var form = document.getElementById("addToCartForm" + foodId);
        var formData = new FormData(form);
        var xhr = new XMLHttpRequest();
        xhr.open("POST", form.action, true);
        xhr.onload = function() {
            if (xhr.status === 200) showToast('✓ "' + name + '" added to cart!');
        };
        xhr.send(formData);
    }

    function showToast(msg) {
        const t = document.getElementById('toast');
        t.textContent = msg;
        t.classList.add('show');
        setTimeout(() => t.classList.remove('show'), 2500);
    }

    // Mobile menu
    document.getElementById('menu-bars').addEventListener('click', function() {
        document.getElementById('navbar').classList.toggle('active');
    });

    // About modal
    function openAbout() { document.getElementById('about').classList.add('active'); }
    function closeNav()   { document.getElementById('about').classList.remove('active'); }
</script>

</body>
</html>