package com.validate;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.db.ConnectionProvider;

@WebServlet("/login")
public class Login extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // ✅ Get parameters
        String email = req.getParameter("email");
        String pwd = req.getParameter("password");
        String usertype = req.getParameter("usertype");

        // ✅ Trim inputs
        if (email != null) email = email.trim();
        if (pwd != null) pwd = pwd.trim();
        if (usertype != null) usertype = usertype.trim();

        // ✅ Validate empty input
        if (email == null || pwd == null || usertype == null ||
            email.isEmpty() || pwd.isEmpty() || usertype.isEmpty()) {

            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=invalid_credentials");
            return;
        }

        // ✅ Database logic with auto-close
        try (Connection con = ConnectionProvider.getConnection()) {

            // 🔹 Check email + password + role
            String sql = "SELECT * FROM users WHERE email = ? AND password = ? AND usertype = ?";
            try (PreparedStatement pst = con.prepareStatement(sql)) {

                pst.setString(1, email);
                pst.setString(2, pwd);
                pst.setString(3, usertype);

                try (ResultSet rs = pst.executeQuery()) {

                    if (rs.next()) {

                        // ✅ Create session
                        HttpSession session = req.getSession();

                        session.setAttribute("user_id", rs.getString("user_id"));
                        session.setAttribute("email", email);
                        session.setAttribute("usertype", usertype);

                        // ✅ Extra user info (optional but useful)
                        session.setAttribute("full_name", rs.getString("full_name"));
                        session.setAttribute("phone", rs.getString("phone_number"));
                        session.setAttribute("address", rs.getString("address"));

                        // ✅ Redirect
                        if ("admin".equals(usertype)) {
                            resp.sendRedirect(req.getContextPath() + "/Admin/dashboard.jsp");
                        } else {
                            resp.sendRedirect(req.getContextPath() + "/index.jsp");
                        }
                        return;
                    }
                }
            }

            // 🔹 Check if credentials correct but wrong role
            String checkSql = "SELECT * FROM users WHERE email = ? AND password = ?";
            try (PreparedStatement pst2 = con.prepareStatement(checkSql)) {

                pst2.setString(1, email);
                pst2.setString(2, pwd);

                try (ResultSet rs2 = pst2.executeQuery()) {

                    if (rs2.next()) {
                        resp.sendRedirect(req.getContextPath() + "/login.jsp?error=wrong_usertype");
                    } else {
                        resp.sendRedirect(req.getContextPath() + "/login.jsp?error=invalid_credentials");
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=database_error");
        }
    }
}