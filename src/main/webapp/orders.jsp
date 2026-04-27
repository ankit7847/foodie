<%@ page import="java.sql.*, java.io.*, com.db.ConnectionProvider, java.util.Base64" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - Foodies</title>
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
            --blue:      #5499d8;
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
        .logo span { font-family: 'Playfair Display', serif; font-size: 1.4rem; color: var(--accent); letter-spacing: .5px; }
        .navbar { display: flex; gap: 2rem; }
        .navbar a { color: var(--muted); text-decoration: none; font-size: .85rem; font-weight: 500; letter-spacing: .5px; text-transform: uppercase; transition: color .2s; position: relative; }
        .navbar a::after { content: ''; position: absolute; left: 0; bottom: -4px; width: 0; height: 1px; background: var(--accent); transition: width .3s; }
        .navbar a:hover, .navbar a.active { color: var(--accent); }
        .navbar a:hover::after, .navbar a.active::after { width: 100%; }
        .header-icons { display: flex; align-items: center; gap: 1.2rem; }
        .header-icons a { color: var(--muted); font-size: 1rem; transition: color .2s; }
        .header-icons a:hover { color: var(--accent); }

        /* --- HERO --- */
        .hero { position: relative; overflow: hidden; min-height: 260px; display: flex; align-items: center; padding: 4rem; }
        .hero-bg { position: absolute; inset: 0; background: linear-gradient(135deg, #0f1c14 0%, #1a1108 50%, #12120e 100%); }
        .hero-bg::after { content: ''; position: absolute; inset: 0; background: radial-gradient(ellipse 50% 70% at 80% 40%, rgba(90,154,111,.1), transparent), radial-gradient(ellipse 40% 50% at 10% 70%, rgba(232,160,62,.07), transparent); }
        .hero-deco { position: absolute; right: -60px; top: -60px; width: 480px; height: 480px; border-radius: 50%; border: 1px solid rgba(232,160,62,.06); pointer-events: none; }
        .hero-deco::before { content: ''; position: absolute; inset: 40px; border-radius: 50%; border: 1px solid rgba(232,160,62,.04); }
        .hero-content { position: relative; z-index: 1; }
        .hero-eyebrow { display: inline-flex; align-items: center; gap: .5rem; font-size: .72rem; letter-spacing: 2px; text-transform: uppercase; color: var(--accent); margin-bottom: 1rem; background: rgba(232,160,62,.1); border: 1px solid rgba(232,160,62,.2); padding: .3rem .8rem; border-radius: 100px; }
        .hero h1 { font-family: 'Playfair Display', serif; font-size: clamp(2rem, 4vw, 3rem); line-height: 1.1; font-weight: 900; margin-bottom: .6rem; }
        .hero h1 em { font-style: normal; background: linear-gradient(90deg, var(--accent), var(--accent2)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .hero p { color: var(--muted); font-size: .9rem; line-height: 1.7; }

        /* --- REVEAL --- */
        .reveal { opacity: 0; transform: translateY(24px); transition: opacity .5s ease, transform .5s ease; }
        .reveal.visible { opacity: 1; transform: translateY(0); }

        /* --- TOAST --- */
        .toast {
            position: fixed; top: 80px; left: 50%; transform: translateX(-50%) translateY(-10px);
            background: var(--card); border: 1px solid var(--border); border-radius: 10px;
            padding: .7rem 1.4rem; font-size: .82rem; color: var(--text);
            display: flex; align-items: center; gap: .6rem;
            box-shadow: 0 8px 32px rgba(0,0,0,.4);
            z-index: 9000; opacity: 0; transition: all .35s ease; pointer-events: none;
        }
        .toast.show { opacity: 1; transform: translateX(-50%) translateY(0); }
        .toast.success { border-color: rgba(90,154,111,.4); }
        .toast.error   { border-color: rgba(217,79,56,.4); }
        .toast.success i { color: var(--green); }
        .toast.error i   { color: var(--red); }

        /* --- MAIN SECTION --- */
        .orders-section { max-width: 1000px; margin: 0 auto; padding: 3rem 4rem 5rem; }

        /* --- STATS ROW --- */
        .stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1rem; margin-bottom: 2.5rem; }
        .stat-card { background: var(--card); border: 1px solid var(--border); border-radius: 14px; padding: 1rem 1.2rem; }
        .stat-label { font-size: .68rem; letter-spacing: 1.5px; text-transform: uppercase; color: var(--muted); margin-bottom: .3rem; }
        .stat-value { font-size: 1.35rem; font-weight: 700; color: var(--text); }
        .stat-value.delivered { color: var(--green); }
        .stat-value.accent    { color: var(--accent); }

        /* --- FILTER BAR --- */
        .filter-bar { display: flex; gap: .5rem; margin-bottom: 1.8rem; flex-wrap: wrap; align-items: center; }
        .filter-label { font-size: .72rem; letter-spacing: 1.5px; text-transform: uppercase; color: var(--muted); margin-right: .3rem; }
        .filter-btn { padding: .35rem .95rem; border-radius: 100px; border: 1px solid var(--border); background: none; color: var(--muted); font-size: .75rem; font-weight: 500; font-family: 'DM Sans', sans-serif; cursor: pointer; transition: all .2s; }
        .filter-btn:hover, .filter-btn.active { border-color: var(--accent); color: var(--accent); background: rgba(232,160,62,.08); }
        .filter-btn.active { font-weight: 600; }

        /* --- ORDER CARDS --- */
        .orders-list { display: flex; flex-direction: column; gap: 1rem; }

        .order-card {
            background: var(--card); border: 1px solid var(--border);
            border-radius: 16px; padding: 1.2rem 1.4rem;
            display: flex; align-items: center; gap: 1.3rem;
            transition: border-color .25s, box-shadow .25s;
        }
        .order-card:hover { border-color: rgba(232,160,62,.28); box-shadow: 0 8px 30px rgba(0,0,0,.3); }

        .order-img { width: 68px; height: 68px; border-radius: 12px; object-fit: cover; flex-shrink: 0; background: var(--tag-bg); }
        .order-img-placeholder { width: 68px; height: 68px; border-radius: 12px; background: var(--tag-bg); border: 1px solid var(--border); display: flex; align-items: center; justify-content: center; color: var(--muted); font-size: 1.3rem; flex-shrink: 0; }

        .order-details { flex: 1; min-width: 0; }
        .order-name { font-size: .95rem; font-weight: 600; margin-bottom: .15rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .order-meta { font-size: .75rem; color: var(--muted); margin-bottom: .4rem; }
        .order-id   { font-size: .7rem; color: #4a4540; font-family: 'Courier New', monospace; }

        .order-right { text-align: right; flex-shrink: 0; display: flex; flex-direction: column; align-items: flex-end; gap: .45rem; }
        .order-price { font-size: 1rem; font-weight: 700; color: var(--accent); }

        /* --- STATUS BADGES --- */
        .badge { display: inline-flex; align-items: center; gap: .3rem; padding: .22rem .7rem; border-radius: 100px; font-size: .67rem; font-weight: 600; letter-spacing: .5px; text-transform: uppercase; }
        .badge-delivered  { background: rgba(90,154,111,.13);  color: #5a9a6f; border: 1px solid rgba(90,154,111,.25); }
        .badge-pending    { background: rgba(232,160,62,.12);  color: #e8a03e; border: 1px solid rgba(232,160,62,.25); }
        .badge-confirmed  { background: rgba(84,153,216,.12);  color: #5499d8; border: 1px solid rgba(84,153,216,.25); }
        .badge-cancelled  { background: rgba(217,79,56,.1);    color: #d94f38; border: 1px solid rgba(217,79,56,.22); }

        /* --- TIMELINE DOT --- */
        .timeline-dot { width: 8px; height: 8px; border-radius: 50%; display: inline-block; margin-right: .25rem; }
        .dot-delivered { background: var(--green); }
        .dot-pending   { background: var(--accent); }
        .dot-confirmed { background: var(--blue); }
        .dot-cancelled { background: var(--red); }

        /* --- CANCEL BUTTON --- */
        .cancel-btn {
            display: inline-flex; align-items: center; gap: .35rem;
            background: rgba(217,79,56,.1); color: var(--red);
            border: 1px solid rgba(217,79,56,.25); border-radius: 8px;
            padding: .28rem .75rem; font-family: 'DM Sans', sans-serif;
            font-size: .7rem; font-weight: 600; cursor: pointer;
            transition: all .2s; letter-spacing: .3px;
        }
        .cancel-btn:hover { background: rgba(217,79,56,.2); border-color: rgba(217,79,56,.5); }

        /* Cancel confirmation modal */
        .modal-overlay {
            position: fixed; inset: 0; background: rgba(0,0,0,.6);
            backdrop-filter: blur(6px); z-index: 8000;
            display: none; align-items: center; justify-content: center;
        }
        .modal-overlay.open { display: flex; }
        .modal {
            background: var(--card); border: 1px solid var(--border);
            border-radius: 18px; padding: 2rem; width: 360px; max-width: 90vw;
            box-shadow: 0 24px 64px rgba(0,0,0,.6);
            animation: modalIn .25s ease;
        }
        @keyframes modalIn { from { opacity:0; transform: scale(.92) translateY(16px); } to { opacity:1; transform: scale(1) translateY(0); } }
        .modal-icon { width: 52px; height: 52px; background: rgba(217,79,56,.12); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-bottom: 1.1rem; }
        .modal-icon i { color: var(--red); font-size: 1.3rem; }
        .modal h3 { font-family: 'Playfair Display', serif; font-size: 1.15rem; margin-bottom: .45rem; }
        .modal p { font-size: .82rem; color: var(--muted); line-height: 1.6; margin-bottom: 1.4rem; }
        .modal-actions { display: flex; gap: .6rem; }
        .modal-cancel { flex: 1; padding: .6rem; background: none; border: 1px solid var(--border); border-radius: 9px; color: var(--muted); font-family: inherit; font-size: .82rem; cursor: pointer; transition: all .2s; }
        .modal-cancel:hover { border-color: var(--accent); color: var(--text); }
        .modal-confirm { flex: 1; padding: .6rem; background: var(--red); border: none; border-radius: 9px; color: #fff; font-family: inherit; font-size: .82rem; font-weight: 700; cursor: pointer; transition: background .2s; }
        .modal-confirm:hover { background: #e05a42; }

        /* --- EMPTY STATE --- */
        .empty-orders { text-align: center; padding: 4.5rem 2rem; color: var(--muted); background: var(--card); border: 1px solid var(--border); border-radius: 16px; }
        .empty-orders i { font-size: 2.8rem; margin-bottom: 1rem; opacity: .35; display: block; }
        .empty-orders p { margin-bottom: 1.2rem; font-size: .9rem; }
        .browse-btn { display: inline-flex; align-items: center; gap: .5rem; background: var(--accent); color: #000; border: none; border-radius: 8px; padding: .65rem 1.3rem; font-family: inherit; font-size: .85rem; font-weight: 700; cursor: pointer; text-decoration: none; transition: background .2s; }
        .browse-btn:hover { background: #f5b04a; }

        /* --- DIVIDER / FOOTER --- */
        .divider { margin: 0 4rem; border: none; border-top: 1px solid var(--border); }
        footer { background: var(--surface); border-top: 1px solid var(--border); padding: 2rem 4rem; margin-top: 2rem; }
        .footer-bottom { display: flex; align-items: center; justify-content: space-between; font-size: .75rem; color: var(--muted); }

        /* --- RESPONSIVE --- */
        @media (max-width: 900px) {
            header { padding: 0 1.5rem; }
            .navbar { display: none; }
            .hero { padding: 3rem 1.5rem; }
            .orders-section { padding: 2rem 1.5rem 3rem; }
            .stats-row { grid-template-columns: 1fr 1fr; }
            footer, .divider { padding-left: 1.5rem; padding-right: 1.5rem; }
            .divider { margin: 0 1.5rem; }
        }
        @media (max-width: 500px) {
            .order-card { flex-wrap: wrap; }
        }
    </style>
</head>

<%
    String user_id = (String) session.getAttribute("user_id");
%>

<body>

<!-- TOAST NOTIFICATION -->
<div class="toast" id="toast">
    <i class="fas fa-check-circle"></i>
    <span id="toastMsg">Order cancelled.</span>
</div>

<!-- CANCEL CONFIRM MODAL -->
<div class="modal-overlay" id="cancelModal">
    <div class="modal">
        <div class="modal-icon"><i class="fas fa-triangle-exclamation"></i></div>
        <h3>Cancel this order?</h3>
        <p>This action cannot be undone. Only pending orders can be cancelled.</p>
        <div class="modal-actions">
            <button class="modal-cancel" onclick="closeModal()">Keep order</button>
            <button class="modal-confirm" id="confirmCancelBtn">Yes, cancel it</button>
        </div>
    </div>
</div>

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
        <a href="cart.jsp?id=<%= user_id %>">My Cart</a>
        <a class="active" href="orders.jsp?id=<%= user_id %>">Orders</a>
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
        <div class="hero-eyebrow"><i class="fas fa-clock-rotate-left"></i> Order history</div>
        <h1>My <em>Orders</em></h1>
        <p>Track your past and current orders all in one place.</p>
    </div>
</section>

<!-- MAIN CONTENT -->
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    int totalOrders = 0, deliveredCount = 0, pendingCount = 0;
    double totalSpend = 0;

    try {
        conn = ConnectionProvider.getConnection();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(user_id));
        rs = pstmt.executeQuery();

        java.util.List<java.util.Map<String, Object>> orders = new java.util.ArrayList<>();
        while (rs.next()) {
            java.util.Map<String, Object> order = new java.util.HashMap<>();
            int orderId      = rs.getInt("order_id");
            int foodId       = rs.getInt("food_id");
            int quantity     = rs.getInt("quantity");
            double amount    = rs.getDouble("total_amount");
            String status    = rs.getString("order_status");
            Timestamp date   = rs.getTimestamp("order_date");

            totalOrders++;
            totalSpend += amount;
            if ("Delivered".equalsIgnoreCase(status))  deliveredCount++;
            if ("Pending".equalsIgnoreCase(status))    pendingCount++;

            String foodName    = "";
            byte[] foodProfile = null;
            PreparedStatement foodStmt = conn.prepareStatement(
                "SELECT food_name, food_profile FROM foods WHERE food_id = ?");
            foodStmt.setInt(1, foodId);
            ResultSet foodRs = foodStmt.executeQuery();
            if (foodRs.next()) {
                foodName    = foodRs.getString("food_name");
                foodProfile = foodRs.getBytes("food_profile");
            }
            foodRs.close(); foodStmt.close();

            order.put("orderId",     orderId);
            order.put("quantity",    quantity);
            order.put("amount",      amount);
            order.put("status",      status);
            order.put("date",        date);
            order.put("foodName",    foodName);
            order.put("foodProfile", foodProfile);
            orders.add(order);
        }
%>

<section class="orders-section">

    <!-- Stats -->
    <div class="stats-row reveal">
        <div class="stat-card">
            <div class="stat-label">Total orders</div>
            <div class="stat-value"><%= totalOrders %></div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Delivered</div>
            <div class="stat-value delivered"><%= deliveredCount %></div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Total spend</div>
            <div class="stat-value accent">&#8377;<%= String.format("%.2f", totalSpend) %></div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Pending</div>
            <div class="stat-value"><%= pendingCount %></div>
        </div>
    </div>

    <!-- Filter bar â matches enum: Pending, Confirmed, Delivered, Cancelled -->
    <div class="filter-bar reveal">
        <span class="filter-label">Filter:</span>
        <button class="filter-btn active" onclick="filterOrders('all', this)">All</button>
        <button class="filter-btn" onclick="filterOrders('Pending', this)">Pending</button>
        <button class="filter-btn" onclick="filterOrders('Confirmed', this)">Confirmed</button>
        <button class="filter-btn" onclick="filterOrders('Delivered', this)">Delivered</button>
        <button class="filter-btn" onclick="filterOrders('Cancelled', this)">Cancelled</button>
    </div>

    <!-- Orders list -->
    <% if (orders.isEmpty()) { %>
    <div class="empty-orders reveal">
        <i class="fas fa-box-open"></i>
        <p>No orders yet. Time to dig in!</p>
        <a href="./food_types.jsp" class="browse-btn">
            <i class="fas fa-utensils"></i> Browse Food
        </a>
    </div>
    <% } else { %>
    <div class="orders-list">
    <%
        for (java.util.Map<String, Object> order : orders) {
            String status   = (String) order.get("status");
            String foodName = (String) order.get("foodName");
            int orderId     = (int) order.get("orderId");
            int quantity    = (int) order.get("quantity");
            double amount   = (double) order.get("amount");
            Timestamp date  = (Timestamp) order.get("date");
            byte[] profile  = (byte[]) order.get("foodProfile");

            // Map status to badge/dot classes â matches enum exactly
            String badgeClass = "badge-pending";
            String dotClass   = "dot-pending";
            if ("Delivered".equalsIgnoreCase(status))  { badgeClass = "badge-delivered"; dotClass = "dot-delivered"; }
            else if ("Confirmed".equalsIgnoreCase(status))  { badgeClass = "badge-confirmed"; dotClass = "dot-confirmed"; }
            else if ("Cancelled".equalsIgnoreCase(status))  { badgeClass = "badge-cancelled"; dotClass = "dot-cancelled"; }

            String encodedProfile = null;
            if (profile != null) encodedProfile = Base64.getEncoder().encodeToString(profile);

            // Only Pending orders can be cancelled by user
            boolean canCancel = "Pending".equalsIgnoreCase(status);
    %>
        <div class="order-card reveal" data-status="<%= status %>">
            <% if (encodedProfile != null) { %>
                <img src="data:image/jpeg;base64,<%= encodedProfile %>" class="order-img" alt="<%= foodName %>">
            <% } else { %>
                <div class="order-img-placeholder"><i class="fas fa-utensils"></i></div>
            <% } %>

            <div class="order-details">
                <div class="order-name"><%= foodName %> &times; <%= quantity %></div>
                <div class="order-meta">
                    <% if (date != null) { %>
                        <%= new java.text.SimpleDateFormat("MMM d, yyyy Â· h:mm a").format(date) %>
                    <% } else { %>â<% } %>
                </div>
                <div class="order-id">#ORD-<%= String.format("%05d", orderId) %></div>
            </div>

            <div class="order-right">
                <div class="order-price">&#8377;<%= String.format("%.2f", amount) %></div>
                <span class="badge <%= badgeClass %>">
                    <span class="timeline-dot <%= dotClass %>"></span>
                    <%= status %>
                </span>
                <% if (canCancel) { %>
                <button class="cancel-btn" onclick="openCancelModal(<%= orderId %>)">
                    <i class="fas fa-xmark"></i> Cancel
                </button>
                <% } %>
            </div>
        </div>
    <%
        }
    %>
    </div>
    <% } %>

</section>

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
    /* --- Intersection observer for reveal --- */
    const observer = new IntersectionObserver(entries => {
        entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
    }, { threshold: 0.1 });
    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

    /* --- Filter --- */
    function filterOrders(status, btn) {
        document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        document.querySelectorAll('.order-card').forEach(card => {
            card.style.display = (status === 'all' || card.dataset.status === status) ? 'flex' : 'none';
        });
    }

    /* --- Cancel modal --- */
    let pendingOrderId = null;

    function openCancelModal(orderId) {
        pendingOrderId = orderId;
        document.getElementById('cancelModal').classList.add('open');
    }

    function closeModal() {
        pendingOrderId = null;
        document.getElementById('cancelModal').classList.remove('open');
    }

    document.getElementById('confirmCancelBtn').addEventListener('click', function () {
        if (!pendingOrderId) return;

        const orderIdToCancel = pendingOrderId; // ✅ capture BEFORE closeModal nulls it
        closeModal();

        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '/FDelivery/CancelOrderServlet';

        const input = document.createElement('input');
        input.type  = 'hidden';
        input.name  = 'order_id';
        input.value = orderIdToCancel; // ✅ use captured value

        form.appendChild(input);
        document.body.appendChild(form);
        form.submit();
    });

    // Close modal on backdrop click
    document.getElementById('cancelModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });

    /* --- Toast on redirect params --- */
    (function () {
        const params = new URLSearchParams(window.location.search);
        const toast  = document.getElementById('toast');
        const msg    = document.getElementById('toastMsg');
        const icon   = toast.querySelector('i');

        let text = null, type = 'success';

        if (params.get('cancelled') === '1') {
            text = 'Order cancelled successfully.';
            icon.className = 'fas fa-check-circle';
        } else if (params.get('error') === 'notcancellable') {
            text = 'Only pending orders can be cancelled.';
            type = 'error';
            icon.className = 'fas fa-circle-exclamation';
        } else if (params.get('error')) {
            text = 'Something went wrong. Please try again.';
            type = 'error';
            icon.className = 'fas fa-circle-exclamation';
        }

        if (text) {
            msg.textContent = text;
            toast.classList.add('show', type);
            setTimeout(() => toast.classList.remove('show'), 3500);
            // Clean URL
            history.replaceState(null, '', window.location.pathname);
        }
    })();
</script>

</body>
</html>
