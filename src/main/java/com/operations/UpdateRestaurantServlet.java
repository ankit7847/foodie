package com.operations;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.db.ConnectionProvider;

@WebServlet("/UpdateRestaurantServlet")
@MultipartConfig
public class UpdateRestaurantServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Get form data
		String id = request.getParameter("id");
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
			conn = ConnectionProvider.getConnection();

			// Update restaurant details
			String sql = "UPDATE restaurants SET restaurant_name=?, description=?, restaurant_image=? WHERE restaurant_id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, name);
			pstmt.setString(2, description);
			if (inputStream != null) {
				pstmt.setBlob(3, inputStream);
			} else {
				pstmt.setNull(3, Types.BLOB);
			}
			pstmt.setString(4, id);
			int rowsUpdated = pstmt.executeUpdate();
			if (rowsUpdated > 0) {
				response.sendRedirect("/FDelivery/Admin/viewRestaurants.jsp");
			} else {
				response.sendRedirect("editRestaurant.jsp?id=" + id);
			}
		} catch (SQLException ex) {
			ex.printStackTrace();
			response.sendRedirect("editRestaurant.jsp?id=" + id);
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
