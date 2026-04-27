<%-- <%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
.rest-form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: .9rem; }
.rest-field { display: flex; flex-direction: column; gap: .35rem; }
.rest-field.full { grid-column: 1 / -1; }
.rest-field label {
    font-size: .7rem; font-weight: 600; letter-spacing: 1px;
    text-transform: uppercase; color: var(--muted);
}
.rest-field input, .rest-field textarea {
    background: var(--card2); border: 1px solid var(--border);
    border-radius: 9px; color: var(--text);
    font-family: 'DM Sans', sans-serif; font-size: .85rem;
    padding: .65rem 1rem; outline: none;
    transition: border-color .2s, box-shadow .2s;
}
.rest-field input::placeholder, .rest-field textarea::placeholder { color: #3d3830; }
.rest-field input:focus, .rest-field textarea:focus {
    border-color: var(--accent);
    box-shadow: 0 0 0 3px rgba(232,160,62,.1);
}
.rest-field input[type="file"] { padding: .5rem .8rem; cursor: pointer; }
.rest-field textarea { resize: vertical; min-height: 80px; }
.file-hint { font-size: .68rem; color: var(--muted); margin-top: .2rem; }
</style>

<form action="/FDelivery/AddRestaurantServlet" method="post" enctype="multipart/form-data">
    <div class="rest-form-grid">

        <div class="rest-field full">
            <label for="restaurantName"><i class="fas fa-store" style="margin-right:.3rem"></i>Restaurant Name</label>
            <input type="text" id="restaurantName" name="restaurantName" placeholder="e.g. The Golden Fork">
        </div>

        <div class="rest-field">
            <label for="restaurantLogo"><i class="fas fa-image" style="margin-right:.3rem"></i>Restaurant Logo</label>
            <input type="file" id="restaurantLogo" name="restaurantLogo" accept="image/*">
            <span class="file-hint">PNG or JPG, recommended 200×200px</span>
        </div>

        <div class="rest-field">
            <label for="restaurantImage"><i class="fas fa-photo-film" style="margin-right:.3rem"></i>Restaurant Image</label>
            <input type="file" id="restaurantImage" name="restaurantImage" accept="image/*">
            <span class="file-hint">PNG or JPG, recommended 800×400px</span>
        </div>

        <div class="rest-field full">
            <label for="description"><i class="fas fa-align-left" style="margin-right:.3rem"></i>Description</label>
            <textarea id="description" name="description" placeholder="A short description of the restaurant..."></textarea>
        </div>

    </div>
    <div style="margin-top:1.2rem">
        <button type="submit" class="btn-primary">
            <i class="fas fa-plus"></i> Add Restaurant
        </button>
    </div>
</form>
