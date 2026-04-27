package com.operations;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.db.ConnectionProvider;

@WebServlet("/CancelOrderServlet")
public class CancelOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== CancelOrderServlet HIT ===");

        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

        HttpSession session = request.getSession(false);
        System.out.println("Session: " + (session == null ? "NULL - not logged in" : "EXISTS, id=" + session.getId()));

        if (session == null) {
            System.out.println("Redirecting to login - no session");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String userId  = (String) session.getAttribute("user_id");
        String orderId = request.getParameter("order_id");

        System.out.println("user_id from session : [" + userId + "]");
        System.out.println("order_id from request: [" + orderId + "]");

        if (userId == null || userId.trim().isEmpty()
                || orderId == null || orderId.trim().isEmpty()) {
            System.out.println("Validation FAILED - userId or orderId is null/empty");
            response.sendRedirect(request.getContextPath() + "/orders.jsp?error=invalid");
            return;
        }

        int userIdInt, orderIdInt;
        try {
            userIdInt  = Integer.parseInt(userId.trim());
            orderIdInt = Integer.parseInt(orderId.trim());
            System.out.println("Parsed userIdInt=" + userIdInt + ", orderIdInt=" + orderIdInt);
        } catch (NumberFormatException e) {
            System.out.println("NumberFormatException parsing ids: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/orders.jsp?error=invalid");
            return;
        }

        Connection conn = null;
        PreparedStatement checkStmt  = null;
        PreparedStatement updateStmt = null;
        ResultSet rs = null;

        try {
            System.out.println("Attempting DB connection...");
            conn = ConnectionProvider.getConnection();
            System.out.println("DB connection OK: " + conn);

            String checkSql = "SELECT order_status FROM orders WHERE order_id = ? AND user_id = ?";
            System.out.println("Running check query: order_id=" + orderIdInt + ", user_id=" + userIdInt);
            checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, orderIdInt);
            checkStmt.setInt(2, userIdInt);
            rs = checkStmt.executeQuery();

            if (!rs.next()) {
                System.out.println("RESULT: No order found for order_id=" + orderIdInt + " AND user_id=" + userIdInt);
                response.sendRedirect(request.getContextPath() + "/orders.jsp?error=notfound");
                return;
            }

            String currentStatus = rs.getString("order_status");
            System.out.println("RESULT: Order found, current status=[" + currentStatus + "]");

            if (!"Pending".equalsIgnoreCase(currentStatus)) {
                System.out.println("Status is not Pending - cannot cancel. Redirecting notcancellable.");
                response.sendRedirect(request.getContextPath() + "/orders.jsp?error=notcancellable");
                return;
            }

            System.out.println("Status is Pending - proceeding with UPDATE...");
            String updateSql = "UPDATE orders SET order_status = ?, cancel_by_user = ? WHERE order_id = ? AND user_id = ?";
            updateStmt = conn.prepareStatement(updateSql);
            updateStmt.setString(1, "Cancelled");
            updateStmt.setInt(2, 1);
            updateStmt.setInt(3, orderIdInt);
            updateStmt.setInt(4, userIdInt);

            int rows = updateStmt.executeUpdate();
            System.out.println("UPDATE rows affected: " + rows);

            if (rows > 0) {
                System.out.println("Cancel SUCCESS - redirecting with cancelled=1");
                response.sendRedirect(request.getContextPath() + "/orders.jsp?cancelled=1");
                return;
            } else {
                System.out.println("UPDATE ran but 0 rows affected - redirecting updatefailed");
                response.sendRedirect(request.getContextPath() + "/orders.jsp?error=updatefailed");
                return;
            }

        } catch (SQLException e) {
            System.out.println("SQLException caught: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/orders.jsp?error=db");
            return;
        } finally {
            System.out.println("Finally block - closing resources");
            try {
                if (rs != null) rs.close();
                if (checkStmt != null) checkStmt.close();
                if (updateStmt != null) updateStmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            System.out.println("=== CancelOrderServlet END ===");
        }
    }
}