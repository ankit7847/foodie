<%@ page import="java.sql.*,com.db.ConnectionProvider" %>
<%@ page import="java.io.*" %>

<%
    // Get restaurant ID parameter from the request
    String id = request.getParameter("id");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
    	conn = ConnectionProvider.getConnection();
    	
        // Delete restaurant record
        String sql = "DELETE FROM restaurants WHERE restaurant_id=?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, id);
        int rowsDeleted = pstmt.executeUpdate();
        if (rowsDeleted > 0) {
            response.sendRedirect("viewRestaurants.jsp?delete=success");
        } else {
            response.sendRedirect("viewRestaurants.jsp?delete=failed"); // Redirect to viewRestaurants.jsp regardless of deletion status
        }
    } catch (SQLException ex) {
        ex.printStackTrace();
        response.sendRedirect("viewRestaurants.jsp"); // Redirect to viewRestaurants.jsp in case of exception
    } finally {
        // Close resources
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
%>
