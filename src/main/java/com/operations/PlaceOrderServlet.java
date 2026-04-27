package com.operations;

import com.db.ConnectionProvider;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/PlaceOrderServlet")
public class PlaceOrderServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // ✅ safer way to get user_id
        Object userObj = session.getAttribute("user_id");
        if (userObj == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = Integer.parseInt(userObj.toString());

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = ConnectionProvider.getConnection();

            // 1. Get cart total
            String totalSql = "SELECT SUM(f.price * c.quantity) FROM carts c " +
                              "JOIN foods f ON c.food_id = f.food_id WHERE c.user_id = ?";
            pstmt = conn.prepareStatement(totalSql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();

            double total = 0;
            if (rs.next()) {
                total = rs.getDouble(1);
            }

            total = total + 2.00 + (total * 0.05); // delivery + tax

            // 2. Insert into orders
            String orderSql = "INSERT INTO orders (user_id, total_amount, status) VALUES (?, ?, 'Placed')";
            pstmt = conn.prepareStatement(orderSql);
            pstmt.setInt(1, userId);
            pstmt.setDouble(2, total);
            pstmt.executeUpdate();

            // 3. Clear cart
            String clearSql = "DELETE FROM carts WHERE user_id = ?";
            pstmt = conn.prepareStatement(clearSql);
            pstmt.setInt(1, userId);
            pstmt.executeUpdate();

            // 4. Redirect to payment page (better flow)
            response.sendRedirect(request.getContextPath() + "/payment.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("cart.jsp?error=1");
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}