<%-- 
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> --%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, java.io.*, java.util.Base64" %>
<%@ page import="com.db.ConnectionProvider" %>
<div style="overflow-x:auto">
<table class="admin-table">
    <thead>
        <tr>
            <th>ID</th>
            <th>Avatar</th>
            <th>Username</th>
            <th>Full Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Gender</th>
            <th>DOB</th>
            <th>Address</th>
            <th>Bio</th>
            <th>Joined</th>
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
                rs = stmt.executeQuery("SELECT * FROM users");

                while (rs.next()) {
                    rowCount++;
                    int    userId      = rs.getInt("user_id");
                    String username    = rs.getString("username");
                    String email       = rs.getString("email");
                    String fullName    = rs.getString("full_name");
                    String phoneNumber = rs.getString("phone_number");
                    String address     = rs.getString("address");
                    Date   dateOfBirth = rs.getDate("date_of_birth");
                    String gender      = rs.getString("gender");
                    String profilePic  = rs.getString("profile_picture");
                    String bio         = rs.getString("bio");
                    Timestamp createdAt = rs.getTimestamp("created_at");

                    // Initials avatar fallback
                    String initials = "?";
                    if (fullName != null && !fullName.trim().isEmpty()) {
                        String[] parts = fullName.trim().split(" ");
                        initials = parts.length >= 2
                            ? String.valueOf(parts[0].charAt(0)) + String.valueOf(parts[1].charAt(0))
                            : String.valueOf(parts[0].charAt(0));
                        initials = initials.toUpperCase();
                    }

                    String genderBadge = "gender".equals(gender) ? "" :
                        "Female".equalsIgnoreCase(gender) ? "color:var(--blue)" : "color:var(--accent)";
        %>
        <tr>
            <td style="color:var(--muted);font-size:.78rem">#<%= userId %></td>
            <td>
                <% if (profilePic != null && !profilePic.isEmpty()) { %>
                    <img src="<%= profilePic %>" alt="avatar"
                         style="width:34px;height:34px;border-radius:50%;object-fit:cover;border:1px solid var(--border)">
                <% } else { %>
                    <div style="width:34px;height:34px;border-radius:50%;
                                background:rgba(232,160,62,.15);
                                display:flex;align-items:center;justify-content:center;
                                font-size:.7rem;font-weight:700;color:var(--accent);
                                border:1px solid rgba(232,160,62,.2)">
                        <%= initials %>
                    </div>
                <% } %>
            </td>
            <td style="font-weight:600;font-size:.85rem"><%= username %></td>
            <td style="font-size:.85rem"><%= fullName != null ? fullName : "—" %></td>
            <td style="color:var(--muted);font-size:.8rem"><%= email %></td>
            <td style="font-size:.82rem"><%= phoneNumber != null ? phoneNumber : "—" %></td>
            <td>
                <% if (gender != null && !gender.isEmpty()) { %>
                    <span class="badge badge-confirmed" style="<%= genderBadge %>"><%= gender %></span>
                <% } else { %>
                    <span style="color:var(--muted)">—</span>
                <% } %>
            </td>
            <td style="color:var(--muted);font-size:.78rem"><%= dateOfBirth != null ? dateOfBirth : "—" %></td>
            <td style="color:var(--muted);font-size:.78rem;max-width:140px"><%= address != null ? address : "—" %></td>
            <td style="color:var(--muted);font-size:.78rem;max-width:160px"><%= bio != null ? bio : "—" %></td>
            <td style="color:var(--muted);font-size:.75rem"><%= createdAt %></td>
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
            <td colspan="11">
                <div class="empty-state">
                    <i class="fas fa-users"></i>
                    <p>No registered users yet.</p>
                </div>
            </td>
        </tr>
        <% } %>
    </tbody>
</table>
</div>
