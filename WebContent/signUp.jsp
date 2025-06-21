<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" 
	import="com.cs336.pkg.*, java.io.*, java.util.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*"%>

<%
    try {
    	ApplicationDB db = new ApplicationDB(); Connection con = db.getConnection();
        
    	String firstName = request.getParameter("first_name"); String lastName = request.getParameter("last_name");
        String username = request.getParameter("username");
        String password = request.getParameter("password");  String email = request.getParameter("email");
        String streetAddress = request.getParameter("street"); String city = request.getParameter("city");
        
        String state = request.getParameter("state"); String zip = request.getParameter("zip");
        String phone1 = request.getParameter("phone_num1"); String phone2 = request.getParameter("phone_num2");

        String checkQuery = "SELECT username FROM Customer WHERE username = ? OR email = ? UNION " +
                "SELECT username FROM Employee WHERE username = ?";
        PreparedStatement psCheck = con.prepareStatement(checkQuery);
        psCheck.setString(1, username); psCheck.setString(2, email); 
        psCheck.setString(3, username); ResultSet rsCheck = psCheck.executeQuery();

        if (rsCheck.next()) {
            session.setAttribute("errorGeneral", "Username or email is already in use. Please use a different one.");
            rsCheck.close(); psCheck.close(); con.close(); response.sendRedirect("loginPage.jsp");
        } 
        else {
	 String insertQuery = "INSERT INTO Customer (username, email, password, first_name, last_name, street_address,"
				+ " city, state, zip, phone_num1, phone_num2) " + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			
            PreparedStatement psInsert = con.prepareStatement(insertQuery);
            
            psInsert.setString(1, username); psInsert.setString(2, email);  psInsert.setString(3, password); 
            psInsert.setString(4, firstName);  psInsert.setString(5, lastName); 
            psInsert.setString(6, streetAddress); psInsert.setString(7, city); psInsert.setString(8, state); 
            
            psInsert.setString(9, zip); psInsert.setString(10, phone1); psInsert.setString(11, phone2);
            psInsert.executeUpdate();  psInsert.close(); rsCheck.close(); psCheck.close(); con.close();

            session.setAttribute("successMessage", "Account created successfully! Please log in.");  
            response.sendRedirect("loginPage.jsp");
        }
    }
	catch (Exception e) {  session.setAttribute("errorGeneral", "An unexpected error occurred. Please try again.");
		response.sendRedirect("loginPage.jsp");
	}
%>