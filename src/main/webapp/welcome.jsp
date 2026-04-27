<%@page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	
	<% 	String email = request.getParameter("email");
		String userId = request.getParameter("user_id");
		session.setAttribute("email", email);
		session.setAttribute("user_id",userId);
	%>
	<p>Welcome  </p>
	<%=session.getAttribute("email") %>
	
	<%
		String url = "index.jsp";
		response.sendRedirect(url); %>
</body>
</html>