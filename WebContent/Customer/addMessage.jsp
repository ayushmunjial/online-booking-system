<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" 
	import="com.cs336.pkg.*, java.io.*, java.util.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*"%>

<%
 	try {
    	ApplicationDB db = new ApplicationDB(); Connection con = db.getConnection();
    	String username = (String) session.getAttribute("username");   String messageContent = request.getParameter("message");

        String query = "INSERT INTO Messages (customer_username, content, sender, timestamp) VALUES (?, ?, 'Customer', NOW())";
        PreparedStatement ps = con.prepareStatement(query); 
        ps.setString(1, username); ps.setString(2, messageContent); int rowsInserted = ps.executeUpdate();

        if (rowsInserted <= 0) { session.setAttribute("errorMessage", "Failed to send the message. Please try again."); }

        ps.close(); db.closeConnection(con);
    } 
	catch (Exception e) {      session.setAttribute("errorMessage", "An unexpected error occurred. Please try again."); }

    response.sendRedirect("messageHelp.jsp");
%>