package com.validate;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.dao.User;
import com.db.ConnectionProvider;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email    = request.getParameter("email");
        String password = request.getParameter("password");
        String usertype = request.getParameter("usertype"); // ✅ Get usertype from form

        try (Connection conn = ConnectionProvider.getConnection()) {

            // ✅ Query now includes usertype check
            String query = "SELECT * FROM users WHERE email = ? AND password = ? AND usertype = ?";
            PreparedStatement preparedStatement = conn.prepareStatement(query);
            preparedStatement.setString(1, email);
            preparedStatement.setString(2, password);
            preparedStatement.setString(3, usertype);

            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {

                // ✅ Admin redirect
                if ("admin".equals(usertype)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("email", email);
                    session.setAttribute("usertype", "admin");
                    response.sendRedirect(request.getContextPath() + "/Admin/dashboard.jsp");
                    return;
                }

                // ✅ Normal user
                User user = new User();
                user.setEmail(resultSet.getString("email"));
                user.setFullName(resultSet.getString("full_name"));
                user.setPhoneNumber(resultSet.getString("phone_number"));
                user.setAddress(resultSet.getString("address"));
                user.setDateOfBirth(resultSet.getString("date_of_birth"));
                user.setGender(resultSet.getString("gender"));

                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("usertype", "user");

                response.sendRedirect("index.jsp?msg=success");

            } else {

                // ✅ Check if credentials are correct but wrong usertype selected
                String checkQuery = "SELECT * FROM users WHERE email = ? AND password = ?";
                PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
                checkStmt.setString(1, email);
                checkStmt.setString(2, password);
                ResultSet checkRs = checkStmt.executeQuery();

                if (checkRs.next()) {
                    // Credentials OK but wrong role
                    response.sendRedirect("login.jsp?error=wrong_usertype");
                } else {
                    // Wrong credentials
                    response.sendRedirect("login.jsp?error=invalid_credentials");
                }
            }

        } catch (SQLException ex) {
            ex.printStackTrace();
            response.sendRedirect("login.jsp?error=database_error");
        }
    }
}