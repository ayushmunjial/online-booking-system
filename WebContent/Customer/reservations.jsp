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
		
	    .tabs { display: flex; justify-content: space-around; margin: 20px 0; cursor: pointer; border-bottom: 3px solid #ccc; font-size: 20px; }
	    .tab { padding: 15px 30px; font-weight: 700; color: #555; border-bottom: 4px solid transparent; }
	
	    .tab.active { border-bottom: 4px solid #304352; color: #304352; } .tab-content { display: none; font-size: 16px; } 
	    .tab-content.active { display: block; }   form { display: flex; flex-wrap: wrap; gap: 20px; margin-bottom: 20px; }
	
	    input, select, button { flex: 1 1 calc(45% - 20px); padding: 15px; border: 1px solid #ccc; border-radius: 8px; font-size: 16px;
	        font-family: 'American Typewriter', serif;
	    }

        table { width: 100%; border-collapse: collapse; font-family: 'American Typewriter', serif; }

        th, td { border: 1px solid black; padding: 10px; text-align: center; } th { background-color: #304352; color: white; }
        
        tr:nth-child(even) { background-color: #f9f9f9; } tr:nth-child(odd) { background-color: #fff; }
        
        button { flex: 1 1 100%;  background-color: #304352;  color: white;  border: none;  cursor: pointer;  font-size: 16px;  padding: 15px; }
	    button:hover { background-color: #555; }

        .nav-links { display: flex; gap: 20px; font-family: 'Muli', sans-serif; }
        .nav-links a { text-decoration: none; color: white; font-weight: 500; font-size: 16px; transition: color 0.3s ease; }

        .nav-links a:hover { color: #ccc; }
    </style>

    <script>
        function openTab(event, tabId) {
            const tabs = document.querySelectorAll('.tab'); const contents = document.querySelectorAll('.tab-content');

            tabs.forEach(tab => tab.classList.remove('active')); contents.forEach(content => content.classList.remove('active'));
            event.target.classList.add('active'); document.getElementById(tabId).classList.add('active');
        }
    </script>
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
        
        	<div class="nav-links"> 
        		<a href="newBooking.jsp">New Reservation</a> <a href="../userHome.jsp">Return Home</a> 
        	
        	</div>
	        
            <a href="../logout.jsp" class="button bg-white black fw-600 no-underline mx-5 py-5 px-8 rounded-lg shadow-lg hover-bg-gray-200"
               style="font-size: 18px;"> Logout </a>
        </div>
    </nav>

    <div class="container">
        <div class="tabs">
            <div class="tab active" onclick="openTab(event, 'tab1')">Current Reservations</div>
            <div class="tab" onclick="openTab(event, 'tab2')">Expired Reservations</div>
            <div class="tab" onclick="openTab(event, 'tab3')">Delete a Reservation</div>
        </div>

        <div id="tab1" class="tab-content active">
		    <%
		    try {
		        ApplicationDB db = new ApplicationDB(); Connection con = db.getConnection();    String username = (String) session.getAttribute("username");
		
		        String query = "SELECT r.reservation_number_id,  r.date_made,  r.fare_type,  r.class,  r.seat_number, s.transit_line_name, " +
		                       "r.start_stop, r.end_stop, r.is_round_trip, TIMESTAMPDIFF(MINUTE, s.departure_datetime, s.arrival_datetime) " + 
							   "AS travel_time, (s.base_fare * (CASE r.class WHEN 'Economy' THEN 1 WHEN 'Business' THEN 2 END) * " +
		                       " (CASE r.fare_type WHEN 'Child' THEN 0.75 WHEN 'Senior' THEN 0.65 WHEN 'Disabled' THEN 0.5 ELSE 1 END) " +
		                       " * (CASE WHEN r.is_round_trip THEN 2 ELSE 1 END)) AS total_fare FROM Reservation r JOIN Schedule s ON  " +
		                       "r.transit_line_name = s.transit_line_name WHERE r.username = ? AND s.departure_datetime >= NOW() ORDER BY r.date_made DESC";
		
		        PreparedStatement ps = con.prepareStatement(query); ps.setString(1, username); ResultSet rs = ps.executeQuery();
		
		        out.print("<table>");
		        out.print("<tr><th>ID</th><th>Date Made</th><th>Fare Type</th><th>Class</th><th>Seat</th><th>Transit Line</th>" +
		                  "<th>Origin</th><th>Destination</th><th>Round Trip</th><th>Total Time</th><th>Total Fare</th></tr>");
		
		        while (rs.next()) {
		            out.print("<tr><td>" + rs.getInt("reservation_number_id") + "</td>"); out.print("<td>" + rs.getDate("date_made") + "</td>");
		            out.print("<td>" + rs.getString("fare_type") + "</td>");     out.print("<td>" + rs.getString("class") + "</td>");
		            out.print("<td>" + rs.getString("seat_number") + "</td>");  out.print("<td>" + rs.getString("transit_line_name") + "</td>");
		            out.print("<td>" + rs.getString("start_stop") + "</td>"); out.print("<td>" + rs.getString("end_stop") + "</td>");
		            
		            out.print("<td>" + (rs.getBoolean("is_round_trip") ? "True" : "False") + "</td>"); 
		            out.print("<td>" + rs.getInt("travel_time") + " min</td>");
		            out.print("<td>$" + String.format("%.2f", rs.getDouble("total_fare")) + "</td>"); 
		            out.print("</tr>");
		        }
		        out.print("</table>"); rs.close(); ps.close(); db.closeConnection(con);
		    } 
		    catch (Exception e) { out.println("<p>Error retrieving data: " + e.getMessage() + "</p>"); }
		    %>
		</div>

		<div id="tab2" class="tab-content">
		    <%
		    try {
		        ApplicationDB db = new ApplicationDB(); Connection con = db.getConnection();    String username = (String) session.getAttribute("username");
		
		        String query = "SELECT r.reservation_number_id,  r.date_made,  r.fare_type,  r.class,  r.seat_number, s.transit_line_name, " +
		                       "r.start_stop, r.end_stop, r.is_round_trip, TIMESTAMPDIFF(MINUTE, s.departure_datetime, s.arrival_datetime) " + 
							   "AS travel_time, (s.base_fare * (CASE r.class WHEN 'Economy' THEN 1 WHEN 'Business' THEN 2 END) * " +
		                       " (CASE r.fare_type WHEN 'Child' THEN 0.75 WHEN 'Senior' THEN 0.65 WHEN 'Disabled' THEN 0.5 ELSE 1 END) " +
		                       " * (CASE WHEN r.is_round_trip THEN 2 ELSE 1 END)) AS total_fare FROM Reservation r JOIN Schedule s ON  " +
		                       "r.transit_line_name = s.transit_line_name WHERE r.username = ? AND s.departure_datetime < NOW() ORDER BY r.date_made DESC";
		
		        PreparedStatement ps = con.prepareStatement(query); ps.setString(1, username); ResultSet rs = ps.executeQuery();
		
		        out.print("<table>");
		        out.print("<tr><th>ID</th><th>Date Made</th><th>Fare Type</th><th>Class</th><th>Seat</th><th>Transit Line</th>" +
		                  "<th>Origin</th><th>Destination</th><th>Round Trip</th><th>Total Time</th><th>Total Fare</th></tr>");
		
		        while (rs.next()) {
		            out.print("<tr><td>" + rs.getInt("reservation_number_id") + "</td>"); out.print("<td>" + rs.getDate("date_made") + "</td>");
		            out.print("<td>" + rs.getString("fare_type") + "</td>");     out.print("<td>" + rs.getString("class") + "</td>");
		            out.print("<td>" + rs.getString("seat_number") + "</td>");  out.print("<td>" + rs.getString("transit_line_name") + "</td>");
		            out.print("<td>" + rs.getString("start_stop") + "</td>"); out.print("<td>" + rs.getString("end_stop") + "</td>");
		            
		            out.print("<td>" + (rs.getBoolean("is_round_trip") ? "True" : "False") + "</td>"); 
		            out.print("<td>" + rs.getInt("travel_time") + " min</td>");
		            out.print("<td>$" + String.format("%.2f", rs.getDouble("total_fare")) + "</td>"); 
		            out.print("</tr>");
		        }
		        out.print("</table>"); rs.close(); ps.close(); db.closeConnection(con);
		    } 
		    catch (Exception e) { out.println("<p>Error retrieving data: " + e.getMessage() + "</p>"); }
		    %>
		</div>

		<div id="tab3" class="tab-content">
			 <% 
		        String errorMessage = (String) session.getAttribute("errorMessage");
		
		        if (errorMessage != null) {
		    %>
		        <p style="color: red; text-align: center;"><%= errorMessage %></p>
		    <% 
		            session.removeAttribute("errorMessage");
		        }
		    %>

		    <form action="deleBooking.jsp" method="post" style="align-items: center; gap: 10px; margin: 0 auto; max-width: 450px;">
		        <input type="number" name="reservationID" required  placeholder="Enter Reservation ID" >
		        <button type="submit" 
		        		style="background-color: #d9534f; padding: 15px 30px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); 
		        		transition: background-color 0.3s ease; justify-content: center;"> Delete
		        </button>
		    </form>
		    
		    <p style="text-align: center; color: #999; margin-top: 20px; font-size: 14px;"> Note: Deleting a reservation is permanent and cannot be 
		    	undone.
		    </p>
		</div>
    </div>
    
</body>
</html>