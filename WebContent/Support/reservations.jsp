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
	    
	    input, button { flex: 1 1 calc(45% - 20px); padding: 15px; border: 1px solid #ccc; border-radius: 8px; font-size: 16px;
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
        
        	<div class="nav-links"> <a href="supportHome.jsp">Return Home</a> </div>
	        
            <a href="../logout.jsp" class="button bg-white black fw-600 no-underline mx-5 py-5 px-8 rounded-lg shadow-lg hover-bg-gray-200"
               style="font-size: 18px;"> Logout </a>
        </div>
    </nav>

    <div class="container">
        <div class="tabs">
            <div class="tab active" onclick="openTab(event, 'tab1')">Search Train Schedules</div>
            <div class="tab"  onclick="openTab(event, 'tab2')">Search Customer Reservations</div>
            <div class="tab"  onclick="openTab(event, 'tab3')">View All Reservations</div>
        </div>

        <div id="tab1" class="tab-content active">
            <form action="reservations.jsp" method="post">
                <input type="text" name="station" placeholder="Enter Station Name" required> 
                <button type="submit" name="searchType" value="stationSearch">Search</button>
            </form>

            <%
            if ("stationSearch".equals(request.getParameter("searchType"))) {
            	try {
            		ApplicationDB db = new ApplicationDB(); Connection con = db.getConnection(); String username = (String) session.getAttribute("username");
                    String station = request.getParameter("station");
                    
                    String query = "SELECT s.transit_line_name, s.origin, s.destination, s.departure_datetime, s.arrival_datetime FROM Schedule s JOIN Stop "
                                        + "st ON s.transit_line_name = st.transit_line_name JOIN Station t ON st.station_id = t.station_id WHERE t.name = ?";
                    
                    PreparedStatement ps = con.prepareStatement(query); ps.setString(1, station); ResultSet rs = ps.executeQuery();
                    
                    if (!rs.isBeforeFirst()) {
                        out.print("<p>No schedules found for Station: " + station + "</p>");
                    } 
                    else {
	                    out.print("<h4>Schedules for Station: " + station + "</h4>");
	                    out.print("<table><tr><th>Transit Line</th><th>Origin</th><th>Destination</th><th>Departure</th><th>Arrival</th></tr>");
	                    
	                    while (rs.next()) {
	                    	out.print("<tr><td>" + rs.getString("transit_line_name") + "</td>");       out.print("<td>" + rs.getString("origin") + "</td>");
	                        out.print("<td>" + rs.getString("destination") + "</td>");  out.print("<td>" + rs.getTimestamp("departure_datetime") + "</td>"); 
	                        out.print("<td>" + rs.getTimestamp("arrival_datetime") + "</td></tr>");
	                    }
	                    out.print("</table>"); rs.close(); ps.close(); db.closeConnection(con);
                    }
                } 
            	catch (Exception e) { out.println("<p>Error retrieving data: " + e.getMessage() + "</p>"); }
            }
            %>
        </div>

        <!-- Tab 2: Search Customer Reservations -->
        <div id="tab2" class="tab-content">
            <form action="reservations.jsp" method="post">
                <input type="text" name="transitLine" placeholder="Enter Transit Line Name" required> <input type="date" name="date" required>
                <button type="submit" name="searchType" value="customerSearch">Search</button>
            </form>

            <%
            if ("customerSearch".equals(request.getParameter("searchType"))) {
            	try {
            		ApplicationDB db = new ApplicationDB(); Connection con = db.getConnection(); String username = (String) session.getAttribute("username");
					String transitLine = request.getParameter("transitLine"); String scheduleDate = request.getParameter("date");

                        String query = "SELECT r.reservation_number_id, r.username, r.transit_line_name, r.start_stop, r.end_stop, " +
                                       "r.date_made, r.seat_number, r.class, r.fare_type, r.is_round_trip, s.train_id, " +
                                       "s.departure_datetime, s.arrival_datetime " +
                                       "FROM Reservation r " +
                                       "JOIN Schedule s ON r.transit_line_name = s.transit_line_name " +
                                       "WHERE r.transit_line_name = ? AND DATE(s.departure_datetime) = ?";
                        
                    PreparedStatement ps = con.prepareStatement(query); ps.setString(1, transitLine); ps.setString(2, scheduleDate); 
                    ResultSet rs = ps.executeQuery();

                    if (!rs.isBeforeFirst()) { 
                    	out.print("<p>No reservations found for Transit Line: " + transitLine + " on " + scheduleDate + "</p>");
                    } 
                    else {
                        out.print("<h4>Reservations for Transit Line: " + transitLine + " on " + scheduleDate + "</h4>");
                        out.print("<table>");
                        out.print("<tr><th>ID</th><th>Username</th><th>Transit Line</th><th>Origin</th><th>Destination</th><th>Date Made</th><th>Seat</th>" +
                                  "<th>Class</th><th>Fare Type</th><th>Round Trip</th><th>Train ID</th></tr>");

                        while (rs.next()) {
                        	out.print("<tr>"); out.print("<td>" + rs.getInt("reservation_number_id") + "</td>"); 
                        	out.print("<td>" + rs.getString("username") + "</td>"); out.print("<td>" + rs.getString("transit_line_name") + "</td>");
                            out.print("<td>" + rs.getString("start_stop") + "</td>"); out.print("<td>" + rs.getString("end_stop") + "</td>");
                            out.print("<td>" + rs.getDate("date_made") + "</td>"); out.print("<td>" + rs.getString("seat_number") + "</td>");
                            out.print("<td>" + rs.getString("class") + "</td>");     out.print("<td>" + rs.getString("fare_type") + "</td>");
                            out.print("<td>" + (rs.getBoolean("is_round_trip") ? "True"  :  "False") + "</td>"); 
                            
                            out.print("<td>" + rs.getString("train_id") + "</td>"); out.print("</tr>");
                        }
                        out.print("</table>");
                    }
                    
                    rs.close(); ps.close(); db.closeConnection(con);
                }
            	catch (Exception e) { out.println("<p>Error retrieving data: " + e.getMessage() + "</p>"); }
            }
            %>
        </div>

        <div id="tab3" class="tab-content">
            <%
            try {
            	ApplicationDB db = new ApplicationDB(); Connection con = db.getConnection(); Statement stmt = con.createStatement();

                String query = "SELECT r.reservation_number_id, r.username, r.transit_line_name, r.start_stop, r.end_stop, r.date_made, r.seat_number, r.class,"
                                  + " r.fare_type, r.is_round_trip, s.train_id FROM Reservation r JOIN Schedule s ON r.transit_line_name = s.transit_line_name";

                ResultSet rs = stmt.executeQuery(query);
                
                out.print("<table>");
                out.print("<tr><th>ID</th><th>Username</th><th>Transit Line</th><th>Origin</th><th>Destination</th><th>Date Made</th><th>Seat</th><th>Class</th>"
                          + "<th>Fare Type</th><th>Round Trip</th><th>Train ID</th></tr>");

                while (rs.next()) {
                	out.print("<tr>"); out.print("<td>" + rs.getInt("reservation_number_id") + "</td>"); 
                    out.print("<td>" + rs.getString("username") + "</td>"); out.print("<td>" + rs.getString("transit_line_name") + "</td>");
                    out.print("<td>" + rs.getString("start_stop") + "</td>"); out.print("<td>" + rs.getString("end_stop") + "</td>");
                    out.print("<td>" + rs.getDate("date_made") + "</td>"); out.print("<td>" + rs.getString("seat_number") + "</td>");
                    out.print("<td>" + rs.getString("class") + "</td>");     out.print("<td>" + rs.getString("fare_type") + "</td>");
                    out.print("<td>" + (rs.getBoolean("is_round_trip") ? "True"  :  "False") + "</td>"); 
                        
                    out.print("<td>" + rs.getString("train_id") + "</td>"); out.print("</tr>");
                }
                out.print("</table>"); rs.close(); stmt.close(); db.closeConnection(con);
			} 
            catch (Exception e) { out.println("<p>Error retrieving data: " + e.getMessage() + "</p>"); }
            %>
        </div>
    </div>
    
</body>
</html>