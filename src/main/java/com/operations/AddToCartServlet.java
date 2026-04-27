package com.operations;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import com.db.ConnectionProvider;

@WebServlet("/AddToCartServlet")
@MultipartConfig
public class AddToCartServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Get food ID from request parameter
		String foodId = request.getParameter("foodId");

		// Perform database insertion here
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			// Establish database connection
			conn = ConnectionProvider.getConnection();

			// SQL query to insert record into cart table
			String sql = "INSERT INTO carts (user_id, food_id, quantity) VALUES (?, ?, ?)";
			pstmt = conn.prepareStatement(sql);

			String user_id = (String) request.getSession().getAttribute("user_id");

			// Set user ID (you need to retrieve this from the session or request)
			pstmt.setInt(1, Integer.parseInt(user_id)); // Replace 1 with actual user ID
			pstmt.setInt(2, Integer.parseInt(foodId));
			pstmt.setInt(3, 1); // Default quantity is 1, you can adjust as needed

			// Execute the query
			int rowsInserted = pstmt.executeUpdate();
			if (rowsInserted > 0) {
				// Cart updated successfully
				response.setStatus(HttpServletResponse.SC_OK);
			} else {
				// Error inserting into cart
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			}
		} catch (SQLException ex) {
			ex.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		} finally {
			// Close resources
			try {
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
	}
}
