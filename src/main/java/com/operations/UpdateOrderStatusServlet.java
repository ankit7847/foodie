package com.operations;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.db.ConnectionProvider;

@WebServlet("/UpdateOrderStatus")
public class UpdateOrderStatusServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		int orderId = Integer.parseInt(request.getParameter("order_id"));
		String newStatus = request.getParameter("order_status");

		try {
			// Get connection using ConnectionProvider
			Connection conn = ConnectionProvider.getConnection();

			String updateQuery = "UPDATE orders SET order_status = ? WHERE order_id = ?";
			PreparedStatement pstmt = conn.prepareStatement(updateQuery);
			pstmt.setString(1, newStatus);
			pstmt.setInt(2, orderId);
			int rowsAffected = pstmt.executeUpdate();
			conn.close();

			PrintWriter out = response.getWriter();
			if (rowsAffected > 0) {
				out.println("<html><body><h3>Order status updated successfully!</h3></body></html>");
				response.sendRedirect("/FDelivery/Admin/dashboard.jsp?status=success");
			} else {
				out.println("<html><body><h3>Failed to update order status!</h3></body></html>");
				response.sendRedirect("/FDelivery/Admin/dashboard.jsp?status=failed");
			}
		} catch (Exception e) {
			PrintWriter out = response.getWriter();
			out.println("<html><body><h3>Error: " + e.getMessage() + "</h3></body></html>");
			e.printStackTrace();
		}
	}
}
