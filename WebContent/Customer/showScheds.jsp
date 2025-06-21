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

        table { width: 100%; border-collapse: collapse; font-family: 'American Typewriter', serif; }

        th, td { border: 1px solid black; padding: 10px; text-align: center; } th { background-color: #304352; color: white; }

        tr:nth-child(even) { background-color: #f9f9f9; } tr:nth-child(odd) { background-color: #fff; }

        .return-button { display: block; margin: 20px auto; padding: 10px 20px; color: white; background: #304352; border-radius: 5px;
            text-decoration: none; text-align: center;
        }

        .return-button:hover { background: #555; }
        h2 { text-align: center; color: #333; padding: 10px; } .info { margin-bottom: 20px; text-align: center; font-size: 16px; color: #555; }

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
        
        	<div class="nav-links"> <a href="../userHome.jsp">Return Home</a> </div>
	        
            <a href="../logout.jsp" class="button bg-white black fw-600 no-underline mx-5 py-5 px-8 rounded-lg shadow-lg hover-bg-gray-200"
               style="font-size: 18px;"> Logout </a>
        </div>
    </nav>

    <div class="container">
	    <h2>Train Schedules</h2>
	
	    <%
	        int originID = Integer.parseInt(request.getParameter("origin"));  int destID = Integer.parseInt(request.getParameter("dest"));
	        String tDate = request.getParameter("date");
	
	        ApplicationDB db = new ApplicationDB(); Connection con = db.getConnection(); String originName = null; String destName = null;
	
	        try {
	            String queryStationNames = "SELECT s1.name AS origin_name, s2.name AS destination_name FROM Station s1, Station s2 WHERE " +
	                                       "s1.station_id = ? AND s2.station_id = ?";
	
	            PreparedStatement psNames = con.prepareStatement(queryStationNames); psNames.setInt(1, originID); psNames.setInt(2, destID);
	            ResultSet rsNames = psNames.executeQuery();
	            
	            if (rsNames.next()) {
	                originName = rsNames.getString("origin_name"); destName = rsNames.getString("destination_name");
	            } 
	            else { out.print("<p>Error: Origin or destination station not found.</p>"); } rsNames.close(); psNames.close();
	            
	        } 
	        catch (Exception e) { out.print("<p>Error fetching station names: " + e.getMessage() + "</p>"); }
	
	        if (originName != null && destName != null) {
	            out.print("<table>"); out.print("<tr>");
	            
	            out.print("<th>Origin Station Name</th>"); out.print("<th>Destination Station Name</th>"); out.print("<th>Date</th>");
	            out.print("<th>Departure Time</th>"); out.print("<th>Arrival Time</th>"); out.print("</tr>");
	
	            try {
	                String querySchedules = "SELECT st1.name AS origin_name, st2.name AS destination_name, DATE(s.departure_datetime)" +
	                                        " AS travel_date, TIME(s.departure_datetime) AS departure_time, TIME(s.arrival_datetime) " +
	                                        "AS arrival_time FROM Schedule s JOIN Station st1 ON s.origin = st1.name JOIN Station st2" +
	                                        " ON s.destination = st2.name " +
	                                        "WHERE s.origin = ? AND s.destination = ? AND DATE(s.departure_datetime) = DATE(?)";
	
	                PreparedStatement psSchedules = con.prepareStatement(querySchedules);
	                
	                psSchedules.setString(1, originName);  psSchedules.setString(2, destName);  psSchedules.setString(3, tDate);
	                ResultSet rsSchedules = psSchedules.executeQuery(); boolean hasData = false;
	                
	                while (rsSchedules.next()) { hasData = true; 
	                    out.print("<tr>");  out.print("<td>" + rsSchedules.getString("origin_name") + "</td>");
	                    out.print("<td>" + rsSchedules.getString("destination_name") + "</td>");
	                    out.print("<td>" + rsSchedules.getString("travel_date") + "</td>");
	                    out.print("<td>" + rsSchedules.getString("departure_time") + "</td>");
	                    out.print("<td>" + rsSchedules.getString("arrival_time") + "</td>"); out.print("</tr>");
	                }
	
	                if (!hasData) { out.print("<tr><td colspan='5'>No schedules found for the selected date.</td></tr>"); }
	                rsSchedules.close(); psSchedules.close(); db.closeConnection(con);
	            } 
	            catch (Exception e) { out.println("<p>Error retrieving data: " + e.getMessage() + "</p>"); }  out.print("</table>");
	        }
	    %>
	
	    <a href="searchTrains.jsp" class="return-button">Return Back</a>
	</div>
    
</body>
</html>