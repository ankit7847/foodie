<%@ page import="java.sql.*, com.db.ConnectionProvider, java.text.SimpleDateFormat" %>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String action = request.getParameter("action");
    String msgId  = request.getParameter("id");

    if ("markRead".equals(action) && msgId != null) {
        try {
            con = ConnectionProvider.getConnection();
            ps  = con.prepareStatement("UPDATE contact_messages SET is_read = 1 WHERE id = ?");
            ps.setInt(1, Integer.parseInt(msgId));
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        finally { if (con != null) try { con.close(); } catch (Exception ignored) {} }

        response.sendRedirect(request.getContextPath() + "/Admin/viewMessages.jsp");
        return;
    }

    if ("delete".equals(action) && msgId != null) {
        try {
            con = ConnectionProvider.getConnection();
            ps  = con.prepareStatement("DELETE FROM contact_messages WHERE id = ?");
            ps.setInt(1, Integer.parseInt(msgId));
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        finally { if (con != null) try { con.close(); } catch (Exception ignored) {} }

        response.sendRedirect(request.getContextPath() + "/Admin/viewMessages.jsp");
        return;
    }
%>
<div style="overflow-x:auto">
<table class="admin-table">
    <thead>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Message</th>
            <th>Date</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        <%
            int rowCount = 0;
            try {
                con = ConnectionProvider.getConnection();
                ps  = con.prepareStatement(
                    "SELECT id, CONCAT(fname,' ',lname) AS name, email, message, is_read, created_at " +
                    "FROM contact_messages ORDER BY created_at DESC"
                );
                rs = ps.executeQuery();
                SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");

                while (rs.next()) {
                    rowCount++;
                    int    id      = rs.getInt("id");
                    String name    = rs.getString("name");
                    String email   = rs.getString("email");
                    String message = rs.getString("message");
                    int    isRead  = rs.getInt("is_read");
                    String date    = sdf.format(rs.getTimestamp("created_at"));
        %>
        <tr>
            <td style="color:var(--muted);font-size:.78rem">#<%= id %></td>
            <td>
                <div style="display:flex;align-items:center;gap:.55rem">
                    <div style="width:30px;height:30px;border-radius:50%;flex-shrink:0;
                                background:rgba(232,160,62,.12);
                                display:flex;align-items:center;justify-content:center;
                                font-size:.68rem;font-weight:700;color:var(--accent)">
                        <%= name != null && name.length() > 0 ? String.valueOf(name.charAt(0)).toUpperCase() : "?" %>
                    </div>
                    <span style="font-weight:600;font-size:.85rem"><%= name %></span>
                </div>
            </td>
            <td style="color:var(--muted);font-size:.8rem"><%= email %></td>
            <td style="font-size:.82rem;max-width:240px;color:var(--text)">
                <span title="<%= message %>">
                    <%= message != null && message.length() > 80
                        ? message.substring(0, 80) + "…"
                        : message %>
                </span>
            </td>
            <td style="color:var(--muted);font-size:.75rem;white-space:nowrap"><%= date %></td>
            <td>
                <% if (isRead == 0) { %>
                    <span class="badge badge-pending">
                        <i class="fas fa-circle" style="font-size:.45rem"></i> Unread
                    </span>
                <% } else { %>
                    <span class="badge badge-delivered">
                        <i class="fas fa-check"></i> Read
                    </span>
                <% } %>
            </td>
            <td>
                <div style="display:flex;gap:.4rem;flex-wrap:wrap">
                    <% if (isRead == 0) { %>
                        <a href="viewMessages.jsp?action=markRead&id=<%= id %>" class="btn-sm btn-update">
                            <i class="fas fa-check-double"></i> Mark Read
                        </a>
                    <% } %>
                    <a href="viewMessages.jsp?action=delete&id=<%= id %>"
                       class="btn-sm btn-delete"
                       onclick="return confirm('Delete this message?')">
                        <i class="fas fa-trash"></i> Delete
                    </a>
                </div>
            </td>
        </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if (rs  != null) rs.close();
                    if (ps  != null) ps.close();
                    if (con != null) con.close();
                } catch (Exception e) {}
            }
            if (rowCount == 0) {
        %>
        <tr>
            <td colspan="7">
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <p>No messages yet.</p>
                </div>
            </td>
        </tr>
        <% } %>
    </tbody>
</table>
</div>
