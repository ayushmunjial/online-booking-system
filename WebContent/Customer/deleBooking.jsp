<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" 
	import="com.cs336.pkg.*, java.io.*, java.util.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*"%>

<%
    try {
    	
    	ApplicationDB db = new ApplicationDB(); Connection con = db.getConnection(); 
        String reservationID = request.getParameter("reservationID");    String username = (String) session.getAttribute("username");

        String query = "SELECT * FROM Reservation WHERE reservation_number_id = ? AND username = ?;";
        PreparedStatement ps = con.prepareStatement(query); 
        ps.setString(1, reservationID); ps.setString(2, username);  ResultSet rs = ps.executeQuery();

        if (!rs.next()) {
        	session.setAttribute("errorMessage", "Reservation not found or not associated with your account.");
        } 
        else {
            String dQuery = "DELETE FROM Reservation WHERE reservation_number_id = ?;";
            PreparedStatement psDelete = con.prepareStatement(dQuery); psDelete.setString(1, reservationID); psDelete.executeUpdate(); 
            psDelete.close();
        }
        
        rs.close(); ps.close(); db.closeConnection(con);
    } 
	catch (Exception e) { session.setAttribute("errorMessage", "An unexpected error occurred. Please try again."); }
	
	response.sendRedirect("reservations.jsp");
%>