<%@ page import="java.sql.*,com.db.ConnectionProvider" %>
<%@ page import="java.io.*" %>

<%

	if(request.getParameter("update_data") != null){
		
	
	    // Get form data
	    String id = request.getParameter("id");
	
		System.out.println("id = " + id);
		
	    String name = request.getParameter("restaurantName");
	    String description = request.getParameter("description");
	    Part filePart = request.getPart("restaurantImage");
	    InputStream inputStream = null;
	    if (filePart != null) {
	        inputStream = filePart.getInputStream();
	    }
	
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	
	    try {
	    	// Establish database connection
	        conn = ConnectionProvider.getConnection();
	        // Update restaurant details
	        String sql = "UPDATE restaurants SET restaurant_name=?, description=?, restaurant_image=? WHERE restaurant_id=?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, name);
	        pstmt.setString(2, description);
	        
	        
	        System.out.println(pstmt);
	        
	        if (inputStream != null) {
	            pstmt.setBlob(3, inputStream);
	        } else {
	            pstmt.setNull(3, Types.BLOB);
	        }
	        pstmt.setString(4, id);
	        int rowsUpdated = pstmt.executeUpdate();
	        if (rowsUpdated > 0) {
	            out.println("<script>alert('Restaurant updated successfully');</script>");
	            response.sendRedirect("viewRestaurants.jsp");
	        } else {
	            out.println("<script>alert('Failed to update restaurant');</script>");
	            response.sendRedirect("editRestaurant.jsp?id=" + id);
	        }
	    } catch (SQLException ex) {
	        ex.printStackTrace();
	        out.println("<script>alert('An error occurred while updating the restaurant');</script>");
	        response.sendRedirect("editRestaurant.jsp?id=" + id);
	    } finally {
	        // Close resources
	        if (pstmt != null) try { pstmt.close(); } catch (SQLException ex) { /* ignored */ }
	        if (conn != null) try { conn.close(); } catch (SQLException ex) { /* ignored */ }
	    }
	}
%>
