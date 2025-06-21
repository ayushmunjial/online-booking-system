<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" 
	import="com.cs336.pkg.*, java.io.*, java.util.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*"%>

<%
    try {
        ApplicationDB db = new ApplicationDB(); Connection con = db.getConnection();
        String username = request.getParameter("username"); String password = request.getParameter("password");
        
        String customerQuery = "SELECT username FROM Customer WHERE username = ? AND password = ?";
        PreparedStatement psCustomer  =  con.prepareStatement(customerQuery);
        psCustomer.setString(1, username); psCustomer.setString(2, password);
        ResultSet rsCustomer = psCustomer.executeQuery();
		
        String employeeQuery = "SELECT username FROM Employee WHERE username = ? AND password = ?";
        PreparedStatement psEmployee  =  con.prepareStatement(employeeQuery);
        psEmployee.setString(1, username); psEmployee.setString(2, password);
        ResultSet rsEmployee = psEmployee.executeQuery();

        if (rsCustomer.next()) {
        	session.setAttribute("username", username); response.sendRedirect("userHome.jsp");
        } 
        else if (rsEmployee.next()) {
        	String managerQuery = "SELECT username FROM Manager WHERE username = ?";
            PreparedStatement psManager = con.prepareStatement(managerQuery);
            psManager.setString(1, username); ResultSet rsManager = psManager.executeQuery();

			String supportQuery = "SELECT username FROM Support WHERE username = ?";
			PreparedStatement psSupport = con.prepareStatement(supportQuery);
			psSupport.setString(1, username); ResultSet rsSupport = psSupport.executeQuery();

            if (rsManager.next()) {
            	session.setAttribute("username", username); session.setAttribute("employeeType", "Manager");
                response.sendRedirect("Manager/managerHome.jsp");
            } 
            else if (rsSupport.next()) {
            	session.setAttribute("username", username); session.setAttribute("employeeType", "Support");
            	response.sendRedirect("Support/supportHome.jsp");
            } 
            else {
            	session.setAttribute("generalError", "Invalid username or password."); 
            	response.sendRedirect("loginPage.jsp");
            }
                
            rsManager.close(); psManager.close(); rsSupport.close(); psSupport.close();
        } 
		else {
			session.setAttribute("generalError", "Invalid username or password."); 
			response.sendRedirect("loginPage.jsp");
		}
        
        rsCustomer.close(); psCustomer.close(); rsEmployee.close(); psEmployee.close(); con.close();
    }
	catch (Exception e) { session.setAttribute("generalError", "An unexpected error occurred. Please try again.");
        response.sendRedirect("loginPage.jsp");
    }
%>