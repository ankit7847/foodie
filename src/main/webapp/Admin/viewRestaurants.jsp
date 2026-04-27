<%-- <%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>  --%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Base64" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.db.ConnectionProvider" %>
<div style="overflow-x:auto">
<table class="admin-table">
    <thead>
        <tr>
            <th>ID</th>
            <th>Logo</th>
            <th>Image</th>
            <th>Name</th>
            <th>Description</th>
            <th>Created On</th>
            <th>Actions</th>
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
                String sql = "SELECT * FROM restaurants";
                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();

                while (rs.next()) {
                    rowCount++;
                    int id = rs.getInt("restaurant_id");
                    String name = rs.getString("restaurant_name");
                    String description = rs.getString("description");
                    Timestamp createdOn = rs.getTimestamp("created_on");
                    byte[] imageBytes  = rs.getBytes("restaurant_image");
                    byte[] imageBytes2 = rs.getBytes("restaurant_logo");

                    String encodedImg  = imageBytes  != null ? Base64.getEncoder().encodeToString(imageBytes)  : null;
                    String encodedLogo = imageBytes2 != null ? Base64.getEncoder().encodeToString(imageBytes2) : null;
        %>
        <tr>
            <td style="color:var(--muted);font-size:.78rem">#<%= id %></td>
            <td>
                <% if (encodedLogo != null) { %>
                    <img src="data:image/jpeg;base64,<%= encodedLogo %>" class="logo-img" alt="Logo">
                <% } else { %>
                    <span style="color:var(--muted);font-size:.75rem">—</span>
                <% } %>
            </td>
            <td>
                <% if (encodedImg != null) { %>
                    <img src="data:image/jpeg;base64,<%= encodedImg %>" class="rest-img" alt="Image">
                <% } else { %>
                    <span style="color:var(--muted);font-size:.75rem">—</span>
                <% } %>
            </td>
            <td style="font-weight:600"><%= name %></td>
            <td style="color:var(--muted);max-width:220px;font-size:.8rem"><%= description %></td>
            <td style="color:var(--muted);font-size:.78rem"><%= createdOn %></td>
            <td>
                <div style="display:flex;gap:.4rem;flex-wrap:wrap">
                    <a href="editRestaurant.jsp?id=<%= id %>" class="btn-sm btn-edit">
                        <i class="fas fa-pen"></i> Edit
                    </a>
                    <a href="deleteRestaurant.jsp?id=<%= id %>" class="btn-sm btn-delete"
                       onclick="return confirm('Delete this restaurant?')">
                        <i class="fas fa-trash"></i> Delete
                    </a>
                </div>
            </td>
        </tr>
        <%
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            } finally {
                if (rs    != null) try { rs.close();    } catch (SQLException ex) {}
                if (pstmt != null) try { pstmt.close(); } catch (SQLException ex) {}
                if (conn  != null) try { conn.close();  } catch (SQLException ex) {}
            }
            if (rowCount == 0) {
        %>
        <tr>
            <td colspan="7">
                <div class="empty-state">
                    <i class="fas fa-store"></i>
                    <p>No restaurants found. Add one above.</p>
                </div>
            </td>
        </tr>
        <% } %>
    </tbody>
</table>
</div>
