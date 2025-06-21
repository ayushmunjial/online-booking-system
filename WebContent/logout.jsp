<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" 
    import="jakarta.servlet.http.*, jakarta.servlet.*" %>

<%
    try { session.invalidate(); response.sendRedirect("loginPage.jsp"); } 
	
	catch (Exception e) {
        session.setAttribute("generalError", "An unexpected error occurred during logout.");
    }
%>