<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" 
	import="com.cs336.pkg.*, java.io.*, java.util.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*"%>  <!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8"> <meta name="viewport" content="width=device-width, initial-scale=1.0"> <title>SAK Online Railway Booking System</title>
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/shorthandcss@1.1.1/dist/shorthand.min.css" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Muli:200,300,400,500,600,700,800,900&display=swap" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.9.0/slick.min.css" />
    <link rel="stylesheet"   href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css" />
    <link rel="stylesheet" href="css/homepage.css" />
    
    <style>
        button { margin: 10px; padding: 10px 20px; font-size: 16px; cursor: pointer; }

        .nav-links { display: flex; gap: 20px; font-family: 'Muli', sans-serif; }
        .nav-links a { text-decoration: none; color: white; font-weight: 500; font-size: 16px; transition: color 0.3s ease; }

        .nav-links a:hover { color: #ccc; }
    </style>
</head>

<body style="background: linear-gradient(to right, #d7d2cc 0%, #304352 100%)">
    <%
        String firstName = "User";
        try {
        	ApplicationDB db = new ApplicationDB(); Connection con = db.getConnection();
            
        	String query = "SELECT first_name FROM Customer WHERE username = ?"; PreparedStatement ps = con.prepareStatement(query);
            
        	ps.setString(1, (String) session.getAttribute("username"));   ResultSet rs = ps.executeQuery();
            if (rs.next()) { firstName = rs.getString("first_name"); } rs.close(); ps.close(); con.close();
        } 
        catch (Exception e) { System.out.println("Error fetching user details: " + e.getMessage()); }
    %>

    <nav class="w-100pc flex flex-column md-flex-row md-px-10 py-5" style="background: linear-gradient(to right, #d7d2cc 0%, #304352 100%)">
        
        <div class="flex justify-between">
            <a href="#" class="flex items-center p-2 mr-4 no-underline"> <span class="text-white fs-l2 fw-700">SAK</span> </a>
            
            <a data-toggle="toggle-nav" data-target="#nav-items" href="#"
               class="flex items-center ml-auto md-hidden indigo-lighter opacity-50 hover-opacity-100 ease-300 p-1 m-3">
                <i data-feather="menu"></i>
            </a>
        </div>
        
        <div id="nav-items" class="hidden flex sm-w-100pc flex-column md-flex md-flex-row md-justify-end items-center">
        
	        <div class="nav-links">
	            <a href="Customer/reservations.jsp">Manage Reservations</a> 
	            <a href="Customer/messageHelp.jsp">Message Support</a> <a href="Customer/searchTrains.jsp">Search/Browse</a>
	        </div>
	        
            <a href="logout.jsp" class="button bg-white black fw-600 no-underline mx-5 py-5 px-8 rounded-lg shadow-lg hover-bg-gray-200"
               style="font-size: 18px;"> Logout </a>
        </div>
    </nav>

    <section id="home" class="min-h-100vh flex flex-column justify-center items-center">
        <div class="text-center mx-5 md-mx-l5">
            <h1 class="white fs-l3 lh-2 md-fs-xl1 md-lh-1 fw-900">Hi <%= firstName %>! Welcome to SAK!</h1>
            <p class="white fs-m1 mt-3">Explore trains, manage your reservations, connect with support, discover exclusive deals, and enjoy a 
            							seamless booking experience.</p>
        </div>
    </section>
    
</body>
</html>