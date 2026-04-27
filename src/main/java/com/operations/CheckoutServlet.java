package com.operations;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;
import com.db.ConnectionProvider;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Object userObj = request.getSession().getAttribute("user_id");

        if (userObj == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = Integer.parseInt(userObj.toString());

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet cartRs = null;

        try {
            conn = ConnectionProvider.getConnection();

            // 1. Get cart items
            String cartQuery = "SELECT * FROM carts WHERE user_id = ?";
            pstmt = conn.prepareStatement(cartQuery);
            pstmt.setInt(1, userId);
            cartRs = pstmt.executeQuery();

            // 2. Insert into orders
            String orderQuery = "INSERT INTO orders (user_id, food_id, quantity, total_amount, order_status, order_date) VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
            PreparedStatement orderStmt = conn.prepareStatement(orderQuery);

            while (cartRs.next()) {
                int foodId = cartRs.getInt("food_id");
                int quantity = cartRs.getInt("quantity");

                double totalAmount = getPrice(conn, foodId) * quantity;

                orderStmt.setInt(1, userId);
                orderStmt.setInt(2, foodId);
                orderStmt.setInt(3, quantity);
                orderStmt.setDouble(4, totalAmount);
                orderStmt.setString(5, "Pending");

                orderStmt.executeUpdate();
            }

            // 3. Clear cart
            String deleteCart = "DELETE FROM carts WHERE user_id = ?";
            pstmt = conn.prepareStatement(deleteCart);
            pstmt.setInt(1, userId);
            pstmt.executeUpdate();

            response.setStatus(HttpServletResponse.SC_OK);

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private double getPrice(Connection conn, int foodId) throws SQLException {
        String sql = "SELECT price FROM foods WHERE food_id = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, foodId);

        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            return rs.getDouble("price");
        }
        return 0;
    }
}