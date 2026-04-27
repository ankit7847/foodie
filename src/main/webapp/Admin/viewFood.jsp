<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ page import="java.sql.*, java.io.*, java.util.Base64" %>
<%@ page import="com.db.ConnectionProvider" %>
<div style="overflow-x:auto">
<table class="admin-table">
    <thead>
        <tr>
            <th>Rest. ID</th>
            <th>Image</th>
            <th>Food Name</th>
            <th>Category</th>
            <th>Description</th>
            <th>Price</th>
            <th>Action</th>
        </tr>
    </thead>
    <tbody>
        <%
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;
            int rowCount = 0;
            try {
                conn = ConnectionProvider.getConnection();
                stmt = conn.createStatement();
                rs = stmt.executeQuery("SELECT * FROM foods");

                while (rs.next()) {
                    rowCount++;
                    String restaurantId = rs.getString("restaurant_id");
                    String foodName     = rs.getString("food_name");
                    String description  = rs.getString("description");
                    double price        = rs.getDouble("price");
                    int    foodId       = rs.getInt("food_id");
                    String category     = rs.getString("category");
                    Blob blob           = rs.getBlob("food_profile");

                    String encodedImage = null;
                    if (blob != null) {
                        byte[] imageData = blob.getBytes(1, (int) blob.length());
                        encodedImage = Base64.getEncoder().encodeToString(imageData);
                    }

                    // Category badge colour
                    String catColor = "badge-confirmed";
                    if      ("biryani".equalsIgnoreCase(category)) catColor = "badge-pending";
                    else if ("curry".equalsIgnoreCase(category))   catColor = "badge-delivered";
                    else if ("starter".equalsIgnoreCase(category)) catColor = "badge-confirmed";
                    else if ("roti".equalsIgnoreCase(category))    catColor = "badge-cancelled";
        %>
        <tr>
            <td style="color:var(--muted);font-size:.78rem">R-<%= restaurantId %></td>
            <td>
                <% if (encodedImage != null) { %>
                    <img src="data:image/jpeg;base64,<%= encodedImage %>" class="food-img" alt="Food">
                <% } else { %>
                    <div style="width:44px;height:44px;border-radius:8px;
                                background:var(--card2);border:1px solid var(--border);
                                display:flex;align-items:center;justify-content:center">
                        <i class="fas fa-image" style="color:var(--muted);font-size:.75rem"></i>
                    </div>
                <% } %>
            </td>
            <td style="font-weight:600;font-size:.85rem"><%= foodName %></td>
            <td>
                <% if (category != null && !category.isEmpty()) { %>
                    <span class="badge <%= catColor %>"><%= category %></span>
                <% } else { %>
                    <span style="color:var(--muted)">—</span>
                <% } %>
            </td>
            <td style="color:var(--muted);font-size:.8rem;max-width:200px"><%= description %></td>
            <td style="font-weight:600;color:var(--green)">₹<%= String.format("%.2f", price) %></td>
            <td>
                <form action="/FDelivery/DeleteFoodServlet" method="post"
                      onsubmit="return confirm('Delete this food item?')">
                    <input type="hidden" name="food_id" value="<%= foodId %>">
                    <button type="submit" class="btn-sm btn-delete">
                        <i class="fas fa-trash"></i> Delete
                    </button>
                </form>
            </td>
        </tr>
        <%
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {
                try {
                    if (rs   != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException ex) { ex.printStackTrace(); }
            }
            if (rowCount == 0) {
        %>
        <tr>
            <td colspan="7">
                <div class="empty-state">
                    <i class="fas fa-bowl-food"></i>
                    <p>No food items found. Add one above.</p>
                </div>
            </td>
        </tr>
        <% } %>
    </tbody>
</table>
</div>
