package com.operations;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;
import com.db.ConnectionProvider;


@WebServlet("/DeleteFoodServlet")
public class DeleteFoodServlet extends HttpServlet {
    
    
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get food ID from the request parameter
        String foodIdStr = request.getParameter("food_id");
        int foodId = Integer.parseInt(foodIdStr);

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Establish database connection
            conn = ConnectionProvider.getConnection();

            // SQL query to delete food record
            String sql = "DELETE FROM foods WHERE food_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, foodId);

            // Execute the query
            int rowsDeleted = pstmt.executeUpdate();
            
            // Redirect back to viewFood.jsp after deletion
            response.sendRedirect("/FDelivery/Admin/viewFood.jsp");
        } catch (Exception ex) {
            ex.printStackTrace();
            // Handle exception, maybe display an error message
        } finally {
            // Close resources
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
}

