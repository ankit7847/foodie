<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, java.io.*, java.util.Base64" %>
<%@ page import="com.db.ConnectionProvider" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Cart - Foodies</title>
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

        body::before {
            content: '';
            position: fixed; inset: 0;
            background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.035'/%3E%3C/svg%3E");
            pointer-events: none; z-index: 9999; opacity: .4;
        }

        /* --- HEADER --- */
        header {
            position: sticky; top: 0; z-index: 100;
            background: rgba(15,14,12,.92);
            backdrop-filter: blur(18px);
            border-bottom: 1px solid var(--border);
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 4rem; height: 68px;
        }

        .logo { display: flex; align-items: center; gap: .6rem; text-decoration: none; }
        .logo span {
            font-family: 'Playfair Display', serif;
            font-size: 1.4rem; color: var(--accent); letter-spacing: .5px;
        }

        .navbar { display: flex; gap: 2rem; }
        .navbar a {
            color: var(--muted); text-decoration: none;
            font-size: .85rem; font-weight: 500; letter-spacing: .5px;
            text-transform: uppercase; transition: color .2s; position: relative;
        }
        .navbar a::after {
            content: ''; position: absolute; left: 0; bottom: -4px;
            width: 0; height: 1px; background: var(--accent); transition: width .3s;
        }
        .navbar a:hover, .navbar a.active { color: var(--accent); }
        .navbar a:hover::after, .navbar a.active::after { width: 100%; }

        .header-icons { display: flex; align-items: center; gap: 1.2rem; }
        .header-icons a { color: var(--muted); font-size: 1rem; transition: color .2s; }
        .header-icons a:hover { color: var(--accent); }

        /* --- HERO --- */
        .hero {
            position: relative; overflow: hidden;
            min-height: 260px;
            display: flex; align-items: center;
            padding: 4rem 4rem;
        }
        .hero-bg {
            position: absolute; inset: 0;
            background: linear-gradient(135deg, #1c1108 0%, #2a1a08 40%, #0f1c14 100%);
        }
        .hero-bg::after {
            content: ''; position: absolute; inset: 0;
            background: radial-gradient(ellipse 60% 80% at 70% 50%, rgba(232,160,62,.1), transparent),
                        radial-gradient(ellipse 40% 60% at 10% 80%, rgba(196,92,46,.07), transparent);
        }
        .hero-deco {
            position: absolute; right: -80px; top: -80px;
            width: 500px; height: 500px; border-radius: 50%;
            border: 1px solid rgba(232,160,62,.07); pointer-events: none;
        }
        .hero-deco::before {
            content: ''; position: absolute; inset: 40px;
            border-radius: 50%; border: 1px solid rgba(232,160,62,.05);
        }
        .hero-content { position: relative; z-index: 1; }
        .hero-eyebrow {
            display: inline-flex; align-items: center; gap: .5rem;
            font-size: .72rem; letter-spacing: 2px; text-transform: uppercase;
            color: var(--accent); margin-bottom: 1rem;
            background: rgba(232,160,62,.1); border: 1px solid rgba(232,160,62,.2);
            padding: .3rem .8rem; border-radius: 100px;
        }
        .hero h1 {
            font-family: 'Playfair Display', serif;
            font-size: clamp(2rem, 4vw, 3rem);
            line-height: 1.1; font-weight: 900; margin-bottom: .6rem;
        }
        .hero h1 em {
            font-style: normal;
            background: linear-gradient(90deg, var(--accent), var(--accent2));
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }
        .hero p { color: var(--muted); font-size: .9rem; line-height: 1.7; }

        /* --- SCROLL REVEAL --- */
        .reveal {
            opacity: 0; transform: translateY(24px);
            transition: opacity .5s ease, transform .5s ease;
        }
        .reveal.visible { opacity: 1; transform: translateY(0); }

        /* --- MAIN LAYOUT --- */
        .cart-layout {
            display: grid;
            grid-template-columns: 1fr 360px;
            gap: 2rem;
            max-width: 1200px;
            margin: 0 auto;
            padding: 3rem 4rem 5rem;
            align-items: start;
        }

        /* --- SECTION EYEBROW --- */
        .section-eyebrow {
            font-size: .68rem; letter-spacing: 2.5px; text-transform: uppercase;
            color: var(--accent); font-weight: 600; margin-bottom: 1.2rem;
            display: flex; align-items: center; gap: .4rem;
        }

        /* --- SUMMARY STATS --- */
        .stats-row {
            display: grid; grid-template-columns: repeat(3, 1fr);
            gap: 1rem; margin-bottom: 2rem;
        }
        .stat-card {
            background: var(--card); border: 1px solid var(--border);
            border-radius: 14px; padding: 1rem 1.2rem;
        }
        .stat-label {
            font-size: .68rem; letter-spacing: 1.5px; text-transform: uppercase;
            color: var(--muted); margin-bottom: .3rem;
        }
        .stat-value {
            font-size: 1.4rem; font-weight: 700; color: var(--text);
        }
        .stat-value.accent { color: var(--accent); }

        /* --- CART ITEMS --- */
        .cart-items { display: flex; flex-direction: column; gap: 1rem; }

        .cart-item {
            background: var(--card); border: 1px solid var(--border);
            border-radius: 14px; padding: 1.1rem 1.3rem;
            display: flex; align-items: center; gap: 1.2rem;
            transition: border-color .25s, box-shadow .25s;
        }
        .cart-item:hover {
            border-color: rgba(232,160,62,.3);
            box-shadow: 0 8px 30px rgba(0,0,0,.3);
        }

        .item-img {
            width: 72px; height: 72px; border-radius: 10px;
            object-fit: cover; flex-shrink: 0; background: var(--tag-bg);
        }
        .item-img-placeholder {
            width: 72px; height: 72px; border-radius: 10px;
            background: var(--tag-bg); border: 1px solid var(--border);
            display: flex; align-items: center; justify-content: center;
            color: var(--muted); font-size: 1.4rem; flex-shrink: 0;
        }

        .item-details { flex: 1; min-width: 0; }
        .item-name {
            font-size: .95rem; font-weight: 600; margin-bottom: .2rem;
            white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
        }
        .item-sub {
            font-size: .78rem; color: var(--muted); margin-bottom: .5rem;
        }
        .item-controls { display: flex; align-items: center; gap: .8rem; }

        .qty-wrap {
            display: flex; align-items: center; gap: .4rem;
            background: var(--surface); border: 1px solid var(--border);
            border-radius: 8px; padding: .2rem .4rem;
        }
        .qty-btn {
            width: 24px; height: 24px; border-radius: 5px;
            border: none; background: none; color: var(--muted);
            cursor: pointer; font-size: 1rem; line-height: 1;
            display: flex; align-items: center; justify-content: center;
            transition: color .2s;
        }
        .qty-btn:hover { color: var(--accent); }
        .qty-num { font-size: .85rem; font-weight: 600; min-width: 18px; text-align: center; }

        .remove-btn {
            background: none; border: none; color: var(--muted);
            font-size: .75rem; cursor: pointer; padding: .3rem .55rem;
            border-radius: 6px; transition: all .2s; font-family: inherit;
            display: flex; align-items: center; gap: .3rem;
        }
        .remove-btn:hover { color: var(--red); background: rgba(217,79,56,.1); }

        .item-price {
            font-size: 1rem; font-weight: 700; color: var(--accent);
            white-space: nowrap; flex-shrink: 0;
        }

        /* --- EMPTY STATE --- */
        .empty-cart {
            text-align: center; padding: 4rem 2rem;
            color: var(--muted); background: var(--card);
            border: 1px solid var(--border); border-radius: 16px;
        }
        .empty-cart i { font-size: 2.5rem; margin-bottom: 1rem; opacity: .4; display: block; }
        .empty-cart p { font-size: .9rem; margin-bottom: 1.2rem; }
        .browse-btn {
            display: inline-flex; align-items: center; gap: .5rem;
            background: var(--accent); color: #000;
            border: none; border-radius: 8px; padding: .6rem 1.2rem;
            font-family: inherit; font-size: .85rem; font-weight: 700;
            cursor: pointer; text-decoration: none; transition: background .2s;
        }
        .browse-btn:hover { background: #f5b04a; }

        /* --- ORDER SUMMARY SIDEBAR --- */
        .order-summary {
            background: var(--card); border: 1px solid var(--border);
            border-radius: 18px; padding: 1.6rem 1.4rem;
            position: sticky; top: 88px;
        }
        .summary-title {
            font-family: 'Playfair Display', serif;
            font-size: 1.2rem; font-weight: 700; margin-bottom: 1.4rem;
        }
        .summary-row {
            display: flex; justify-content: space-between; align-items: center;
            font-size: .83rem; color: var(--muted); margin-bottom: .65rem;
        }
        .summary-row.total {
            font-size: .95rem; font-weight: 700; color: var(--text);
            border-top: 1px solid var(--border); padding-top: .85rem; margin-top: .4rem;
        }
        .promo-wrap { margin: 1.2rem 0; }
        .promo-input {
            width: 100%; background: var(--surface); border: 1px solid var(--border);
            border-radius: 8px; color: var(--text); font-family: 'DM Sans', sans-serif;
            font-size: .82rem; padding: .6rem .9rem; outline: none;
            transition: border-color .2s;
        }
        .promo-input::placeholder { color: #4a4540; }
        .promo-input:focus { border-color: var(--accent); }
        .promo-btn {
            width: 100%; margin-top: .5rem; background: none;
            border: 1px solid var(--border); border-radius: 8px;
            color: var(--muted); font-family: 'DM Sans', sans-serif;
            font-size: .8rem; font-weight: 600; padding: .55rem;
            cursor: pointer; transition: all .2s;
        }
        .promo-btn:hover { border-color: var(--accent); color: var(--accent); }

        .checkout-btn {
            width: 100%; margin-top: 1.3rem;
            background: var(--accent); color: #000;
            border: none; border-radius: 10px; padding: .9rem;
            font-family: 'DM Sans', sans-serif; font-size: .9rem;
            font-weight: 700; cursor: pointer;
            display: flex; align-items: center; justify-content: center; gap: .6rem;
            transition: background .2s, transform .15s, box-shadow .2s;
        }
        .checkout-btn:hover {
            background: #f5b04a; transform: translateY(-2px);
            box-shadow: 0 8px 28px rgba(232,160,62,.3);
        }
        .checkout-btn:active { transform: translateY(0); }
        .checkout-btn:disabled { opacity: .5; cursor: not-allowed; transform: none; }

        .secure-note {
            display: flex; align-items: center; justify-content: center; gap: .4rem;
            font-size: .72rem; color: var(--muted); margin-top: .8rem;
        }

        /* --- DIVIDER --- */
        .divider { margin: 0 4rem; border: none; border-top: 1px solid var(--border); }

        /* --- FOOTER --- */
        footer {
            background: var(--surface); border-top: 1px solid var(--border);
            padding: 2rem 4rem; margin-top: 2rem;
        }
        .footer-bottom {
            display: flex; align-items: center; justify-content: space-between;
            font-size: .75rem; color: var(--muted);
        }

        /* --- RESPONSIVE --- */
        @media (max-width: 900px) {
            header { padding: 0 1.5rem; }
            .navbar { display: none; }
            .hero { padding: 3rem 1.5rem; }
            .cart-layout { grid-template-columns: 1fr; padding: 2rem 1.5rem 3rem; }
            .order-summary { position: static; }
            .stats-row { grid-template-columns: repeat(3, 1fr); }
            footer { padding: 1.5rem; }
            .divider { margin: 0 1.5rem; }
        }
        @media (max-width: 500px) {
            .stats-row { grid-template-columns: 1fr 1fr; }
        }
    </style>
</head>

<%
    String user_id = (String) session.getAttribute("user_id");
%>

<body>

<!-- HEADER -->
<header>
    <a href="./index.jsp" class="logo">
        <i class="fa fa-utensils" style="color:var(--accent)"></i>
        <span>Foodies.</span>
    </a>
    <nav class="navbar">
        <a href="./index.jsp">Home</a>
        <a href="./food_types.jsp">Food Types</a>
        <a href="./contact.jsp">Contact Us</a>
        <a class="active" href="cart.jsp?id=<%= user_id %>">My Cart</a>
        <a href="orders.jsp?id=<%= user_id %>">Orders</a>
    </nav>
    <div class="header-icons">
        <a href="#"><i class="fas fa-search"></i></a>
        <a href="#"><i class="fas fa-heart"></i></a>
        <a href="login.jsp"><i class="fas fa-sign-in-alt"></i></a>
    </div>
</header>

<!-- HERO -->
<section class="hero">
    <div class="hero-bg"></div>
    <div class="hero-deco"></div>
    <div class="hero-content reveal">
        <div class="hero-eyebrow"><i class="fas fa-shopping-cart"></i> Ready to order?</div>
        <h1>My <em>Cart</em></h1>
        <p>Review your selection and proceed when you're ready.</p>
    </div>
</section>

<!-- MAIN CONTENT -->
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    double totalAmount = 0;
    int itemCount = 0;
    int userId = Integer.parseInt((String) session.getAttribute("user_id"));
    boolean hasItems = false;

    try {
        conn = ConnectionProvider.getConnection();
        String sql = "SELECT c.cart_id, c.quantity, f.food_name, f.price, f.food_profile " +
                     "FROM carts c JOIN foods f ON c.food_id = f.food_id WHERE c.user_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, userId);
        rs = pstmt.executeQuery();

        java.util.List<java.util.Map<String, Object>> items = new java.util.ArrayList<>();
        while (rs.next()) {
            java.util.Map<String, Object> item = new java.util.HashMap<>();
            item.put("cartId", rs.getInt("cart_id"));
            item.put("quantity", rs.getInt("quantity"));
            item.put("foodName", rs.getString("food_name"));
            item.put("price", rs.getDouble("price"));
            Blob blob = rs.getBlob("food_profile");
            String encodedImage = null;
            if (blob != null) {
                byte[] imageData = blob.getBytes(1, (int) blob.length());
                encodedImage = Base64.getEncoder().encodeToString(imageData);
            }
            item.put("encodedImage", encodedImage);
            totalAmount += rs.getDouble("price") * rs.getInt("quantity");
            itemCount++;
            items.add(item);
        }
        hasItems = !items.isEmpty();

        double delivery = hasItems ? 2.00 : 0;
        double tax = totalAmount * 0.05;
        double grandTotal = totalAmount + delivery + tax;
%>

<div class="cart-layout">

    <!-- LEFT COLUMN -->
    <div>
        <div class="section-eyebrow reveal">
            <i class="fas fa-list-ul"></i> Your items
        </div>

        <div class="stats-row reveal">
            <div class="stat-card">
                <div class="stat-label">Items</div>
                <div class="stat-value"><%= itemCount %></div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Subtotal</div>
                <div class="stat-value accent">&#8377;<%= String.format("%.2f", totalAmount) %></div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Delivery</div>
                <div class="stat-value">&#8377;<%= String.format("%.2f", delivery) %></div>
            </div>
        </div>

        <% if (!hasItems) { %>
        <div class="empty-cart reveal">
            <i class="fas fa-shopping-cart"></i>
            <p>Your cart is empty. Let's fix that!</p>
            <a href="./food_types.jsp" class="browse-btn">
                <i class="fas fa-utensils"></i> Browse Food
            </a>
        </div>
        <% } else { %>
        <div class="cart-items">
        <%
            for (java.util.Map<String, Object> item : items) {
                int cartId = (int) item.get("cartId");
                int quantity = (int) item.get("quantity");
                String foodName = (String) item.get("foodName");
                double price = (double) item.get("price");
                String encodedImage = (String) item.get("encodedImage");
        %>
            <div class="cart-item reveal">
                <% if (encodedImage != null) { %>
                    <img src="data:image/jpeg;base64,<%= encodedImage %>" class="item-img" alt="<%= foodName %>">
                <% } else { %>
                    <div class="item-img-placeholder"><i class="fas fa-utensils"></i></div>
                <% } %>
                <div class="item-details">
                    <div class="item-name"><%= foodName %></div>
                    <div class="item-sub">Unit price: &#8377;<%= String.format("%.2f", price) %></div>
                    <div class="item-controls">
                        <div class="qty-wrap">
                            <button class="qty-btn">&#8722;</button>
                            <span class="qty-num"><%= quantity %></span>
                            <button class="qty-btn">&#43;</button>
                        </div>
                        <a href="/FDelivery/RemoveFromCartServlet?cartId=<%= cartId %>" class="remove-btn">
                            <i class="fas fa-trash-alt"></i> Remove
                        </a>
                    </div>
                </div>
                <div class="item-price">&#8377;<%= String.format("%.2f", price * quantity) %></div>
            </div>
        <%
            }
        %>
        </div>
        <% } %>
    </div>

    <!-- RIGHT COLUMN: Order Summary -->
    <div class="order-summary reveal">
        <div class="summary-title">Order Summary</div>

        <div class="summary-row"><span>Subtotal</span><span>&#8377;<%= String.format("%.2f", totalAmount) %></span></div>
        <div class="summary-row"><span>Delivery fee</span><span>&#8377;<%= String.format("%.2f", delivery) %></span></div>
        <div class="summary-row"><span>Taxes (5%)</span><span>&#8377;<%= String.format("%.2f", tax) %></span></div>
        <div class="summary-row total"><span>Total</span><span>&#8377;<%= String.format("%.2f", grandTotal) %></span></div>

        <div class="promo-wrap">
            <input type="text" class="promo-input" placeholder="Promo code&#8230;">
            <button class="promo-btn">Apply Code</button>
        </div>

        <form action="payment.jsp" method="get">
            <button type="submit" class="checkout-btn" <%= !hasItems ? "disabled" : "" %>>
                <i class="fas fa-lock"></i> Proceed to Checkout
            </button>
        </form>

        <div class="secure-note">
            <i class="fas fa-shield-alt" style="color:var(--green);font-size:.7rem"></i>
            Secure & encrypted checkout
        </div>
    </div>

</div>

<%
    } catch (Exception ex) {
        ex.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
%>

<hr class="divider">

<footer>
    <div class="footer-bottom">
        <span style="display:flex;align-items:center;gap:.5rem;">
            <i class="fa fa-utensils" style="color:var(--accent)"></i>
            <span style="font-family:'Playfair Display',serif;color:var(--accent);">Foodies.</span>
        </span>
        <span>&copy; 2024 Foodies. All rights reserved.</span>
        <span>Made with <i class="fas fa-heart" style="color:var(--red);font-size:.65rem"></i> in Bhubaneswar</span>
    </div>
</footer>

<script>
    const observer = new IntersectionObserver(entries => {
        entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
    }, { threshold: 0.1 });
    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
</script>

</body>
</html>
