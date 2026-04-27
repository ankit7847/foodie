package com.validate;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Register extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public static Connection getConnection() {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","fdelivery","fdelivery");
			
			if(con == null) {
				System.out.println("Connectin Failed !");
			}else {
				System.out.println("Connection Successful !");
				return con;
			}	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;

	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String name = req.getParameter("name");
		String email = req.getParameter("email");
		String pwd = req.getParameter("pwd");
		
		try {
			Connection con  = getConnection();
			PreparedStatement pst = con.prepareStatement("insert into users values(?,?,?)");
			pst.setString(1,name);
			pst.setString(2,email);
			pst.setString(3,pwd);
			
			int res = pst.executeUpdate();
			if(res > 0) {
				System.out.println("Records inserted Successfully !");
			}else {
				System.out.println("Faild to insert data !");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
	}

}
