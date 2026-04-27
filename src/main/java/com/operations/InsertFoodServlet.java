package com.operations;
import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;
import com.db.ConnectionProvider;

@WebServlet("/InsertFoodServlet")
@MultipartConfig
public class InsertFoodServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String restaurantId = request.getParameter("restaurant_id");
        String foodName = request.getParameter("food_name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String category = request.getParameter("category"); // ✅ GET CATEGORY

        double price = Double.parseDouble(priceStr);

        Part filePart = request.getPart("image_file");
        InputStream inputStream = null;
        if (filePart != null && filePart.getSize() > 0) {
            inputStream = filePart.getInputStream();
        }

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = ConnectionProvider.getConnection();

            // ✅ ADD category TO INSERT QUERY
            String sql = "INSERT INTO foods (restaurant_id, food_name, description, price, food_profile, category) VALUES (?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, restaurantId);
            pstmt.setString(2, foodName);
            pstmt.setString(3, description);
            pstmt.setDouble(4, price);
            pstmt.setBlob(5, inputStream);
            pstmt.setString(6, category); // ✅ SET CATEGORY VALUE

            int rowsInserted = pstmt.executeUpdate();

            if (rowsInserted > 0) {
                response.sendRedirect("/FDelivery/Admin/dashboard.jsp?status=success");
            } else {
                response.sendRedirect("/FDelivery/Admin/dashboard.jsp?status=failed");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect("/FDelivery/Admin/dashboard.jsp?error=catch");
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
}