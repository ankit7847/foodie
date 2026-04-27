package com.db;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConnectionProvider {

	public static Connection getConnection() {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");

			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/fdelivery", "root",
					"ankit@21");

			if (con != null) {
				System.out.println("Connection successful in ConnectionProvider...");
				return con;
			} else {
				System.out.println("Connection has been faild in ConnectionProvider...");
				return null;
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
}
