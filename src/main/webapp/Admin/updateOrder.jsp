<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Base64" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.db.ConnectionProvider" %>
<div style="overflow-x:auto">
<table class="admin-table">
    <thead>
        <tr>
            <th>Order ID</th>
            <th>User ID</th>
            <th>Food</th>
            <th>Qty</th>
            <th>Total</th>
            <th>Status</th>
            <th>Date</th>
            <th>Action</th>
        </tr>
    </thead>
    <tbody>
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            int rowCount = 0;
            try {
                conn = ConnectionProvider.getConnection();
                String selectQuery =
                    "SELECT o.order_id, o.user_id, f.food_name, f.food_profile, " +
                    "o.quantity, o.total_amount, o.order_status, o.order_date " +
                    "FROM orders o INNER JOIN foods f ON o.food_id = f.food_id";
                pstmt = conn.prepareStatement(selectQuery);
                rs = pstmt.executeQuery();

                while (rs.next()) {
                    rowCount++;
                    int    orderId     = rs.getInt("order_id");
                    int    userId      = rs.getInt("user_id");
                    String foodName    = rs.getString("food_name");
                    int    quantity    = rs.getInt("quantity");
                    double totalAmount = rs.getDouble("total_amount");
                    String orderStatus = rs.getString("order_status");
                    Timestamp orderDate = rs.getTimestamp("order_date");

                    byte[] foodProfileBytes = null;
                    try (InputStream foodProfileStream = rs.getBinaryStream("food_profile");
                         ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
                        if (foodProfileStream != null) {
                            byte[] buffer = new byte[1024];
                            int bytesRead;
                            while ((bytesRead = foodProfileStream.read(buffer)) != -1) {
                                baos.write(buffer, 0, bytesRead);
                            }
                            foodProfileBytes = baos.toByteArray();
                        }
                    } catch (Exception e) { e.printStackTrace(); }

                    String foodProfileBase64 = foodProfileBytes != null
                        ? Base64.getEncoder().encodeToString(foodProfileBytes) : null;

                    // Badge class
                    String badgeClass = "badge-pending";
                    if      ("Confirmed".equals(orderStatus)) badgeClass = "badge-confirmed";
                    else if ("Delivered".equals(orderStatus)) badgeClass = "badge-delivered";
                    else if ("Cancelled".equals(orderStatus)) badgeClass = "badge-cancelled";
        %>
        <tr>
            <td style="font-weight:600;color:var(--accent)">#<%= orderId %></td>
            <td style="color:var(--muted);font-size:.8rem">U-<%= userId %></td>
            <td>
                <div style="display:flex;align-items:center;gap:.6rem">
                    <% if (foodProfileBase64 != null) { %>
                        <img src="data:image/jpeg;base64,<%= foodProfileBase64 %>"
                             class="food-img" alt="Food">
                    <% } %>
                    <span style="font-weight:500;font-size:.85rem"><%= foodName %></span>
                </div>
            </td>
            <td style="font-size:.85rem"><%= quantity %></td>
            <td style="font-weight:600;color:var(--green)">₹<%= String.format("%.2f", totalAmount) %></td>
            <td><span class="badge <%= badgeClass %>"><%= orderStatus %></span></td>
            <td style="color:var(--muted);font-size:.75rem"><%= orderDate %></td>
            <td>
                <form action="/FDelivery/UpdateOrderStatus" method="post"
                      style="display:flex;align-items:center;gap:.5rem;flex-wrap:wrap">
                    <input type="hidden" name="order_id" value="<%= orderId %>">
                    <select name="order_status" class="status-select">
                        <option value="Pending"   <%= "Pending".equals(orderStatus)   ? "selected" : "" %>>Pending</option>
                        <option value="Confirmed" <%= "Confirmed".equals(orderStatus) ? "selected" : "" %>>Confirmed</option>
                        <option value="Delivered" <%= "Delivered".equals(orderStatus) ? "selected" : "" %>>Delivered</option>
                        <option value="Cancelled" <%= "Cancelled".equals(orderStatus) ? "selected" : "" %>>Cancelled</option>
                    </select>
                    <button type="submit" class="btn-sm btn-update">
                        <i class="fas fa-check"></i> Update
                    </button>
                </form>
            </td>
        </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if (rs    != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn  != null) conn.close();
                } catch (SQLException e) { e.printStackTrace(); }
            }
            if (rowCount == 0) {
        %>
        <tr>
            <td colspan="8">
                <div class="empty-state">
                    <i class="fas fa-receipt"></i>
                    <p>No orders yet.</p>
                </div>
            </td>
        </tr>
        <% } %>
    </tbody>
</table>
</div>
