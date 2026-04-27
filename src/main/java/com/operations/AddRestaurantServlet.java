package com.operations;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.db.ConnectionProvider;

@WebServlet("/AddRestaurantServlet")
@MultipartConfig(maxFileSize = 16177215) // 16 MB
public class AddRestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String restaurantName = request.getParameter("restaurantName");
        String description = request.getParameter("description");
        InputStream inputStream = null;
        InputStream inputStream2 = null;
        
        Part filePart = request.getPart("restaurantImage");
        Part filePart2 = request.getPart("restaurantLogo");
        
        if (filePart != null) {
            inputStream = filePart.getInputStream();
            inputStream2 = filePart2.getInputStream();
        }

        Connection conn = null;
        String message = null;

        try {
        	
            
            conn = ConnectionProvider.getConnection();
            
            String sql = "INSERT INTO restaurants (restaurant_name, restaurant_image, description, created_on, restaurant_logo) values (?, ?, ?, ?, ?)";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, restaurantName);
            statement.setBlob(2, inputStream);
            statement.setString(3, description);
            statement.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            statement.setBlob(5, inputStream2);
            
            int row = statement.executeUpdate();
            if (row > 0) {
                message = "Restaurant added successfully!";
               
            }
        } catch (SQLException ex) {
            message = "ERROR: " + ex.getMessage();
            ex.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            request.setAttribute("message", message);
            // Redirect to result.jsp after processing
            response.sendRedirect("/FDelivery/Admin/dashboard.jsp");
        }
    }
}

