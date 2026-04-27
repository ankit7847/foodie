package com.operations;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;
import com.db.ConnectionProvider;

@WebServlet("/RemoveFromCartServlet")
@MultipartConfig
public class RemoveFromCartServlet extends HttpServlet {
    
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get cart ID from request parameter
        int cartId = Integer.parseInt(request.getParameter("cartId"));

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Establish database connection
            conn = ConnectionProvider.getConnection();

            // SQL query to delete record from cart table
            String sql = "DELETE FROM carts WHERE cart_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, cartId);

            // Execute the query
            int rowsDeleted = pstmt.executeUpdate();
            if (rowsDeleted > 0) {
                // Item removed successfully, redirect back to cart page
                response.sendRedirect("/FDelivery/cart.jsp?status=success");
            } else {
                // Item not found or error occurred
                // Redirect back to cart page with error message
                response.sendRedirect("/FDelivery/cart.jsp?error=1");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            // Handle database error
            // Redirect back to cart page with error message
            response.sendRedirect("/FDelivery/cart.jsp?error=1");
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

