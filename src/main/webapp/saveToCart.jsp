<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Save to Cart</title>
</head>
<body>
		
		
		<%
		java.util.Date date = new java.util.Date();
	    long t = date.getTime();
	    java.sql.Timestamp sqlTimestamp = new java.sql.Timestamp(t);
	      
		String product = request.getParameter("product");
		int price = Integer.parseInt(request.getParameter("price"));
		int quantity = Integer.parseInt(request.getParameter("quantity"));
		
		String email = (String)session.getAttribute("email");
		
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","fdelivery","fdelivery");
			
			if(con == null) {
				System.out.println("Connectin Failed !");
			}else {
				System.out.println("Connection Successful !");
			}
			
			PreparedStatement instCartPst = con.prepareStatement("insert into cart values(?,?,?,?,?,?)");
			instCartPst.setString(1, email);
			instCartPst.setString(2, product);
			instCartPst.setInt(3, price);
			instCartPst.setInt(4, quantity);
			instCartPst.setString(5, "in_cart");
			instCartPst.setTimestamp(6, sqlTimestamp);
			
			int res = instCartPst.executeUpdate();
			
			String redirectUrl = "index.jsp";
			
			if(res > 0){
				System.out.println("Product Added to the Cart !");
				response.sendRedirect(redirectUrl);
			}else{
				System.out.println("Failed to add product to Cart !");
				response.sendRedirect(redirectUrl);
			}
			
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		%>
</body>
</html>