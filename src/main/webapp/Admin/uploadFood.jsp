<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> --%>
<%-- <%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> --%>
<style>
.food-form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: .9rem; }
.food-field { display: flex; flex-direction: column; gap: .35rem; }
.food-field.full { grid-column: 1 / -1; }
.food-field label {
    font-size: .7rem; font-weight: 600; letter-spacing: 1px;
    text-transform: uppercase; color: var(--muted);
}
.food-field input,
.food-field textarea,
.food-field select {
    background: var(--card2); border: 1px solid var(--border);
    border-radius: 9px; color: var(--text);
    font-family: 'DM Sans', sans-serif; font-size: .85rem;
    padding: .65rem 1rem; outline: none;
    transition: border-color .2s, box-shadow .2s;
}
.food-field input::placeholder,
.food-field textarea::placeholder { color: #3d3830; }
.food-field input:focus,
.food-field textarea:focus,
.food-field select:focus {
    border-color: var(--accent);
    box-shadow: 0 0 0 3px rgba(232,160,62,.1);
}
.food-field textarea  { resize: vertical; min-height: 80px; }
.food-field input[type="file"] { padding: .5rem .8rem; cursor: pointer; }
.food-field select option { background: var(--card2); }
.file-hint { font-size: .68rem; color: var(--muted); margin-top: .2rem; }
</style>

<form action="/FDelivery/InsertFoodServlet" method="post" enctype="multipart/form-data">
    <div class="food-form-grid">

        <div class="food-field">
            <label for="restaurant_id"><i class="fas fa-store" style="margin-right:.3rem"></i>Restaurant ID</label>
            <input type="text" id="restaurant_id" name="restaurant_id" placeholder="e.g. 3" required>
        </div>

        <div class="food-field">
            <label for="food_name"><i class="fas fa-bowl-food" style="margin-right:.3rem"></i>Food Name</label>
            <input type="text" id="food_name" name="food_name" placeholder="e.g. Chicken Biryani" required>
        </div>

        <div class="food-field">
            <label for="price"><i class="fas fa-indian-rupee-sign" style="margin-right:.3rem"></i>Price (₹)</label>
            <input type="number" id="price" name="price" step="0.01" placeholder="0.00" required>
        </div>

        <div class="food-field">
            <label for="category"><i class="fas fa-tag" style="margin-right:.3rem"></i>Category</label>
            <select id="category" name="category" required>
                <option value="">— Select Category —</option>
                <option value="biryani">Biryani</option>
                <option value="starter">Starter</option>
                <option value="roti">Roti</option>
                <option value="curry">Curry</option>
            </select>
        </div>

        <div class="food-field full">
            <label for="description"><i class="fas fa-align-left" style="margin-right:.3rem"></i>Description</label>
            <textarea id="description" name="description" placeholder="Describe the dish..." required></textarea>
        </div>

        <div class="food-field full">
            <label for="image_file"><i class="fas fa-image" style="margin-right:.3rem"></i>Food Image</label>
            <input type="file" id="image_file" name="image_file" accept="image/*" required>
            <span class="file-hint">JPG or PNG, max 2MB</span>
        </div>

    </div>
    <div style="margin-top:1.2rem">
        <button type="submit" class="btn-primary">
            <i class="fas fa-plus"></i> Add Food Item
        </button>
    </div>
</form>
