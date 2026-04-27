<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.db.ConnectionProvider" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FDelivery Admin</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg:        #0a0908;
            --surface:   #111010;
            --card:      #1a1815;
            --card2:     #211f1c;
            --border:    #2a2724;
            --accent:    #e8a03e;
            --accent2:   #c45c2e;
            --text:      #f0ebe3;
            --muted:     #7a7570;
            --red:       #d94f38;
            --green:     #5a9a6f;
            --blue:      #5499d8;
            --sidebar-w: 240px;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        html { scroll-behavior: smooth; }

        body {
            background: var(--bg);
            color: var(--text);
            font-family: 'DM Sans', sans-serif;
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* ── NOISE OVERLAY ── */
        body::before {
            content: '';
            position: fixed; inset: 0;
            background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.03'/%3E%3C/svg%3E");
            pointer-events: none; z-index: 9999; opacity: .5;
        }

        /* ── SIDEBAR ── */
        .sidebar {
            position: fixed; top: 0; left: 0;
            width: var(--sidebar-w); height: 100vh;
            background: var(--surface);
            border-right: 1px solid var(--border);
            display: flex; flex-direction: column;
            z-index: 200;
            overflow: hidden;
        }

        .sidebar::before {
            content: '';
            position: absolute; bottom: -80px; left: -80px;
            width: 280px; height: 280px; border-radius: 50%;
            background: radial-gradient(circle, rgba(232,160,62,.06), transparent 70%);
            pointer-events: none;
        }

        .sidebar-brand {
            padding: 1.6rem 1.4rem 1.4rem;
            border-bottom: 1px solid var(--border);
            display: flex; align-items: center; gap: .7rem;
        }
        .sidebar-brand-icon {
            width: 36px; height: 36px; border-radius: 10px;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            display: flex; align-items: center; justify-content: center;
            font-size: .9rem; color: #000; flex-shrink: 0;
        }
        .sidebar-brand-text {
            font-family: 'Playfair Display', serif;
            font-size: 1.1rem; color: var(--accent); letter-spacing: .3px;
            line-height: 1.1;
        }
        .sidebar-brand-sub {
            font-size: .62rem; letter-spacing: 2px; text-transform: uppercase;
            color: var(--muted); font-family: 'DM Sans', sans-serif;
        }

        .sidebar-nav {
            flex: 1; padding: 1.2rem .8rem;
            display: flex; flex-direction: column; gap: .25rem;
        }

        .nav-label {
            font-size: .6rem; letter-spacing: 2.5px; text-transform: uppercase;
            color: var(--muted); padding: .6rem .6rem .3rem;
            font-weight: 600;
        }

        .sidebar-link {
            display: flex; align-items: center; gap: .75rem;
            padding: .65rem .9rem; border-radius: 10px;
            color: var(--muted); text-decoration: none;
            font-size: .84rem; font-weight: 500;
            transition: all .2s; cursor: pointer;
            border: 1px solid transparent;
            position: relative; overflow: hidden;
        }
        .sidebar-link i { font-size: .85rem; width: 16px; text-align: center; flex-shrink: 0; }
        .sidebar-link:hover {
            color: var(--text); background: var(--card);
            border-color: var(--border);
        }
        .sidebar-link.active {
            color: var(--accent);
            background: rgba(232,160,62,.1);
            border-color: rgba(232,160,62,.2);
        }
        .sidebar-link.active i { color: var(--accent); }
        .sidebar-link.active::before {
            content: '';
            position: absolute; left: 0; top: 20%; bottom: 20%;
            width: 2px; border-radius: 0 2px 2px 0;
            background: var(--accent);
        }

        .sidebar-footer {
            padding: 1rem .8rem 1.4rem;
            border-top: 1px solid var(--border);
        }
        .logout-btn {
            display: flex; align-items: center; gap: .75rem;
            padding: .65rem .9rem; border-radius: 10px;
            color: var(--muted); text-decoration: none;
            font-size: .84rem; font-weight: 500;
            transition: all .2s; border: 1px solid transparent;
        }
        .logout-btn i { font-size: .85rem; }
        .logout-btn:hover {
            color: var(--red); background: rgba(217,79,56,.08);
            border-color: rgba(217,79,56,.2);
        }

        /* ── TOPBAR ── */
        .topbar {
            position: fixed; top: 0;
            left: var(--sidebar-w); right: 0;
            height: 64px; z-index: 100;
            background: rgba(10,9,8,.92);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--border);
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 2rem;
        }

        .topbar-title {
            font-family: 'Playfair Display', serif;
            font-size: 1.1rem; font-weight: 700;
            display: flex; align-items: center; gap: .6rem;
        }
        .topbar-title span { color: var(--accent); }

        .topbar-right { display: flex; align-items: center; gap: 1rem; }

        .topbar-badge {
            display: flex; align-items: center; gap: .5rem;
            background: var(--card); border: 1px solid var(--border);
            border-radius: 8px; padding: .35rem .8rem;
            font-size: .75rem; color: var(--muted);
        }
        .topbar-badge i { color: var(--green); font-size: .65rem; }

        .admin-avatar {
            width: 34px; height: 34px; border-radius: 9px;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            display: flex; align-items: center; justify-content: center;
            font-size: .8rem; font-weight: 700; color: #000;
        }

        /* ── MAIN CONTENT ── */
        .main {
            margin-left: var(--sidebar-w);
            padding-top: 64px;
            min-height: 100vh;
        }

        .section-body {
            padding: 2rem 2.5rem 4rem;
        }

        /* ── DASHBOARD SECTIONS ── */
        .dashboard-section { display: none; }
        .dashboard-section.active { display: block; }

        /* ── PAGE HEADER ── */
        .page-header {
            margin-bottom: 2rem;
            display: flex; align-items: flex-end; justify-content: space-between;
        }
        .page-header-left {}
        .page-eyebrow {
            font-size: .68rem; letter-spacing: 2.5px; text-transform: uppercase;
            color: var(--accent); font-weight: 600; margin-bottom: .4rem;
            display: flex; align-items: center; gap: .4rem;
        }
        .page-title {
            font-family: 'Playfair Display', serif;
            font-size: 1.8rem; font-weight: 900; line-height: 1.1;
        }
        .page-title em {
            font-style: normal;
            background: linear-gradient(90deg, var(--accent), var(--accent2));
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }

        /* ── STAT CARDS ── */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1rem; margin-bottom: 2rem;
        }
        .stat-card {
            background: var(--card); border: 1px solid var(--border);
            border-radius: 14px; padding: 1.2rem 1.3rem;
            transition: border-color .2s, transform .2s;
            position: relative; overflow: hidden;
        }
        .stat-card::before {
            content: '';
            position: absolute; top: -30px; right: -30px;
            width: 100px; height: 100px; border-radius: 50%;
            background: radial-gradient(circle, rgba(232,160,62,.07), transparent 70%);
        }
        .stat-card:hover { border-color: rgba(232,160,62,.25); transform: translateY(-2px); }
        .stat-icon {
            width: 36px; height: 36px; border-radius: 9px;
            display: flex; align-items: center; justify-content: center;
            font-size: .85rem; margin-bottom: .9rem;
        }
        .stat-icon.orange { background: rgba(232,160,62,.12); color: var(--accent); }
        .stat-icon.green  { background: rgba(90,154,111,.12);  color: var(--green); }
        .stat-icon.red    { background: rgba(217,79,56,.1);    color: var(--red); }
        .stat-icon.blue   { background: rgba(84,153,216,.1);   color: var(--blue); }
        .stat-label { font-size: .68rem; letter-spacing: 1.5px; text-transform: uppercase; color: var(--muted); margin-bottom: .25rem; }
        .stat-value { font-size: 1.6rem; font-weight: 700; }
        .stat-value.accent { color: var(--accent); }
        .stat-value.green  { color: var(--green); }

        /* ── CARD ── */
        .admin-card {
            background: var(--card); border: 1px solid var(--border);
            border-radius: 16px; overflow: hidden; margin-bottom: 1.5rem;
        }
        .admin-card-header {
            padding: 1.2rem 1.5rem;
            border-bottom: 1px solid var(--border);
            display: flex; align-items: center; justify-content: space-between;
        }
        .admin-card-title {
            font-size: .9rem; font-weight: 700;
            display: flex; align-items: center; gap: .5rem;
        }
        .admin-card-title i { color: var(--accent); font-size: .8rem; }
        .admin-card-body { padding: 1.5rem; }

        /* ── TABLE ── */
        .admin-table { width: 100%; border-collapse: collapse; font-size: .82rem; }
        .admin-table thead tr {
            border-bottom: 1px solid var(--border);
        }
        .admin-table th {
            padding: .7rem 1rem; text-align: left;
            font-size: .65rem; letter-spacing: 1.5px; text-transform: uppercase;
            color: var(--accent); font-weight: 600;
        }
        .admin-table td {
            padding: .85rem 1rem; border-bottom: 1px solid rgba(46,43,39,.5);
            color: var(--text); vertical-align: middle;
        }
        .admin-table tbody tr:last-child td { border-bottom: none; }
        .admin-table tbody tr:hover td { background: rgba(255,255,255,.02); }

        /* ── BADGES ── */
        .badge {
            display: inline-flex; align-items: center; gap: .3rem;
            padding: .22rem .7rem; border-radius: 100px;
            font-size: .65rem; font-weight: 600; letter-spacing: .5px; text-transform: uppercase;
        }
        .badge-pending   { background: rgba(232,160,62,.12); color: var(--accent); border: 1px solid rgba(232,160,62,.25); }
        .badge-confirmed { background: rgba(84,153,216,.1);  color: var(--blue);   border: 1px solid rgba(84,153,216,.25); }
        .badge-delivered { background: rgba(90,154,111,.12); color: var(--green);  border: 1px solid rgba(90,154,111,.25); }
        .badge-cancelled { background: rgba(217,79,56,.1);   color: var(--red);    border: 1px solid rgba(217,79,56,.22); }

        /* ── FORM STYLES ── */
        .form-grid { display: grid; gap: .9rem; }
        .form-grid.cols-2 { grid-template-columns: 1fr 1fr; }
        .field { display: flex; flex-direction: column; gap: .35rem; }
        .field label {
            font-size: .7rem; font-weight: 600; letter-spacing: 1px;
            text-transform: uppercase; color: var(--muted);
        }
        .field input, .field textarea, .field select {
            background: var(--card2); border: 1px solid var(--border);
            border-radius: 9px; color: var(--text);
            font-family: 'DM Sans', sans-serif; font-size: .85rem;
            padding: .65rem 1rem; outline: none;
            transition: border-color .2s, box-shadow .2s;
        }
        .field input::placeholder, .field textarea::placeholder { color: #3d3830; }
        .field input:focus, .field textarea:focus, .field select:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(232,160,62,.1);
        }
        .field textarea { resize: vertical; min-height: 90px; }
        .field input[type="file"] { padding: .5rem .8rem; cursor: pointer; }

        /* ── BUTTONS ── */
        .btn-primary {
            display: inline-flex; align-items: center; gap: .5rem;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            color: #000; border: none; border-radius: 9px;
            padding: .65rem 1.4rem; font-family: 'DM Sans', sans-serif;
            font-size: .85rem; font-weight: 700; cursor: pointer;
            transition: transform .15s, box-shadow .2s, filter .2s;
        }
        .btn-primary:hover { transform: translateY(-1px); filter: brightness(1.08); box-shadow: 0 6px 20px rgba(232,160,62,.3); }
        .btn-primary:active { transform: translateY(0); }

        .btn-sm {
            display: inline-flex; align-items: center; gap: .3rem;
            padding: .3rem .75rem; border-radius: 7px;
            font-family: 'DM Sans', sans-serif; font-size: .72rem; font-weight: 600;
            cursor: pointer; border: 1px solid transparent; transition: all .2s;
        }
        .btn-edit  { background: rgba(84,153,216,.1);  color: var(--blue);  border-color: rgba(84,153,216,.25); }
        .btn-edit:hover  { background: rgba(84,153,216,.2); }
        .btn-delete { background: rgba(217,79,56,.1); color: var(--red);  border-color: rgba(217,79,56,.22); }
        .btn-delete:hover { background: rgba(217,79,56,.2); }
        .btn-update { background: rgba(90,154,111,.12); color: var(--green); border-color: rgba(90,154,111,.25); }
        .btn-update:hover { background: rgba(90,154,111,.2); }

        /* ── SELECT in table ── */
        .status-select {
            background: var(--card2); border: 1px solid var(--border);
            border-radius: 7px; color: var(--text);
            font-family: 'DM Sans', sans-serif; font-size: .75rem;
            padding: .3rem .6rem; outline: none; cursor: pointer;
            transition: border-color .2s;
        }
        .status-select:focus { border-color: var(--accent); }

        /* ── EMPTY STATE ── */
        .empty-state {
            text-align: center; padding: 3rem 2rem;
            color: var(--muted);
        }
        .empty-state i { font-size: 2rem; margin-bottom: .8rem; display: block; opacity: .3; }
        .empty-state p { font-size: .85rem; }

        /* ── FOOD IMAGE ── */
        .food-img { width: 44px; height: 44px; border-radius: 8px; object-fit: cover; }
        .logo-img { width: 36px; height: 36px; border-radius: 6px; object-fit: cover; }
        .rest-img { width: 56px; height: 44px; border-radius: 8px; object-fit: cover; }

        /* ── REVEAL ANIMATION ── */
        .fade-in { animation: fadeIn .4s ease both; }
        @keyframes fadeIn { from { opacity:0; transform: translateY(12px); } to { opacity:1; transform:none; } }

        /* ── SCROLLBAR ── */
        ::-webkit-scrollbar { width: 5px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: var(--border); border-radius: 4px; }
        ::-webkit-scrollbar-thumb:hover { background: var(--muted); }

        /* ── RESPONSIVE ── */
        @media (max-width: 900px) {
            :root { --sidebar-w: 200px; }
            .stats-grid { grid-template-columns: 1fr 1fr; }
            .section-body { padding: 1.5rem; }
        }
    </style>
</head>

<body>

<!-- ── SIDEBAR ── -->
<div class="sidebar">
    <div class="sidebar-brand">
        <div class="sidebar-brand-icon"><i class="fas fa-utensils"></i></div>
        <div>
            <div class="sidebar-brand-text">Foodies.</div>
            <div class="sidebar-brand-sub">Admin Panel</div>
        </div>
    </div>

    <nav class="sidebar-nav">
        <div class="nav-label">Main</div>
        <a class="sidebar-link active" data-section="home">
            <i class="fas fa-house"></i> Home
        </a>
        <a class="sidebar-link" data-section="orders">
            <i class="fas fa-receipt"></i> Orders
        </a>
        <a class="sidebar-link" data-section="users">
            <i class="fas fa-users"></i> Users
        </a>

        <div class="nav-label" style="margin-top:.5rem">Catalog</div>
        <a class="sidebar-link" data-section="products">
            <i class="fas fa-bowl-food"></i> Products
        </a>
        <a class="sidebar-link" data-section="messages">
            <i class="fas fa-envelope"></i> Messages
        </a>
    </nav>

    <div class="sidebar-footer">
        <a href="../login.jsp" class="logout-btn">
            <i class="fas fa-arrow-right-from-bracket"></i> Logout
        </a>
    </div>
</div>

<!-- ── TOPBAR ── -->
<div class="topbar">
    <div class="topbar-title" id="topbarTitle">
        <i class="fas fa-house" style="color:var(--accent);font-size:.9rem"></i>
        <span>Admin</span> Dashboard
    </div>
    <div class="topbar-right">
        <div class="topbar-badge">
            <i class="fas fa-circle"></i> Live
        </div>
        <div class="admin-avatar">A</div>
    </div>
</div>

<!-- ── MAIN ── -->
<div class="main">
<div class="section-body">

    <!-- HOME -->
    <section id="home" class="dashboard-section active fade-in">
        <div class="page-header">
            <div class="page-header-left">
                <div class="page-eyebrow"><i class="fas fa-house"></i> Overview</div>
                <div class="page-title">Admin <em>Dashboard</em></div>
            </div>
        </div>

        <div class="admin-card">
            <div class="admin-card-header">
                <div class="admin-card-title"><i class="fas fa-store"></i> Add Restaurant</div>
            </div>
            <div class="admin-card-body">
                <jsp:include page="restaurants.jsp" />
            </div>
        </div>

        <div class="admin-card">
            <div class="admin-card-header">
                <div class="admin-card-title"><i class="fas fa-list"></i> Restaurants List</div>
            </div>
            <jsp:include page="viewRestaurants.jsp" />
        </div>
    </section>

    <!-- ORDERS -->
    <section id="orders" class="dashboard-section">
        <div class="page-header">
            <div class="page-header-left">
                <div class="page-eyebrow"><i class="fas fa-receipt"></i> Management</div>
                <div class="page-title">All <em>Orders</em></div>
            </div>
        </div>
        <div class="admin-card">
            <div class="admin-card-header">
                <div class="admin-card-title"><i class="fas fa-clock-rotate-left"></i> Order History</div>
            </div>
            <jsp:include page="updateOrder.jsp" />
        </div>
    </section>

    <!-- USERS -->
    <section id="users" class="dashboard-section">
        <div class="page-header">
            <div class="page-header-left">
                <div class="page-eyebrow"><i class="fas fa-users"></i> Management</div>
                <div class="page-title">Registered <em>Users</em></div>
            </div>
        </div>
        <div class="admin-card">
            <div class="admin-card-header">
                <div class="admin-card-title"><i class="fas fa-user-group"></i> All Users</div>
            </div>
            <jsp:include page="viewUser.jsp" />
        </div>
    </section>

    <!-- PRODUCTS -->
    <section id="products" class="dashboard-section">
        <div class="page-header">
            <div class="page-header-left">
                <div class="page-eyebrow"><i class="fas fa-bowl-food"></i> Catalog</div>
                <div class="page-title">Food <em>Products</em></div>
            </div>
        </div>
        <div class="admin-card">
            <div class="admin-card-header">
                <div class="admin-card-title"><i class="fas fa-plus"></i> Add Food Item</div>
            </div>
            <div class="admin-card-body">
                <jsp:include page="uploadFood.jsp" />
            </div>
        </div>
        <div class="admin-card">
            <div class="admin-card-header">
                <div class="admin-card-title"><i class="fas fa-list"></i> All Products</div>
            </div>
            <jsp:include page="viewFood.jsp" />
        </div>
    </section>

    <!-- MESSAGES -->
    <section id="messages" class="dashboard-section">
        <div class="page-header">
            <div class="page-header-left">
                <div class="page-eyebrow"><i class="fas fa-envelope"></i> Inbox</div>
                <div class="page-title">Customer <em>Messages</em></div>
            </div>
        </div>
        <div class="admin-card">
            <div class="admin-card-header">
                <div class="admin-card-title"><i class="fas fa-inbox"></i> All Messages</div>
            </div>
            <jsp:include page="viewMessages.jsp" />
        </div>
    </section>

</div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {

    const links = document.querySelectorAll(".sidebar-link");
    const sections = document.querySelectorAll(".dashboard-section");
    const topbarTitle = document.getElementById("topbarTitle");

    const sectionMeta = {
        home:     { icon: "fas fa-house",       label: "Admin",    suffix: "Dashboard" },
        orders:   { icon: "fas fa-receipt",      label: "Orders",   suffix: "Management" },
        users:    { icon: "fas fa-users",        label: "Users",    suffix: "Management" },
        products: { icon: "fas fa-bowl-food",    label: "Products", suffix: "Catalog" },
        messages: { icon: "fas fa-envelope",     label: "Messages", suffix: "Inbox" },
    };

    links.forEach(link => {
        link.addEventListener("click", function (e) {
            e.preventDefault();

            links.forEach(l => l.classList.remove("active"));
            this.classList.add("active");

            const target = this.getAttribute("data-section");

            sections.forEach(sec => {
                sec.classList.remove("active");
                sec.classList.remove("fade-in");
            });

            const targetSection = document.getElementById(target);
            if (targetSection) {
                targetSection.classList.add("active");
                void targetSection.offsetWidth; // reflow
                targetSection.classList.add("fade-in");
            }

            // Update topbar
            const meta = sectionMeta[target];
            if (meta) {
                topbarTitle.innerHTML = `<i class="${meta.icon}" style="color:var(--accent);font-size:.9rem"></i> <span>${meta.label}</span> ${meta.suffix}`;
            }
        });
    });

    // Highlight active from URL param
    const params = new URLSearchParams(window.location.search);
    const status = params.get("status");
    if (status === "success") {
        // could show a toast here
    }
});// ✅ Auto-activate section from URL param
const params = new URLSearchParams(window.location.search);
const sectionParam = params.get("section");
if (sectionParam) {
    // Deactivate all
    links.forEach(l => l.classList.remove("active"));
    sections.forEach(sec => {
        sec.classList.remove("active");
        sec.classList.remove("fade-in");
    });

    // Activate the right section
    const targetSection = document.getElementById(sectionParam);
    if (targetSection) {
        targetSection.classList.add("active");
        targetSection.classList.add("fade-in");
    }

    // Activate the right sidebar link
    const targetLink = document.querySelector(`.sidebar-link[data-section="${sectionParam}"]`);
    if (targetLink) targetLink.classList.add("active");

    // Update topbar
    const meta = sectionMeta[sectionParam];
    if (meta) {
        topbarTitle.innerHTML = `<i class="${meta.icon}" style="color:var(--accent);font-size:.9rem"></i> <span>${meta.label}</span> ${meta.suffix}`;
    }
}
</script>

</body>
</html>
