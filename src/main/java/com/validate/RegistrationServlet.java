package com.validate;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.db.ConnectionProvider;

@WebServlet("/RegistrationServlet")
public class RegistrationServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Retrieve form parameters
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String email = request.getParameter("email");
		String fullname = request.getParameter("fullname");
		String phonenumber = request.getParameter("phonenumber");
		String address = request.getParameter("address");
		String dob = request.getParameter("dob");
		String gender = request.getParameter("gender");

		// JDBC variables for opening, closing and managing connection
		try (Connection conn = ConnectionProvider.getConnection()) {
			// The MySQL insert statement
			String query = "INSERT INTO users (username, password, email, full_name, phone_number, address, date_of_birth, gender) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

			// Create a prepared statement
			PreparedStatement preparedStatement = conn.prepareStatement(query);
			preparedStatement.setString(1, username);
			preparedStatement.setString(2, password);
			preparedStatement.setString(3, email);
			preparedStatement.setString(4, fullname);
			preparedStatement.setString(5, phonenumber);
			preparedStatement.setString(6, address);
			preparedStatement.setString(7, dob);
			preparedStatement.setString(8, gender);

			// Execute the query
			int rowsInserted = preparedStatement.executeUpdate();
			if (rowsInserted > 0) {
				// Registration successful
				// Redirect the user to the login page with a success message
				response.sendRedirect("login.jsp?registration=success");
			} else {
				// Registration failed
				// Redirect the user to the registration page with an error message
				response.sendRedirect("registration.jsp?error=registration_failed");
			}
		} catch (SQLException ex) {
			ex.printStackTrace();
			// Redirect the user to the registration page with an error message
			response.sendRedirect("registration.jsp?error=database_error");
		}
	}
}
