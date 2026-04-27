<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.util.Base64" %>
<%@ page import="com.db.ConnectionProvider" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout – Foodies</title>
    <link rel="icon" href="./Images/Restaurants/download.png" type="image/icon type">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg:       #0f0e0c;
            --surface:  #1a1815;
            --card:     #211f1c;
            --border:   #2e2b27;
            --accent:   #e8a03e;
            --accent2:  #c45c2e;
            --text:     #f0ebe3;
            --muted:    #8a8278;
            --tag-bg:   #2a2520;
            --red:      #d94f38;
            --green:    #5a9a6f;
            --green-bg: rgba(90,154,111,.12);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        html { scroll-behavior: smooth; }

        body {
            background: var(--bg);
            color: var(--text);
            font-family: 'DM Sans', sans-serif;
            overflow-x: hidden;
            min-height: 100vh;
        }

        body::before {
            content: '';
            position: fixed; inset: 0;
            background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.035'/%3E%3C/svg%3E");
            pointer-events: none; z-index: 9999; opacity: .4;
        }

        /* HEADER */
        header {
            position: sticky; top: 0; z-index: 100;
            background: rgba(15,14,12,.92);
            backdrop-filter: blur(18px);
            border-bottom: 1px solid var(--border);
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 4rem; height: 68px;
        }
        .logo { display: flex; align-items: center; gap: .6rem; text-decoration: none; }
        .logo span { font-family: 'Playfair Display', serif; font-size: 1.4rem; color: var(--accent); letter-spacing: .5px; }
        .back-link { display: flex; align-items: center; gap: .5rem; color: var(--muted); text-decoration: none; font-size: .83rem; font-weight: 500; transition: color .2s; }
        .back-link:hover { color: var(--accent); }

        /* PROGRESS BAR */
        .progress-bar { background: var(--surface); border-bottom: 1px solid var(--border); padding: 1rem 4rem; }
        .progress-steps { display: flex; align-items: center; gap: 0; max-width: 560px; margin: 0 auto; }
        .step { display: flex; align-items: center; gap: .5rem; font-size: .75rem; font-weight: 600; letter-spacing: .5px; text-transform: uppercase; color: var(--muted); }
        .step.done { color: var(--green); }
        .step.active { color: var(--accent); }
        .step-dot { width: 28px; height: 28px; border-radius: 50%; border: 2px solid var(--border); display: flex; align-items: center; justify-content: center; font-size: .7rem; font-weight: 700; flex-shrink: 0; background: var(--card); }
        .step.done .step-dot { border-color: var(--green); background: var(--green-bg); color: var(--green); }
        .step.active .step-dot { border-color: var(--accent); background: rgba(232,160,62,.12); color: var(--accent); }
        .step-line { flex: 1; height: 1px; background: var(--border); margin: 0 .6rem; }
        .step.done + .step-line { background: var(--green); }

        /* HERO */
        .hero { position: relative; overflow: hidden; padding: 3rem 4rem 2.5rem; }
        .hero-bg { position: absolute; inset: 0; background: linear-gradient(135deg, #1c1108 0%, #2a1a08 40%, #0f1c14 100%); }
        .hero-bg::after { content: ''; position: absolute; inset: 0; background: radial-gradient(ellipse 60% 80% at 70% 50%, rgba(232,160,62,.08), transparent), radial-gradient(ellipse 40% 60% at 10% 80%, rgba(196,92,46,.06), transparent); }
        .hero-content { position: relative; z-index: 1; }
        .hero-eyebrow { display: inline-flex; align-items: center; gap: .5rem; font-size: .72rem; letter-spacing: 2px; text-transform: uppercase; color: var(--accent); margin-bottom: .8rem; background: rgba(232,160,62,.1); border: 1px solid rgba(232,160,62,.2); padding: .3rem .8rem; border-radius: 100px; }
        .hero h1 { font-family: 'Playfair Display', serif; font-size: clamp(1.8rem, 3.5vw, 2.6rem); font-weight: 900; line-height: 1.1; }
        .hero h1 em { font-style: normal; background: linear-gradient(90deg, var(--accent), var(--accent2)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .hero p { color: var(--muted); font-size: .87rem; line-height: 1.7; margin-top: .4rem; }

        /* REVEAL */
        .reveal { opacity: 0; transform: translateY(20px); transition: opacity .5s ease, transform .5s ease; }
        .reveal.visible { opacity: 1; transform: translateY(0); }

        /* LAYOUT */
        .checkout-layout { display: grid; grid-template-columns: 1fr 340px; gap: 2rem; max-width: 1100px; margin: 0 auto; padding: 2.5rem 4rem 5rem; align-items: start; }

        /* SECTION HEADER */
        .section-eyebrow { font-size: .68rem; letter-spacing: 2.5px; text-transform: uppercase; color: var(--accent); font-weight: 600; margin-bottom: 1.2rem; display: flex; align-items: center; gap: .4rem; }

        /* FORM CARD */
        .form-card { background: var(--card); border: 1px solid var(--border); border-radius: 18px; padding: 1.8rem; margin-bottom: 1.2rem; }
        .form-card-title { font-size: 1rem; font-weight: 700; margin-bottom: 1.4rem; display: flex; align-items: center; gap: .6rem; }
        .form-card-title i { color: var(--accent); font-size: .9rem; }

        /* FIELDS */
        .field-grid { display: grid; gap: .9rem; }
        .field-grid.cols-2 { grid-template-columns: 1fr 1fr; }
        .field-grid.cols-3 { grid-template-columns: 2fr 1fr 1fr; }
        .field { display: flex; flex-direction: column; gap: .35rem; }
        .field label { font-size: .72rem; font-weight: 600; letter-spacing: 1px; text-transform: uppercase; color: var(--muted); }
        .field input, .field select { background: var(--surface); border: 1px solid var(--border); border-radius: 9px; color: var(--text); font-family: 'DM Sans', sans-serif; font-size: .87rem; padding: .68rem 1rem; outline: none; transition: border-color .2s, box-shadow .2s; appearance: none; -webkit-appearance: none; }
        .field input::placeholder { color: #3d3830; }
        .field input:focus, .field select:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(232,160,62,.12); }
        .field input.error { border-color: var(--red); }

        .input-wrap { position: relative; }
        .input-wrap input { padding-right: 2.6rem; }
        .input-icon { position: absolute; right: .9rem; top: 50%; transform: translateY(-50%); color: var(--muted); font-size: .9rem; pointer-events: none; }
        .card-brand { position: absolute; right: .9rem; top: 50%; transform: translateY(-50%); font-size: .75rem; font-weight: 700; color: var(--accent); letter-spacing: .5px; }

        /* PAYMENT METHOD TABS */
        .method-tabs { display: flex; gap: .6rem; margin-bottom: 1.4rem; flex-wrap: wrap; }
        .method-tab { flex: 1; min-width: 80px; border: 1.5px solid var(--border); border-radius: 10px; background: var(--surface); padding: .7rem .6rem; cursor: pointer; text-align: center; transition: all .2s; display: flex; flex-direction: column; align-items: center; gap: .3rem; }
        .method-tab i { font-size: 1.1rem; color: var(--muted); transition: color .2s; }
        .method-tab span { font-size: .7rem; font-weight: 600; letter-spacing: .5px; color: var(--muted); }
        .method-tab.active { border-color: var(--accent); background: rgba(232,160,62,.08); }
        .method-tab.active i, .method-tab.active span { color: var(--accent); }
        .method-tab:hover:not(.active) { border-color: rgba(232,160,62,.3); }

        /* CARD VISUAL */
        .card-visual { position: relative; border-radius: 16px; height: 170px; padding: 1.4rem 1.6rem; background: linear-gradient(135deg, #2a1f0e 0%, #1a1108 50%, #0c1a10 100%); border: 1px solid rgba(232,160,62,.18); margin-bottom: 1.4rem; overflow: hidden; box-shadow: 0 20px 60px rgba(0,0,0,.5); }
        .card-visual::before { content: ''; position: absolute; top: -40px; right: -40px; width: 180px; height: 180px; border-radius: 50%; background: radial-gradient(circle, rgba(232,160,62,.12), transparent 70%); }
        .card-visual::after { content: ''; position: absolute; bottom: -50px; left: -30px; width: 150px; height: 150px; border-radius: 50%; background: radial-gradient(circle, rgba(196,92,46,.08), transparent 70%); }
        .card-chip { width: 36px; height: 28px; border-radius: 5px; background: linear-gradient(135deg, #d4a843, #8a6820); border: 1px solid rgba(255,200,80,.3); margin-bottom: 1rem; position: relative; z-index: 1; }
        .card-number-display { font-size: .95rem; font-weight: 600; letter-spacing: 3px; color: rgba(240,235,227,.85); margin-bottom: .8rem; position: relative; z-index: 1; }
        .card-bottom { display: flex; justify-content: space-between; align-items: flex-end; position: relative; z-index: 1; }
        .card-label { font-size: .6rem; letter-spacing: 1.5px; text-transform: uppercase; color: var(--muted); }
        .card-value { font-size: .82rem; font-weight: 600; color: var(--text); margin-top: .15rem; }
        .card-network { font-family: 'Playfair Display', serif; font-size: 1rem; font-weight: 700; color: var(--accent); letter-spacing: .5px; }

        /* UPI PANEL */
        .upi-panel, .cod-panel { display: none; }
        .upi-panel.active, .cod-panel.active { display: block; }
        .upi-apps { display: grid; grid-template-columns: repeat(4, 1fr); gap: .7rem; margin-bottom: 1.2rem; }
        .upi-app { border: 1.5px solid var(--border); border-radius: 10px; background: var(--surface); padding: .75rem .5rem; cursor: pointer; text-align: center; transition: all .2s; }
        .upi-app i { font-size: 1.4rem; display: block; margin-bottom: .3rem; }
        .upi-app span { font-size: .68rem; font-weight: 600; color: var(--muted); }
        .upi-app.gpay i { color: #4285F4; }
        .upi-app.phonepe i { color: #6739B7; }
        .upi-app.paytm i { color: #00B9F1; }
        .upi-app.other i { color: var(--muted); }
        .upi-app:hover, .upi-app.selected { border-color: var(--accent); background: rgba(232,160,62,.07); }

        .cod-info { display: flex; align-items: flex-start; gap: 1rem; background: var(--surface); border: 1px solid var(--border); border-radius: 12px; padding: 1.2rem 1.3rem; }
        .cod-info i { color: var(--accent); font-size: 1.3rem; margin-top: .1rem; }
        .cod-info p { font-size: .83rem; color: var(--muted); line-height: 1.6; }
        .cod-info strong { color: var(--text); }

        /* ORDER SUMMARY SIDEBAR */
        .order-summary { background: var(--card); border: 1px solid var(--border); border-radius: 18px; padding: 1.6rem 1.4rem; position: sticky; top: 88px; }
        .summary-title { font-family: 'Playfair Display', serif; font-size: 1.15rem; font-weight: 700; margin-bottom: 1.4rem; }
        .summary-items { margin-bottom: 1rem; }
        .summary-item { display: flex; justify-content: space-between; align-items: center; font-size: .8rem; margin-bottom: .55rem; }
        .summary-item-name { color: var(--muted); }
        .summary-item-price { color: var(--text); font-weight: 600; }
        .summary-divider { border: none; border-top: 1px solid var(--border); margin: .8rem 0; }
        .summary-row { display: flex; justify-content: space-between; align-items: center; font-size: .82rem; color: var(--muted); margin-bottom: .6rem; }
        .summary-row.total { font-size: .95rem; font-weight: 700; color: var(--text); border-top: 1px solid var(--border); padding-top: .85rem; margin-top: .3rem; }
        .summary-row.total span:last-child { color: var(--accent); }

        .delivery-estimate { display: flex; align-items: center; gap: .7rem; background: var(--green-bg); border: 1px solid rgba(90,154,111,.25); border-radius: 10px; padding: .75rem 1rem; margin-top: 1.2rem; }
        .delivery-estimate i { color: var(--green); font-size: 1rem; }
        .delivery-estimate div { font-size: .76rem; }
        .delivery-estimate strong { display: block; color: var(--green); font-weight: 700; }
        .delivery-estimate span { color: var(--muted); }

        /* PAY BUTTON */
        .pay-btn { width: 100%; margin-top: 1.4rem; background: linear-gradient(135deg, var(--accent), var(--accent2)); color: #000; border: none; border-radius: 12px; padding: 1rem; font-family: 'DM Sans', sans-serif; font-size: .92rem; font-weight: 700; cursor: pointer; letter-spacing: .3px; display: flex; align-items: center; justify-content: center; gap: .6rem; transition: transform .15s, box-shadow .2s, filter .2s; position: relative; overflow: hidden; }
        .pay-btn::after { content: ''; position: absolute; inset: 0; background: linear-gradient(90deg, transparent, rgba(255,255,255,.15), transparent); transform: translateX(-100%); transition: transform .5s; }
        .pay-btn:hover::after { transform: translateX(100%); }
        .pay-btn:hover { transform: translateY(-2px); box-shadow: 0 10px 32px rgba(232,160,62,.35); filter: brightness(1.08); }
        .pay-btn:active { transform: translateY(0); }

        .secure-note { display: flex; align-items: center; justify-content: center; gap: .4rem; font-size: .7rem; color: var(--muted); margin-top: .8rem; }

        /* SUCCESS OVERLAY */
        .success-overlay { position: fixed; inset: 0; background: rgba(15,14,12,.97); z-index: 10000; display: flex; align-items: center; justify-content: center; opacity: 0; pointer-events: none; transition: opacity .4s; }
        .success-overlay.show { opacity: 1; pointer-events: all; }
        .success-box { text-align: center; padding: 3rem 2.5rem; background: var(--card); border: 1px solid var(--border); border-radius: 24px; max-width: 420px; width: 90%; transform: scale(.9); transition: transform .4s; }
        .success-overlay.show .success-box { transform: scale(1); }
        .success-icon { width: 80px; height: 80px; border-radius: 50%; background: var(--green-bg); border: 2px solid var(--green); display: flex; align-items: center; justify-content: center; font-size: 2rem; color: var(--green); margin: 0 auto 1.4rem; animation: pop .5s ease .3s both; }
        @keyframes pop { from { transform: scale(0); } to { transform: scale(1); } }
        .success-box h2 { font-family: 'Playfair Display', serif; font-size: 1.6rem; font-weight: 900; margin-bottom: .5rem; }
        .success-box p { font-size: .85rem; color: var(--muted); line-height: 1.7; margin-bottom: 1.6rem; }
        .order-id { background: var(--surface); border: 1px solid var(--border); border-radius: 8px; padding: .7rem 1.2rem; font-size: .82rem; color: var(--accent); font-weight: 700; letter-spacing: 1.5px; margin-bottom: 1.6rem; display: inline-block; }
        .success-btn { display: inline-flex; align-items: center; gap: .5rem; background: var(--accent); color: #000; border: none; border-radius: 9px; padding: .7rem 1.6rem; font-family: 'DM Sans', sans-serif; font-size: .88rem; font-weight: 700; cursor: pointer; text-decoration: none; transition: background .2s; }
        .success-btn:hover { background: #f5b04a; }

        /* FOOTER */
        footer { background: var(--surface); border-top: 1px solid var(--border); padding: 1.8rem 4rem; margin-top: 1rem; }
        .footer-bottom { display: flex; align-items: center; justify-content: space-between; font-size: .75rem; color: var(--muted); }

        /* RESPONSIVE */
        @media (max-width: 900px) {
            header { padding: 0 1.5rem; }
            .progress-bar { padding: 1rem 1.5rem; }
            .hero { padding: 2.5rem 1.5rem 2rem; }
            .checkout-layout { grid-template-columns: 1fr; padding: 2rem 1.5rem 3rem; }
            .order-summary { position: static; }
            footer { padding: 1.5rem; }
        }
        @media (max-width: 560px) {
            .field-grid.cols-2 { grid-template-columns: 1fr; }
            .field-grid.cols-3 { grid-template-columns: 1fr 1fr; }
            .upi-apps { grid-template-columns: repeat(2, 1fr); }
        }

        @keyframes shake {
            0%,100%{transform:translateX(0)}
            20%{transform:translateX(-8px)}
            40%{transform:translateX(8px)}
            60%{transform:translateX(-5px)}
            80%{transform:translateX(5px)}
        }
    </style>
</head>

<%
    String user_id = (String) session.getAttribute("user_id");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    double subtotal = 0;
    int itemCount = 0;
    java.util.List<java.util.Map<String, Object>> cartItems = new java.util.ArrayList<>();

    try {
        conn = ConnectionProvider.getConnection();
        int userId = Integer.parseInt(user_id);
        String sql = "SELECT c.quantity, f.food_name, f.price " +
                     "FROM carts c JOIN foods f ON c.food_id = f.food_id WHERE c.user_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, userId);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            java.util.Map<String, Object> item = new java.util.HashMap<>();
            item.put("name", rs.getString("food_name"));
            item.put("qty",  rs.getInt("quantity"));
            item.put("price", rs.getDouble("price"));
            subtotal += rs.getDouble("price") * rs.getInt("quantity");
            itemCount++;
            cartItems.add(item);
        }
    } catch (Exception ex) {
        ex.printStackTrace();
    } finally {
        try { if (rs!=null) rs.close(); if (pstmt!=null) pstmt.close(); if (conn!=null) conn.close(); }
        catch (SQLException ex) { ex.printStackTrace(); }
    }

    double delivery = itemCount > 0 ? 2.00 : 0;
    double tax = subtotal * 0.05;
    double grandTotal = subtotal + delivery + tax;
    String orderId = "FD-" + (100000 + (int)(Math.random()*899999));
%>

<body>

<!-- SUCCESS OVERLAY -->
<div class="success-overlay" id="successOverlay">
    <div class="success-box">
        <div class="success-icon"><i class="fas fa-check"></i></div>
        <h2>Order Placed!</h2>
        <p>Your delicious food is being prepared. We'll deliver it hot and fresh to your doorstep.</p>
        <div class="order-id">ORDER <%= orderId %></div>
        <br>
        <a href="orders.jsp?id=<%= user_id %>" class="success-btn">
            <i class="fas fa-receipt"></i> Track My Order
        </a>
    </div>
</div>

<!-- HEADER -->
<header>
    <a href="./index.jsp" class="logo">
        <i class="fa fa-utensils" style="color:var(--accent)"></i>
        <span>Foodies.</span>
    </a>
    <a href="cart.jsp?id=<%= user_id %>" class="back-link">
        <i class="fas fa-arrow-left"></i> Back to Cart
    </a>
</header>

<!-- PROGRESS -->
<div class="progress-bar">
    <div class="progress-steps">
        <div class="step done">
            <div class="step-dot"><i class="fas fa-check" style="font-size:.6rem"></i></div>
            Cart
        </div>
        <div class="step-line"></div>
        <div class="step active">
            <div class="step-dot">2</div>
            Payment
        </div>
        <div class="step-line"></div>
        <div class="step">
            <div class="step-dot">3</div>
            Confirm
        </div>
    </div>
</div>

<!-- HERO -->
<section class="hero">
    <div class="hero-bg"></div>
    <div class="hero-content reveal">
        <div class="hero-eyebrow"><i class="fas fa-lock"></i> Secure Checkout</div>
        <h1>Complete Your <em>Order</em></h1>
        <p>Fast, safe and encrypted. Your food is almost on its way.</p>
    </div>
</section>

<!-- CHECKOUT LAYOUT -->
<div class="checkout-layout">

    <!-- LEFT: FORMS -->
    <div>

        <div class="section-eyebrow reveal">
            <i class="fas fa-map-marker-alt"></i> Delivery Details
        </div>
        <div class="form-card reveal">
            <div class="form-card-title">
                <i class="fas fa-home"></i> Delivery Address
            </div>
            <div class="field-grid">
                <div class="field-grid cols-2">
                    <div class="field">
                        <label>First Name</label>
                        <input type="text" id="firstName" placeholder="John" autocomplete="given-name">
                    </div>
                    <div class="field">
                        <label>Last Name</label>
                        <input type="text" id="lastName" placeholder="Doe" autocomplete="family-name">
                    </div>
                </div>
                <div class="field">
                    <label>Street Address</label>
                    <input type="text" id="address" placeholder="123 MG Road, Apartment 4B" autocomplete="street-address">
                </div>
                <div class="field-grid cols-2">
                    <div class="field">
                        <label>City</label>
                        <input type="text" id="city" placeholder="Hyderabad" autocomplete="address-level2">
                    </div>
                    <div class="field">
                        <label>PIN Code</label>
                        <input type="text" id="pin" placeholder="500001" maxlength="6">
                    </div>
                </div>
                <div class="field">
                    <label>Phone Number</label>
                    <div class="input-wrap">
                        <input type="tel" id="phone" placeholder="+91 98765 43210" autocomplete="tel">
                        <i class="fas fa-phone input-icon"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="section-eyebrow reveal" style="margin-top:1.6rem">
            <i class="fas fa-credit-card"></i> Payment Method
        </div>
        <div class="form-card reveal">
            <div class="form-card-title">
                <i class="fas fa-wallet"></i> Choose Payment
            </div>

            <div class="method-tabs">
                <div class="method-tab active" onclick="switchMethod('card', this)">
                    <i class="fas fa-credit-card"></i><span>Card</span>
                </div>
                <div class="method-tab" onclick="switchMethod('upi', this)">
                    <i class="fas fa-mobile-alt"></i><span>UPI</span>
                </div>
                <div class="method-tab" onclick="switchMethod('netbanking', this)">
                    <i class="fas fa-university"></i><span>Net Banking</span>
                </div>
                <div class="method-tab" onclick="switchMethod('cod', this)">
                    <i class="fas fa-money-bill-wave"></i><span>Cash</span>
                </div>
            </div>

            <!-- CARD PANEL -->
            <div id="panel-card">
                <div class="card-visual">
                    <div class="card-chip"></div>
                    <div class="card-number-display" id="cardNumDisplay">•••• •••• •••• ••••</div>
                    <div class="card-bottom">
                        <div>
                            <div class="card-label">Card Holder</div>
                            <div class="card-value" id="cardNameDisplay">YOUR NAME</div>
                        </div>
                        <div>
                            <div class="card-label">Expires</div>
                            <div class="card-value" id="cardExpDisplay">MM / YY</div>
                        </div>
                        <div class="card-network" id="cardNetwork">VISA</div>
                    </div>
                </div>
                <div class="field-grid">
                    <div class="field">
                        <label>Card Number</label>
                        <div class="input-wrap">
                            <input type="text" id="cardNumber" placeholder="0000 0000 0000 0000" maxlength="19" oninput="formatCard(this)" autocomplete="cc-number">
                            <span class="card-brand" id="cardBrandIcon">VISA</span>
                        </div>
                    </div>
                    <div class="field">
                        <label>Name on Card</label>
                        <input type="text" id="cardName" placeholder="John Doe" oninput="document.getElementById('cardNameDisplay').textContent = this.value.toUpperCase() || 'YOUR NAME'" autocomplete="cc-name">
                    </div>
                    <div class="field-grid cols-2">
                        <div class="field">
                            <label>Expiry Date</label>
                            <input type="text" id="cardExpiry" placeholder="MM / YY" maxlength="7" oninput="formatExpiry(this)" autocomplete="cc-exp">
                        </div>
                        <div class="field">
                            <label>CVV</label>
                            <div class="input-wrap">
                                <input type="password" id="cardCVV" placeholder="•••" maxlength="4" autocomplete="cc-csc">
                                <i class="fas fa-question-circle input-icon"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- UPI PANEL -->
            <div id="panel-upi" class="upi-panel">
                <div class="upi-apps">
                    <div class="upi-app gpay" onclick="selectUpi(this)"><i class="fab fa-google-pay"></i><span>GPay</span></div>
                    <div class="upi-app phonepe" onclick="selectUpi(this)"><i class="fas fa-mobile-alt"></i><span>PhonePe</span></div>
                    <div class="upi-app paytm" onclick="selectUpi(this)"><i class="fas fa-wallet"></i><span>Paytm</span></div>
                    <div class="upi-app other" onclick="selectUpi(this)"><i class="fas fa-ellipsis-h"></i><span>Other</span></div>
                </div>
                <div class="field">
                    <label>UPI ID</label>
                    <div class="input-wrap">
                        <input type="text" id="upiId" placeholder="yourname@upi">
                        <i class="fas fa-at input-icon"></i>
                    </div>
                </div>
            </div>

            <!-- NET BANKING PANEL -->
            <div id="panel-netbanking" style="display:none">
                <div class="field">
                    <label>Select Bank</label>
                    <select id="bankSelect">
                        <option value="" disabled selected style="color:#3d3830">Choose your bank…</option>
                        <option>State Bank of India</option>
                        <option>HDFC Bank</option>
                        <option>ICICI Bank</option>
                        <option>Axis Bank</option>
                        <option>Kotak Mahindra Bank</option>
                        <option>Punjab National Bank</option>
                        <option>Bank of Baroda</option>
                        <option>Canara Bank</option>
                        <option>Yes Bank</option>
                        <option>Other</option>
                    </select>
                </div>
            </div>

            <!-- COD PANEL -->
            <div id="panel-cod" class="cod-panel">
                <div class="cod-info">
                    <i class="fas fa-info-circle"></i>
                    <p><strong>Cash on Delivery available.</strong><br>Pay with exact cash when your order arrives. Our delivery partner will carry change for up to &#8377;500.</p>
                </div>
            </div>
        </div>

    </div>

    <!-- RIGHT: ORDER SUMMARY -->
    <div class="order-summary reveal">
        <div class="summary-title">Order Summary</div>

        <div class="summary-items">
            <%
                for (java.util.Map<String, Object> item : cartItems) {
                    String name = (String) item.get("name");
                    int qty = (int) item.get("qty");
                    double price = (double) item.get("price");
            %>
            <div class="summary-item">
                <span class="summary-item-name"><%= name %> &times; <%= qty %></span>
                <span class="summary-item-price">&#8377;<%= String.format("%.2f", price * qty) %></span>
            </div>
            <% } %>
        </div>

        <hr class="summary-divider">

        <div class="summary-row"><span>Subtotal</span><span>&#8377;<%= String.format("%.2f", subtotal) %></span></div>
        <div class="summary-row"><span>Delivery fee</span><span>&#8377;<%= String.format("%.2f", delivery) %></span></div>
        <div class="summary-row"><span>Taxes (5%)</span><span>&#8377;<%= String.format("%.2f", tax) %></span></div>
        <div class="summary-row total">
            <span>Total</span>
            <span>&#8377;<%= String.format("%.2f", grandTotal) %></span>
        </div>

        <div class="delivery-estimate">
            <i class="fas fa-motorcycle"></i>
            <div>
                <strong>Estimated 30–40 min</strong>
                <span>Hot &amp; fresh delivery</span>
            </div>
        </div>

        <button class="pay-btn" onclick="handlePayment()">
            <i class="fas fa-lock"></i>
            Pay &#8377;<%= String.format("%.2f", grandTotal) %>
        </button>

        <div class="secure-note">
            <i class="fas fa-shield-alt" style="color:var(--green);font-size:.65rem"></i>
            256-bit SSL encrypted &amp; secure
        </div>
    </div>

</div>

<!-- FOOTER -->
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
    /* Scroll reveal */
    const observer = new IntersectionObserver(entries => {
        entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
    }, { threshold: 0.08 });
    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

    /* Payment method switcher */
    let currentMethod = 'card';
    function switchMethod(method, tab) {
        document.querySelectorAll('.method-tab').forEach(t => t.classList.remove('active'));
        tab.classList.add('active');
        ['card','upi','netbanking','cod'].forEach(m => {
            const p = document.getElementById('panel-' + m);
            if (p) p.style.display = m === method ? 'block' : 'none';
        });
        currentMethod = method;
        const upi = document.getElementById('panel-upi');
        if (upi) upi.classList.toggle('active', method === 'upi');
        const cod = document.getElementById('panel-cod');
        if (cod) cod.classList.toggle('active', method === 'cod');
    }

    /* Card number formatter */
    function formatCard(input) {
        let v = input.value.replace(/\D/g,'').slice(0,16);
        input.value = v.replace(/(.{4})/g,'$1 ').trim();
        const display = v.padEnd(16,'•').replace(/(.{4})/g,'$1 ').trim();
        document.getElementById('cardNumDisplay').textContent = display;
        const brand = v[0] === '4' ? 'VISA' : v[0] === '5' ? 'MC' : v.startsWith('34')||v.startsWith('37') ? 'AMEX' : 'CARD';
        document.getElementById('cardBrandIcon').textContent = brand;
        document.getElementById('cardNetwork').textContent = brand;
    }

    /* Expiry formatter */
    function formatExpiry(input) {
        let v = input.value.replace(/\D/g,'').slice(0,4);
        if (v.length > 2) v = v.slice(0,2) + ' / ' + v.slice(2);
        input.value = v;
        document.getElementById('cardExpDisplay').textContent = v || 'MM / YY';
    }

    /* UPI app selector */
    function selectUpi(el) {
        document.querySelectorAll('.upi-app').forEach(a => a.classList.remove('selected'));
        el.classList.add('selected');
    }

    /* ✅ FIXED: Payment handler - fetch is INSIDE the function */
    function handlePayment() {
        if (currentMethod === 'card') {
            const num  = document.getElementById('cardNumber').value.replace(/\s/g,'');
            const name = document.getElementById('cardName').value.trim();
            const exp  = document.getElementById('cardExpiry').value.trim();
            const cvv  = document.getElementById('cardCVV').value.trim();
            if (num.length < 16 || !name || exp.length < 7 || cvv.length < 3) { shake(); return; }
        } else if (currentMethod === 'upi') {
            const id = document.getElementById('upiId').value.trim();
            if (!id.includes('@')) { shake(); return; }
        } else if (currentMethod === 'netbanking') {
            const bank = document.getElementById('bankSelect').value;
            if (!bank) { shake(); return; }
        }

        const addr  = document.getElementById('address').value.trim();
        const fn    = document.getElementById('firstName').value.trim();
        const phone = document.getElementById('phone').value.trim();
        if (!fn || !addr || !phone) { shake(); return; }

        const btn = document.querySelector('.pay-btn');
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing…';
        btn.disabled = true;

        setTimeout(() => {
            fetch('/FDelivery/CheckoutServlet', {
                method: 'POST',
                credentials: 'include'
            })
            .then(res => {
                if (res.ok) {
                    document.getElementById('successOverlay').classList.add('show');
                } else {
                    btn.innerHTML = '<i class="fas fa-lock"></i> Pay &#8377;<%= String.format("%.2f", grandTotal) %>';
                    btn.disabled = false;
                    alert('Order failed. Please try again.');
                }
            })
            .catch(err => {
                console.error(err);
                btn.innerHTML = '<i class="fas fa-lock"></i> Pay &#8377;<%= String.format("%.2f", grandTotal) %>';
                btn.disabled = false;
                alert('Network error. Please try again.');
            });
        }, 1800);
    }

    /* Shake helper */
    function shake() {
        const form = document.querySelector('.form-card:last-of-type');
        form.style.animation = 'none';
        form.offsetHeight;
        form.style.animation = 'shake .4s ease';
    }
</script>

</body>
</html>
