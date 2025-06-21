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

    <div class="container"> <h2>Train Schedules</h2>

        <%
            String sortType = request.getParameter("sortType"); String sortOrder = request.getParameter("sortOrder");
            String sortColumn = "departure_datetime";
            
            if ("destination".equals(sortType)) { sortColumn = "destination";} else if ("origin".equals(sortType)) { sortColumn = "origin"; } 
            else if ("arrival_time".equals(sortType)) { sortColumn = "arrival_datetime"; }
            else if ("departure_time".equals(sortType)) { sortColumn = "departure_datetime"; }  else { sortColumn = "base_fare"; }

            String orderClause = "ascending".equalsIgnoreCase(sortOrder) ? "ASC" : "DESC";
        %>

        <table>
            <tr>
                <th>Transit Line</th>  <th>Train ID</th>  <th>Origin</th>  <th>Departure Time</th>  <th>Destination</th>  <th>Arrival Time</th>
                <th>Travel Time</th>  <th>Base Fare</th>
            </tr>
            <%
                try {
                    ApplicationDB db = new ApplicationDB(); Connection con = db.getConnection();
                    
                    String query = "SELECT  transit_line_name, train_id, origin, departure_datetime, destination, arrival_datetime, " +
                                   "TIMEDIFF(arrival_datetime, departure_datetime) AS travel_time, base_fare FROM Schedule ORDER BY " +
                                   sortColumn + " " + orderClause;

                    Statement stmt = con.createStatement(); ResultSet rs = stmt.executeQuery(query);
                    
                    while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("transit_line_name") %></td>     <td><%= rs.getInt("train_id") %></td>     <td><%= rs.getString("origin") %></td> 
                <td><%= rs.getString("departure_datetime") %></td> <td><%= rs.getString("destination") %></td>  
                <td><%= rs.getString("arrival_datetime") %></td> <td><%= rs.getString("travel_time") %></td> <td><%= rs.getDouble("base_fare") %></td>
            </tr>
            <%
                    }
                    rs.close(); stmt.close(); db.closeConnection(con);
                } 
            	catch (Exception e) { out.println("<p>Error retrieving data: " + e.getMessage() + "</p>"); }
            %>
        </table>

        <a href="searchTrains.jsp" class="return-button">Return Back</a>
    </div>
    
</body>
</html>