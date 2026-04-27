<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- <%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> --%>
<%@page import="java.sql.*,com.db.ConnectionProvider"%>
<%@ page import="java.util.Base64" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Foodies â Discover Restaurants & Delicious Food</title>
    <link rel="icon" href="./Images/Restaurants/download.png" type="image/icon type">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;0,900;1,400&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">

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

        /* â NOISE OVERLAY â */
        body::before {
            content: '';
            position: fixed; inset: 0;
            background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.035'/%3E%3C/svg%3E");
            pointer-events: none; z-index: 9999; opacity: .4;
        }

        /* â HEADER â */
        header {
            position: sticky; top: 0; z-index: 100;
            background: rgba(15,14,12,.92);
            backdrop-filter: blur(18px);
            border-bottom: 1px solid var(--border);
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 4rem; height: 68px;
        }

        .logo { display: flex; align-items: center; gap: .6rem; text-decoration: none; }
        .logo i { color: var(--accent); font-size: 1.1rem; }
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
        .header-icons a { color: var(--muted); font-size: 1rem; transition: color .2s; text-decoration: none; }
        .header-icons a:hover { color: var(--accent); }

        /* â HERO â */
        .hero {
            position: relative; overflow: hidden;
            min-height: 88vh;
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
            background:
                radial-gradient(ellipse 60% 80% at 70% 50%, rgba(232,160,62,.14), transparent),
                radial-gradient(ellipse 40% 60% at 15% 80%, rgba(196,92,46,.09), transparent);
        }

        .hero-deco {
            position: absolute; right: -100px; top: -100px;
            width: 700px; height: 700px;
            border-radius: 50%;
            border: 1px solid rgba(232,160,62,.07);
            pointer-events: none; animation: rotateDeco 40s linear infinite;
        }
        .hero-deco::before {
            content: ''; position: absolute; inset: 50px;
            border-radius: 50%; border: 1px solid rgba(232,160,62,.04);
        }
        .hero-deco::after {
            content: ''; position: absolute; inset: 110px;
            border-radius: 50%; border: 1px solid rgba(232,160,62,.03);
        }

        @keyframes rotateDeco {
            from { transform: rotate(0deg); }
            to   { transform: rotate(360deg); }
        }

        /* Hero food image mosaic */
        .hero-visual {
            position: absolute; right: 4rem; top: 50%;
            transform: translateY(-50%);
            width: 420px; height: 420px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            grid-template-rows: 1fr 1fr;
            gap: 10px;
            border-radius: 24px; overflow: hidden;
            z-index: 1; opacity: .72;
        }

        .hero-visual img {
            width: 100%; height: 100%; object-fit: cover;
        }

        .hero-visual img:first-child {
            grid-row: 1 / 3;
            border-radius: 16px 0 0 16px;
        }

        .hero-visual img:nth-child(2) { border-radius: 0 16px 0 0; }
        .hero-visual img:nth-child(3) { border-radius: 0 0 16px 0; }

        .hero-content { position: relative; z-index: 2; max-width: 600px; }

        .hero-eyebrow {
            display: inline-flex; align-items: center; gap: .5rem;
            font-size: .72rem; letter-spacing: 2px; text-transform: uppercase;
            color: var(--accent); margin-bottom: 1.4rem;
            background: rgba(232,160,62,.1); border: 1px solid rgba(232,160,62,.2);
            padding: .35rem .9rem; border-radius: 100px;
        }

        .hero h1 {
            font-family: 'Playfair Display', serif;
            font-size: clamp(3rem, 6vw, 5rem);
            line-height: 1.05; font-weight: 900;
            margin-bottom: 1.4rem;
            letter-spacing: -1px;
        }

        .hero h1 em {
            font-style: italic;
            background: linear-gradient(90deg, var(--accent), var(--accent2));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .hero p {
            color: var(--muted); font-size: 1.05rem;
            line-height: 1.75; max-width: 440px;
            margin-bottom: 2rem;
        }

        .hero-actions { display: flex; align-items: center; gap: 1rem; flex-wrap: wrap; }

        .btn-primary {
            background: var(--accent); color: #000;
            border: none; border-radius: 10px;
            padding: .85rem 1.8rem;
            font-family: 'DM Sans', sans-serif;
            font-size: .9rem; font-weight: 700;
            letter-spacing: .3px; cursor: pointer; text-decoration: none;
            display: inline-flex; align-items: center; gap: .6rem;
            transition: background .2s, transform .15s, box-shadow .2s;
        }
        .btn-primary:hover {
            background: #f5b04a;
            transform: translateY(-2px);
            box-shadow: 0 8px 28px rgba(232,160,62,.35);
        }

        .btn-ghost {
            background: transparent; color: var(--text);
            border: 1px solid var(--border); border-radius: 10px;
            padding: .85rem 1.8rem;
            font-family: 'DM Sans', sans-serif;
            font-size: .9rem; font-weight: 500; cursor: pointer; text-decoration: none;
            display: inline-flex; align-items: center; gap: .6rem;
            transition: border-color .2s, color .2s;
        }
        .btn-ghost:hover { border-color: var(--accent); color: var(--accent); }

        .hero-stats {
            display: flex; gap: 2.5rem; margin-top: 3rem;
            padding-top: 2rem; border-top: 1px solid var(--border);
        }
        .stat-item { display: flex; flex-direction: column; gap: .2rem; }
        .stat-num {
            font-family: 'Playfair Display', serif;
            font-size: 1.6rem; font-weight: 700;
            color: var(--accent);
        }
        .stat-label { font-size: .72rem; color: var(--muted); text-transform: uppercase; letter-spacing: 1px; }

        /* â SCROLL ANIMATIONS â */
        .reveal {
            opacity: 0; transform: translateY(28px);
            transition: opacity .55s ease, transform .55s ease;
        }
        .reveal.visible { opacity: 1; transform: translateY(0); }

        /* â SECTION SHARED â */
        .section-wrap {
            padding: 5rem 4rem;
            max-width: 1300px; margin: 0 auto;
        }

        .section-header {
            display: flex; align-items: flex-end; justify-content: space-between;
            margin-bottom: 2.5rem; gap: 1rem;
        }

        .section-eyebrow {
            font-size: .7rem; letter-spacing: 2.5px; text-transform: uppercase;
            color: var(--accent); font-weight: 600; margin-bottom: .4rem;
        }

        .section-title {
            font-family: 'Playfair Display', serif;
            font-size: clamp(1.8rem, 3vw, 2.5rem);
            font-weight: 700; line-height: 1.2;
        }

        .see-all {
            color: var(--muted); text-decoration: none; font-size: .8rem;
            font-weight: 500; display: flex; align-items: center; gap: .4rem;
            white-space: nowrap; transition: color .2s;
        }
        .see-all:hover { color: var(--accent); }

        /* â SPECIALS (horizontal scroll chips) â */
        .specials-track {
            display: flex; gap: 1rem;
            overflow-x: auto; padding-bottom: .5rem;
            scrollbar-width: none;
        }
        .specials-track::-webkit-scrollbar { display: none; }

        .special-chip {
            flex-shrink: 0;
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 1rem 1.4rem;
            display: flex; flex-direction: column; align-items: center; gap: .8rem;
            text-decoration: none; color: var(--text);
            transition: border-color .25s, transform .2s, box-shadow .25s;
            cursor: pointer; min-width: 130px;
        }
        .special-chip:hover {
            border-color: rgba(232,160,62,.4);
            transform: translateY(-4px);
            box-shadow: 0 12px 35px rgba(0,0,0,.5);
        }

        .special-chip img {
            width: 80px; height: 80px;
            border-radius: 50%; object-fit: cover;
            border: 2px solid var(--border);
            transition: border-color .25s;
        }
        .special-chip:hover img { border-color: var(--accent); }

        .special-chip span {
            font-size: .82rem; font-weight: 600;
            text-align: center;
        }

        /* â TOP RESTAURANTS (featured row) â */
        .top-rest-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 1.2rem;
        }

        .top-rest-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 16px; overflow: hidden;
            text-decoration: none; color: var(--text);
            transition: border-color .25s, transform .2s, box-shadow .25s;
            display: flex; flex-direction: column;
        }
        .top-rest-card:hover {
            border-color: rgba(232,160,62,.35);
            transform: translateY(-5px);
            box-shadow: 0 16px 45px rgba(0,0,0,.55);
        }

        .top-rest-img {
            width: 100%; height: 140px; object-fit: cover;
            display: block;
        }

        .top-rest-body { padding: .9rem 1rem; }

        .top-rest-body h4 {
            font-family: 'Playfair Display', serif;
            font-size: .95rem; font-weight: 700;
            margin-bottom: .25rem;
        }

        .top-rest-body p {
            font-size: .75rem; color: var(--muted); line-height: 1.4;
        }

        .top-rest-body .stars {
            display: flex; align-items: center; gap: 2px;
            margin-top: .5rem;
        }
        .top-rest-body .stars i { color: var(--accent); font-size: .65rem; }
        .top-rest-body .stars .half { color: #5a4a2e; }

        /* â ALL RESTAURANTS GRID â */
        .rest-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.4rem;
        }

        .rest-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 18px; overflow: hidden;
            text-decoration: none; color: var(--text);
            transition: border-color .25s, transform .2s, box-shadow .25s;
            display: flex; flex-direction: column;
        }
        .rest-card:hover {
            border-color: rgba(232,160,62,.4);
            transform: translateY(-6px);
            box-shadow: 0 20px 55px rgba(0,0,0,.6);
        }

        .rest-card-img-wrap {
            position: relative; overflow: hidden; height: 200px;
        }

        .rest-card-img-wrap img {
            width: 100%; height: 100%; object-fit: cover;
            transition: transform .4s ease;
            display: block;
        }
        .rest-card:hover .rest-card-img-wrap img { transform: scale(1.06); }

        .rest-badge {
            position: absolute; top: .8rem; left: .8rem;
            background: rgba(15,14,12,.85);
            border: 1px solid rgba(232,160,62,.3);
            border-radius: 100px;
            padding: .2rem .7rem;
            font-size: .68rem; font-weight: 600;
            color: var(--accent); letter-spacing: .5px;
            text-transform: uppercase;
        }

        .rest-card-body { padding: 1.2rem 1.3rem; flex: 1; display: flex; flex-direction: column; gap: .5rem; }

        .rest-card-body h3 {
            font-family: 'Playfair Display', serif;
            font-size: 1.05rem; font-weight: 700;
        }

        .rest-card-body .desc {
            font-size: .8rem; color: var(--muted); line-height: 1.5;
        }

        .rest-card-footer {
            display: flex; align-items: center; justify-content: space-between;
            margin-top: auto; padding-top: .7rem;
            border-top: 1px solid var(--border);
        }

        .rest-stars { display: flex; align-items: center; gap: 3px; }
        .rest-stars i { color: var(--accent); font-size: .7rem; }

        .rest-meta { font-size: .72rem; color: var(--muted); display: flex; align-items: center; gap: .3rem; }
        .rest-meta i { color: var(--accent); font-size: .65rem; }

        /* â DIVIDER â */
        .divider {
            border: none; border-top: 1px solid var(--border);
            margin: 0 4rem;
        }

        /* â PROMO BANNER â */
        .promo-banner {
            margin: 0 4rem;
            background: linear-gradient(120deg, #2a1a08 0%, #1c1510 50%, #0f1c14 100%);
            border: 1px solid rgba(232,160,62,.15);
            border-radius: 22px; overflow: hidden;
            position: relative;
            padding: 3.5rem 4rem;
            display: flex; align-items: center; justify-content: space-between;
            gap: 2rem;
        }

        .promo-banner::before {
            content: '';
            position: absolute; inset: 0;
            background: radial-gradient(ellipse 50% 100% at 80% 50%, rgba(232,160,62,.1), transparent);
        }

        .promo-content { position: relative; z-index: 1; max-width: 500px; }

        .promo-content .section-eyebrow { margin-bottom: .6rem; }

        .promo-content h2 {
            font-family: 'Playfair Display', serif;
            font-size: clamp(1.8rem, 3vw, 2.5rem);
            font-weight: 900; line-height: 1.15;
            margin-bottom: 1rem;
        }

        .promo-content h2 span {
            background: linear-gradient(90deg, var(--accent), var(--accent2));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .promo-content p { color: var(--muted); font-size: .9rem; line-height: 1.7; margin-bottom: 1.5rem; }

        .promo-deco {
            font-size: 9rem; line-height: 1;
            opacity: .07; position: relative; z-index: 0;
            flex-shrink: 0;
            font-family: 'Playfair Display', serif;
            color: var(--accent);
        }

        /* â ABOUT OVERLAY â */
        #about {
            height: 100%; width: 0; position: fixed;
            z-index: 1000; top: 0; left: 0;
            background: rgba(15,14,12,.97);
            overflow-x: hidden;
            transition: 0.4s;
            display: flex; align-items: center; justify-content: center;
        }

        .about-overlay {
            max-width: 640px; padding: 2rem;
            text-align: center;
        }

        .about-overlay h1 {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem; font-weight: 900;
            color: var(--accent); margin-bottom: 1.5rem;
        }

        .about-overlay p {
            color: var(--muted); font-size: .9rem;
            line-height: 1.9;
        }

        .closebtn {
            position: absolute; top: 1.5rem; right: 2rem;
            font-size: 2rem; color: var(--muted);
            text-decoration: none; transition: color .2s;
        }
        .closebtn:hover { color: var(--accent); }

        /* â RATING WIDGET â */
        .back {
            position: fixed; inset: 0;
            background: rgba(0,0,0,.7);
            z-index: 500;
            display: none; align-items: center; justify-content: center;
        }
        .back.active { display: flex; }

        .container1 {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 20px; padding: 2rem;
            width: 380px; position: relative;
        }

        .post { display: none; text-align: center; padding: 1rem 0; }
        .post .text { font-size: 1.1rem; font-weight: 600; color: var(--accent); }
        .post .edit { margin-top: .5rem; font-size: .8rem; color: var(--muted); cursor: pointer; }

        .star-widget {
            display: flex; flex-direction: column; align-items: center; gap: 1rem;
        }

        .star-widget input { display: none; }

        .star-widget .stars-row {
            display: flex; flex-direction: row-reverse; gap: .3rem;
        }

        .star-widget .stars-row label {
            font-size: 2rem; cursor: pointer;
            color: var(--border); transition: color .15s;
        }
        .star-widget .stars-row input:checked ~ label,
        .star-widget .stars-row label:hover,
        .star-widget .stars-row label:hover ~ label { color: var(--accent); }

        .star-widget textarea {
            width: 100%;
            background: var(--surface); border: 1px solid var(--border);
            border-radius: 10px; color: var(--text);
            font-family: 'DM Sans', sans-serif;
            font-size: .88rem; padding: .75rem 1rem;
            outline: none; resize: none; min-height: 100px;
            transition: border-color .2s;
        }
        .star-widget textarea:focus { border-color: var(--accent); }

        /* â SEARCH FORM â */
        #search-form {
            position: fixed; top: 68px; left: 0; right: 0;
            background: rgba(15,14,12,.96);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--border);
            padding: 1.2rem 4rem;
            display: flex; align-items: center; gap: 1rem;
            transform: translateY(-120%); opacity: 0;
            transition: transform .3s ease, opacity .3s ease;
            z-index: 99;
        }
        #search-form.active { transform: translateY(0); opacity: 1; }

        #search-form input {
            flex: 1; background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 10px; color: var(--text);
            font-family: 'DM Sans', sans-serif;
            font-size: .95rem; padding: .75rem 1rem;
            outline: none; transition: border-color .2s;
        }
        #search-form input:focus { border-color: var(--accent); }

        #search-form .close-search {
            color: var(--muted); cursor: pointer; font-size: 1rem;
            transition: color .2s;
        }
        #search-form .close-search:hover { color: var(--accent); }

        /* â FOOTER â */
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

        /* â RESPONSIVE â */
        @media (max-width: 1100px) {
            .top-rest-grid { grid-template-columns: repeat(3, 1fr); }
            .hero-visual { display: none; }
        }

        @media (max-width: 900px) {
            header { padding: 0 1.5rem; }
            .navbar { display: none; }
            .hero { padding: 3.5rem 1.5rem; min-height: auto; }
            .section-wrap { padding: 3rem 1.5rem; }
            .promo-banner { margin: 0 1.5rem; padding: 2.5rem 2rem; }
            .promo-deco { display: none; }
            .divider { margin: 0 1.5rem; }
            .footer-grid { grid-template-columns: 1fr 1fr; }
            footer { padding: 2.5rem 1.5rem 1.5rem; }
            #search-form { padding: 1rem 1.5rem; }
            .top-rest-grid { grid-template-columns: repeat(2, 1fr); }
        }

        @media (max-width: 600px) {
            .top-rest-grid { grid-template-columns: 1fr 1fr; }
            .rest-grid { grid-template-columns: 1fr; }
            .hero-stats { gap: 1.5rem; flex-wrap: wrap; }
        }
    </style>
</head>

<%
    String user_id = (String) session.getAttribute("user_id");
%>

<body>

<!-- â RATING MODAL â -->
<div class="back" id="ratingModal">
    <div class="container1">
        <i class="fas fa-times" style="position:absolute;top:1rem;right:1rem;cursor:pointer;color:var(--muted);" onclick="document.getElementById('ratingModal').classList.remove('active')"></i>
        <div class="post" id="postThanks">
            <div class="text">Thanks for Rating us!</div>
            <div class="edit" onclick="showRatingForm()">Edit</div>
        </div>
        <div class="star-widget" id="starWidget">
            <p style="font-family:'Playfair Display',serif;font-size:1.2rem;font-weight:700;margin-bottom:.5rem;">Rate your experience</p>
            <div class="stars-row">
                <input type="radio" name="rate" id="rate-5"><label for="rate-5" class="fas fa-star"></label>
                <input type="radio" name="rate" id="rate-4"><label for="rate-4" class="fas fa-star"></label>
                <input type="radio" name="rate" id="rate-3"><label for="rate-3" class="fas fa-star"></label>
                <input type="radio" name="rate" id="rate-2"><label for="rate-2" class="fas fa-star"></label>
                <input type="radio" name="rate" id="rate-1"><label for="rate-1" class="fas fa-star"></label>
            </div>
            <textarea placeholder="Describe your experienceâ¦"></textarea>
            <button class="btn-primary" onclick="submitRating()" style="width:100%;justify-content:center;">
                <i class="fas fa-paper-plane"></i> Post Review
            </button>
        </div>
    </div>
</div>

<!-- â SEARCH FORM â -->
<form action="" id="search-form" onsubmit="return false;">
    <i class="fas fa-search" style="color:var(--muted);font-size:.9rem;"></i>
    <input type="search" placeholder="Search restaurants, dishes, cuisinesâ¦" id="search-box">
    <i class="fas fa-times close-search" id="close1"></i>
</form>

<!-- â HEADER â -->
<header>
    <a href="./index.jsp" class="logo">
        <i class="fa fa-utensils"></i>
        <span>Foodies.</span>
    </a>
    <nav class="navbar">
        <a class="active" href="./index.jsp">Home</a>
        <a href="./food_types.jsp">Food Types</a>
        <a href="./contact.jsp">Contact Us</a>
        <a href="cart.jsp?id=<%= user_id %>">My Cart</a>
        <a href="orders.jsp?id=<%= user_id %>">Orders</a>
    </nav>
    <div class="header-icons">
        <a href="#" id="search-icon"><i class="fas fa-search"></i></a>
        <a href="#"><i class="fas fa-heart"></i></a>
        <a href="login.jsp"><i class="fas fa-sign-in-alt"></i></a>
    </div>
</header>

<!-- â HERO â -->
<section class="hero">
    <div class="hero-bg"></div>
    <div class="hero-deco"></div>

    <div class="hero-content reveal">
        <div class="hero-eyebrow"><i class="fas fa-fire-flame-curved"></i> Now delivering in Bhubaneswar</div>
        <h1>Discover<br>Restaurants &<br><em>Delicious Food</em></h1>
        <p>From street-side biryan is to fine-dining experiences â explore the best food Bhubaneswar has to offer, delivered right to your door.</p>
        <div class="hero-actions">
            <a href="./login.jsp" class="btn-primary"><i class="fas fa-utensils"></i> Order Now</a>
            <a href="./dishes.jsp" class="btn-ghost"><i class="fas fa-compass"></i> Explore Dishes</a>
        </div>
        <div class="hero-stats">
            <div class="stat-item">
                <span class="stat-num">50+</span>
                <span class="stat-label">Restaurants</span>
            </div>
            <div class="stat-item">
                <span class="stat-num">200+</span>
                <span class="stat-label">Menu Items</span>
            </div>
            <div class="stat-item">
                <span class="stat-num">30 min</span>
                <span class="stat-label">Avg Delivery</span>
            </div>
        </div>
    </div>

    <!-- Visual mosaic (static placeholder â replace src with real images) -->
    <div class="hero-visual">
        <img src="./Images/Restaurants/barbeque.jpg"    alt="Barbeque">
        <img src="./Images/Dishes/Chicken-Biryani.jpg"  alt="Biryani">
        <img src="./Images/Dishes/panner tikka.jpg"     alt="Paneer Tikka">
    </div>
</section>

<!-- â OUR SPECIALS â -->
<div class="section-wrap">
    <div class="section-header reveal">
        <div>
            <div class="section-eyebrow"><i class="fas fa-star"></i> &nbsp;Featured</div>
            <h2 class="section-title">Our Specials</h2>
        </div>
        <a href="./dishes.jsp" class="see-all">View all dishes <i class="fas fa-arrow-right"></i></a>
    </div>

    <div class="specials-track reveal">
        <a href="./dishes.jsp" class="special-chip">
            <img src="./Images/Dishes/Chicken-Biryani.jpg" alt="Biryani">
            <span>Biryani</span>
        </a>
        <a href="./dishes.jsp" class="special-chip">
            <img src="./Images/Dishes/chicken.jpeg" alt="Chicken Lollipop">
            <span>Chicken Lollipop</span>
        </a>
        <a href="./dishes.jsp" class="special-chip">
            <img src="./Images/Dishes/panner tikka.jpg" alt="Paneer Tikka">
            <span>Paneer Tikka</span>
        </a>
        <a href="./dishes.jsp" class="special-chip">
            <img src="./Images/Dishes/garlicprawns.jpg" alt="Garlic Prawns">
            <span>Garlic Prawns</span>
        </a>
        <a href="./dishes.jsp" class="special-chip">
            <img src="./Images/Dishes/vegpulao.jpg" alt="Veg Pulao">
            <span>Veg Pulao</span>
        </a>
        <a href="./dishes.jsp" class="special-chip">
            <img src="./Images/Dishes/Chicken-Biryani.jpg" alt="Starters">
            <span>Starters</span>
        </a>
        <a href="./dishes.jsp" class="special-chip">
            <img src="./Images/Dishes/chicken.jpeg" alt="Fast Food">
            <span>Fast Food</span>
        </a>
    </div>
</div>

<hr class="divider">

<!-- â TOP RESTAURANTS â -->
<div class="section-wrap">
    <div class="section-header reveal">
        <div>
            <div class="section-eyebrow"><i class="fas fa-trophy"></i> &nbsp;Top Picks</div>
            <h2 class="section-title">Top Restaurants</h2>
        </div>
        <a href="#all-restaurants" class="see-all">See all <i class="fas fa-arrow-right"></i></a>
    </div>

    <div class="top-rest-grid">
        <a href="./barbeque.jsp" class="top-rest-card reveal">
            <img src="./Images/Restaurants/barbeque.jpg" alt="Barbeque" class="top-rest-img">
            <div class="top-rest-body">
                <h4>Barbeque</h4>
                <p>Tandoori, Biryani, Starters</p>
                <div class="stars">
                    <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i>
                </div>
            </div>
        </a>
        <a href="./paradise.jsp" class="top-rest-card reveal">
            <img src="./Images/Restaurants/paradise.jpg" alt="Paradise" class="top-rest-img">
            <div class="top-rest-body">
                <h4>Paradise</h4>
                <p>Tandoori, Biryani, Desserts</p>
                <div class="stars">
                    <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i>
                </div>
            </div>
        </a>
        <a href="./dominos.jsp" class="top-rest-card reveal">
            <img src="./Images/Restaurants/dominos.jpg" alt="Dominos" class="top-rest-img">
            <div class="top-rest-body">
                <h4>Domino's</h4>
                <p>Pizza, Burger, Bread</p>
                <div class="stars">
                    <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i>
                </div>
            </div>
        </a>
        <a href="./dosaplaza.jsp" class="top-rest-card reveal">
            <img src="./Images/Restaurants/platform65.jpg" alt="Dosa Plaza" class="top-rest-img">
            <div class="top-rest-body">
                <h4>Dosa Plaza</h4>
                <p>Breakfast, South Indian</p>
                <div class="stars">
                    <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i>
                </div>
            </div>
        </a>
        <a href="./hotnspicy.jsp" class="top-rest-card reveal">
            <img src="./Images/Restaurants/hotnspicy.jpg" alt="Hot n Spicy" class="top-rest-img">
            <div class="top-rest-body">
                <h4>Hot & Spicy</h4>
                <p>Tandoori, Biryani</p>
                <div class="stars">
                    <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i>
                </div>
            </div>
        </a>
    </div>
</div>

<hr class="divider">

<!-- â PROMO BANNER â -->
<div class="promo-banner reveal">
    <div class="promo-content">
        <div class="section-eyebrow"><i class="fas fa-tag"></i> &nbsp;Special offer</div>
        <h2>First Order?<br><span>Get 20% Off</span></h2>
        <p>New to Foodies? Use code <strong style="color:var(--accent);">WELCOME20</strong> at checkout and enjoy your first meal at a discount. No minimums, no fuss.</p>
        <a href="./login.jsp" class="btn-primary"><i class="fas fa-arrow-right"></i> Claim Offer</a>
    </div>
    <div class="promo-deco">ð½</div>
</div>

<hr class="divider" style="margin-top:3rem;">

<!-- â ALL RESTAURANTS â -->
<div class="section-wrap" id="all-restaurants">
    <div class="section-header reveal">
        <div>
            <div class="section-eyebrow"><i class="fas fa-store"></i> &nbsp;Explore</div>
            <h2 class="section-title">All Restaurants</h2>
        </div>
    </div>

    <div class="rest-grid">

        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            try {
                conn = ConnectionProvider.getConnection();
                String sql = "SELECT * FROM restaurants";
                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();
                while(rs.next()) {
                    int id = rs.getInt("restaurant_id");
                    String name = rs.getString("restaurant_name");
                    String description = rs.getString("description");
                    byte[] imageBytes = rs.getBytes("restaurant_image");
                    String base64Image = Base64.getEncoder().encodeToString(imageBytes);
        %>
        <a href="./restaurant.jsp?id=<%= id %>" class="rest-card reveal">
            <div class="rest-card-img-wrap">
                <img src="data:image/jpeg;base64,<%= base64Image %>" alt="<%= name %>">
                <span class="rest-badge">Open Now</span>
            </div>
            <div class="rest-card-body">
                <h3><%= name %></h3>
                <p class="desc"><%= description %></p>
                <div class="rest-card-footer">
                    <div class="rest-stars">
                        <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i>
                    </div>
                    <span class="rest-meta"><i class="fas fa-clock"></i> 30â45 min</span>
                </div>
            </div>
        </a>
        <%
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        %>

        <!-- Static fallback cards -->
        <a href="./mehfil.jsp" class="rest-card reveal">
            <div class="rest-card-img-wrap">
                <img src="./Images/Restaurants/mehfil.jpg" alt="Mehfil">
                <span class="rest-badge">Open Now</span>
            </div>
            <div class="rest-card-body">
                <h3>Mehfil</h3>
                <p class="desc">Starters, Biryani, Tandoori</p>
                <div class="rest-card-footer">
                    <div class="rest-stars"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i></div>
                    <span class="rest-meta"><i class="fas fa-clock"></i> 30â45 min</span>
                </div>
            </div>
        </a>

        <a href="./dominos.jsp" class="rest-card reveal">
            <div class="rest-card-img-wrap">
                <img src="./Images/Restaurants/dominos.jpg" alt="Dominos">
                <span class="rest-badge">Open Now</span>
            </div>
            <div class="rest-card-body">
                <h3>Domino's</h3>
                <p class="desc">Pizza, Burger, Bread</p>
                <div class="rest-card-footer">
                    <div class="rest-stars"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i></div>
                    <span class="rest-meta"><i class="fas fa-clock"></i> 25â35 min</span>
                </div>
            </div>
        </a>

        <a href="./paradise.jsp" class="rest-card reveal">
            <div class="rest-card-img-wrap">
                <img src="./Images/Restaurants/paradise.jpg" alt="Paradise">
                <span class="rest-badge">Open Now</span>
            </div>
            <div class="rest-card-body">
                <h3>Paradise</h3>
                <p class="desc">Starters, Biryani, Tandoori, Desserts</p>
                <div class="rest-card-footer">
                    <div class="rest-stars"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i></div>
                    <span class="rest-meta"><i class="fas fa-clock"></i> 35â50 min</span>
                </div>
            </div>
        </a>

        <a href="./dosaplaza.jsp" class="rest-card reveal">
            <div class="rest-card-img-wrap">
                <img src="./Images/Restaurants/platform65.jpg" alt="Dosa Plaza">
                <span class="rest-badge">Open Now</span>
            </div>
            <div class="rest-card-body">
                <h3>Dosa Plaza</h3>
                <p class="desc">Breakfast, South Indian</p>
                <div class="rest-card-footer">
                    <div class="rest-stars"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i></div>
                    <span class="rest-meta"><i class="fas fa-clock"></i> 20â30 min</span>
                </div>
            </div>
        </a>

        <a href="./hotnspicy.jsp" class="rest-card reveal">
            <div class="rest-card-img-wrap">
                <img src="./Images/Restaurants/hotnspicy.jpg" alt="Hot N Spicy">
                <span class="rest-badge">Open Now</span>
            </div>
            <div class="rest-card-body">
                <h3>Hot N Spicy</h3>
                <p class="desc">Starters, Biryani, Tandoori</p>
                <div class="rest-card-footer">
                    <div class="rest-stars"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i></div>
                    <span class="rest-meta"><i class="fas fa-clock"></i> 30â45 min</span>
                </div>
            </div>
        </a>

        <a href="./mughal.jsp" class="rest-card reveal">
            <div class="rest-card-img-wrap">
                <img src="./Images/Restaurants/mughal.jpg" alt="Mughal">
                <span class="rest-badge">Open Now</span>
            </div>
            <div class="rest-card-body">
                <h3>Mughal Restaurants</h3>
                <p class="desc">Starters, Biryani, Tandoori</p>
                <div class="rest-card-footer">
                    <div class="rest-stars"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i></div>
                    <span class="rest-meta"><i class="fas fa-clock"></i> 40â55 min</span>
                </div>
            </div>
        </a>

        <a href="./ksbakers.jsp" class="rest-card reveal">
            <div class="rest-card-img-wrap">
                <img src="./Images/Restaurants/ksbakers.png" alt="KS Bakers">
                <span class="rest-badge">Open Now</span>
            </div>
            <div class="rest-card-body">
                <h3>KS Bakers</h3>
                <p class="desc">Bakery, Cakes, Pastries</p>
                <div class="rest-card-footer">
                    <div class="rest-stars"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i></div>
                    <span class="rest-meta"><i class="fas fa-clock"></i> 20â30 min</span>
                </div>
            </div>
        </a>

    </div>
</div>

<!-- â ABOUT OVERLAY â -->
<div id="about">
    <a href="#" class="closebtn" onclick="closeNav()">&times;</a>
    <div class="about-overlay reveal">
        <h1>About Us</h1>
        <p>Launched in 2021, our technology platform connects customers, restaurant partners and delivery partners, serving their multiple needs. Customers use our platform to search and discover restaurants, read and write reviews, order food delivery, book a table and make payments while dining-out. We provide restaurant partners with industry-specific marketing tools to engage and acquire customers while also providing a reliable and efficient last-mile delivery service.</p>
    </div>
</div>

<!-- â FOOTER â -->
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
                <li><a href="#" onclick="openAbout()">About Us</a></li>
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

<!-- â JAVASCRIPT â -->
<script>
    /* Scroll reveal */
    const observer = new IntersectionObserver(entries => {
        entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
    }, { threshold: 0.08 });
    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

    /* Search toggle */
    document.getElementById('search-icon').onclick = (e) => {
        e.preventDefault();
        document.getElementById('search-form').classList.toggle('active');
        if (document.getElementById('search-form').classList.contains('active'))
            document.getElementById('search-box').focus();
    };
    document.getElementById('close1').onclick = () => {
        document.getElementById('search-form').classList.remove('active');
    };

    /* About overlay */
    function openAbout() {
        document.getElementById("about").style.width = "100%";
    }
    function closeNav() {
        document.getElementById("about").style.width = "0%";
    }

    /* Rating modal */
    function submitRating() {
        document.getElementById('starWidget').style.display = 'none';
        document.getElementById('postThanks').style.display = 'block';
    }
    function showRatingForm() {
        document.getElementById('starWidget').style.display = 'flex';
        document.getElementById('postThanks').style.display = 'none';
    }
</script>

 <%@ include file="chatbot.jsp" %>
</body>
</html>
