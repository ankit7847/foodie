<%@ page import="java.sql.*" %>
<%@ page import="com.db.ConnectionProvider" %>

<%
String fname = request.getParameter("fname");
String lname = request.getParameter("lname");
String email = request.getParameter("email");
String phone = request.getParameter("phone");
String subject = request.getParameter("subject");
String rating = request.getParameter("rating");
String message = request.getParameter("message");

try {
	Connection con = ConnectionProvider.getConnection();

    PreparedStatement ps = con.prepareStatement(
        "INSERT INTO contact_messages(fname, lname, email, phone, subject, rating, message) VALUES (?, ?, ?, ?, ?, ?, ?)"
    );

    ps.setString(1, fname);
    ps.setString(2, lname);
    ps.setString(3, email);
    ps.setString(4, phone);
    ps.setString(5, subject);
    ps.setString(6, rating);
    ps.setString(7, message);

    int i = ps.executeUpdate();

    if(i > 0){
        response.sendRedirect("contact.jsp?msg=success");
    } else {
        out.println("FAILED");
    }

} catch(Exception e){
    out.println("ERROR: " + e);
}
%>