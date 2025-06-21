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
	    .container { margin: auto 20px; background: white;  padding: 20px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); 
		    font-family: 'American Typewriter', serif;
		}
		
	    form { display: flex; flex-wrap: wrap; gap: 20px; margin-bottom: 20px; }
	    
	    input, button { flex: 1 1 calc(45% - 20px); padding: 15px; border: 1px solid #ccc; border-radius: 8px; font-size: 16px;
	        font-family: 'American Typewriter', serif;
	    }
	    
	    table { width: 100%; border-collapse: collapse; font-family: 'American Typewriter', serif; }

        th, td { border: 1px solid black; padding: 10px; text-align: center; } th { background-color: #304352; color: white; }

        tr:nth-child(even) { background-color: #f9f9f9; } tr:nth-child(odd) { background-color: #fff; }
	
	    button { flex: 1 1 100%;  background-color: #304352;  color: white;  border: none;  cursor: pointer;  font-size: 16px;  padding: 15px; }
	    button:hover { background-color: #555; } h2 { text-align: center; color: #333; padding: 10px; }
	
	    .nav-links { display: flex; gap: 20px; font-family: 'Muli', sans-serif; }
        .nav-links a { text-decoration: none; color: white; font-weight: 500; font-size: 16px; transition: color 0.3s ease; }

        .nav-links a:hover { color: #ccc; }
	</style>
</head>

<body style="background: linear-gradient(to right, #d7d2cc 0%, #304352 100%)">

    <nav class="w-100pc flex flex-column md-flex-row md-px-10 py-5" style="background: linear-gradient(to right, #d7d2cc 0%, #304352 100%)">
    
        <div class="flex justify-between">
            <a href="#" class="flex items-center p-2 mr-4 no-underline"> <span class="text-white fs-l2 fw-700">SAK</span> </a>
            
            <a data-toggle="toggle-nav" data-target="#nav-items" href="#"
               class="flex items-center ml-auto md-hidden indigo-lighter opacity-50 hover-opacity-100 ease-300 p-1 m-3">
                <i data-feather="menu"></i>
            </a>
        </div>
        
        <div id="nav-items" class="hidden flex sm-w-100pc flex-column md-flex md-flex-row md-justify-end items-center">
        
        	<div class="nav-links"> <a href="supportHome.jsp">Return Home</a> </div>
	        
            <a href="../logout.jsp" class="button bg-white black fw-600 no-underline mx-5 py-5 px-8 rounded-lg shadow-lg hover-bg-gray-200"
               style="font-size: 18px;"> Logout </a>
        </div>
    </nav>
    
    <div class="container"> 
    <h2>Answer the Customers</h2>
	    <form action="userMessage.jsp" method="post">
	        <input name="id" type="number" placeholder="Enter Message ID" style="height: 40px; width: 30%;" required>
	        <textarea name="reply" rows="6" style="width:100%;" required></textarea> 
	        <button type="submit" name="action" value="reply">Submit Answer</button>
	    </form>
	    
	    <%
	    try {
	    	ApplicationDB db = new ApplicationDB();  Connection con = db.getConnection();  String action = request.getParameter("action");
	    	
	        if ("reply".equals(action)) {
	            String supportUsername = (String) session.getAttribute("username"); int id = Integer.parseInt(request.getParameter("id")); 
	            String reply = request.getParameter("reply");
	            
	            String updateQuery = "UPDATE Messages SET reply = ?, support_username = ? WHERE message_id = ? AND reply IS NULL";
	            PreparedStatement psUpdate = con.prepareStatement(updateQuery);
	            
	            psUpdate.setString(1, reply); psUpdate.setString(2, supportUsername); psUpdate.setInt(3, id); int rowsUpdated = psUpdate.executeUpdate();
	            
	            if (rowsUpdated <= 0) { out.print("<p>Error: No unanswered question found with ID: " + id + "</p>"); }   psUpdate.close();
	        }
	        
	        String query  =  "SELECT m.message_id, m.content, m.timestamp FROM Messages m WHERE m.reply IS NULL ORDER BY m.timestamp ASC";
	        PreparedStatement ps = con.prepareStatement(query); ResultSet rs = ps.executeQuery();
	        
	        if (!rs.isBeforeFirst()) {
	            out.print("<p>No unanswered questions found.</p>");
	        } 
	        else {
	            out.print("<table style='width: 100%; table-layout: fixed; border-collapse: collapse;'>"); out.print("<tr>");
	            out.print("<th style='width: 5%;'>ID</th>"); out.print("<th style='width: 15%;'>Timestamp</th>");
	            out.print("<th style='width: 25%;'>Question</th>");    out.print("<th style='width: 45%;'>Answer</th></tr>");   
	            
	            while (rs.next()) {
	                out.print("<tr>"); out.print("<td>" + rs.getInt("message_id") + "</td>"); out.print("<td>" + rs.getTimestamp("timestamp") + "</td>"); 
	                out.print("<td style='word-wrap: break-word; text-align: justify;'>" + rs.getString("content")  +  "</td>");
	                out.print("<td style='word-wrap: break-word; text-align: justify;'>No answer yet</td>"); out.print("</tr>");
	            }
	            
	            out.print("</table>");
	        }
	        
	        rs.close(); ps.close(); db.closeConnection(con);
	    } 
	    catch (Exception e) { out.println("<p>Error retrieving data: " + e.getMessage() + "</p>"); }
	    %>
	</div>

</body>
</html>