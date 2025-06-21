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
        
        	<div class="nav-links"> <a href="managerHome.jsp">Return Home</a> </div>
	        
            <a href="../logout.jsp" class="button bg-white black fw-600 no-underline mx-5 py-5 px-8 rounded-lg shadow-lg hover-bg-gray-200"
               style="font-size: 18px;"> Logout </a>
        </div>
    </nav>
	
	<div class="container">
	    <div class="tabs">
	        <div class="tab active" onclick="openTab(event, 'tab1')">Search Reservations</div>
	        <div class="tab" onclick="openTab(event, 'tab2')">Revenue Reports</div>
	        <div class="tab"  onclick="openTab(event, 'tab3')">Top Performers</div>
	    </div>
	
	    <div id="tab1" class="tab-content active">
	        <form action="searchBrowse.jsp" method="post"> <input type="hidden" name="searchType" value="reservations">
	            <select name="searchBy" required>
	                <option value="transitLine">Transit Line Name</option>         <option value="customerName">Customer Name</option>
	            </select>
	            
	            <input type="text" name="searchQuery" placeholder="Enter Search Query" required> <button type="submit">Search</button>
	        </form>
	        <table>
	            <thead>
	                <tr>
	                    <th>Reservation ID</th> <th>Customer Name</th> <th>Transit Line Name</th> <th>Origin</th> <th>Destination</th>
	                    <th>Date Made</th> <th>Class</th> <th>Fare Type</th>
	                </tr>
	            </thead>
	            
	            <tbody>
	                <%
	                    if ("reservations".equals(request.getParameter("searchType"))) {
	                        String searchBy = request.getParameter("searchBy"); String searchQuery = request.getParameter("searchQuery");
	                        
	                        try {
	                            ApplicationDB db = new ApplicationDB(); Connection con = db.getConnection();
	                            String query = "SELECT * FROM Reservation WHERE " + (searchBy.equals("transitLine") ? "transit_line_name" : "username") + " LIKE ?";
	                            
	                            PreparedStatement ps = con.prepareStatement(query); ps.setString(1, "%" + searchQuery + "%"); 
	                            ResultSet rs = ps.executeQuery();
	                            
	                            while (rs.next()) {
	                %>
	                <tr>
	                    <td><%= rs.getString("reservation_number_id") %></td> <td><%= rs.getString("username") %></td>
	                    <td><%= rs.getString("transit_line_name") %></td>   <td><%= rs.getString("start_stop") %></td> 
	                    <td><%= rs.getString("end_stop") %></td> <td><%= rs.getDate("date_made") %></td> <td><%= rs.getString("class") %></td>
	                    <td><%= rs.getString("fare_type") %></td>
	                </tr>
	                <%
	                            }
	                            rs.close(); ps.close(); con.close();
	                        } 
	                        catch (Exception e) { out.println("<p>Error retrieving data: " + e.getMessage() + "</p>"); }
	                    }
	                %>
	            </tbody>
	        </table>
	    </div>
	
		<div id="tab2" class="tab-content">
		    <form action="searchBrowse.jsp" method="post"> <input type="hidden" name="searchType" value="revenue">
		        <select name="revenueBy" required>
		            <option value="transitLine">Transit Line Name</option>         <option value="customerName">Customer Name</option>
		        </select>
		        <button type="submit">Generate</button>
		    </form>
		    <table>
		        <thead>
		            <tr>
		                <% if ("transitLine".equals(request.getParameter("revenueBy"))) { %><th>Transit Line Name</th> <% } else { %>
		                    <th>Customer Name</th>
		                <% } %>
		                <th>Total Revenue</th>
		            </tr>
		        </thead>
		        <tbody>
		            <%
		                if ("revenue".equals(request.getParameter("searchType"))) { String revenueBy = request.getParameter("revenueBy");
		
		                    try {
		                        ApplicationDB db = new ApplicationDB(); Connection con = db.getConnection();
		
		                        String query = "SELECT "  +  (revenueBy.equals("transitLine")  ?  "r.transit_line_name" : "r.username") + "  AS entity, SUM( " 
			                                 + "    (s.base_fare  *  (CASE WHEN r.is_round_trip THEN 2 ELSE 1 END) / total_stops.total_stop_count) " 
			                                 + "    * stop_count.stop_difference * (CASE r.class WHEN 'Economy' THEN 1 WHEN 'Business' THEN 2 END) " 
			                                 + "    * (CASE r.fare_type WHEN 'Child' THEN 0.75 WHEN 'Senior' THEN 0.65 WHEN 'Disabled' THEN 0.50 ELSE 1 END) " 
			                                 + ") AS total_revenue " 
			                                 + "FROM Reservation AS r JOIN Schedule AS s ON r.transit_line_name = s.transit_line_name " 
			                                 + "JOIN (SELECT transit_line_name, COUNT(*) AS total_stop_count FROM Stop GROUP BY transit_line_name) " 
			                                 + "AS total_stops ON total_stops.transit_line_name = r.transit_line_name " 
			                                 + "JOIN (SELECT t1.transit_line_name, t1.stop_num AS start_stop_num, t2.stop_num AS end_stop_num, t2.stop_num - " 
			                                 + "    t1.stop_num AS stop_difference FROM Stop AS t1 " 
			                                 + "    JOIN Stop AS t2 ON t1.transit_line_name = t2.transit_line_name WHERE t1.stop_num < t2.stop_num " 
			                                 + ") AS stop_count ON stop_count.transit_line_name = r.transit_line_name " 
			                                 + "AND stop_count.start_stop_num = ( " 
			                                 + "    SELECT stop_num FROM Stop  WHERE station_id = (SELECT station_id FROM Station WHERE name = r.start_stop) " 
			                                 + "    AND transit_line_name = r.transit_line_name " 
			                                 + ") " 
			                                 + "AND stop_count.end_stop_num = ( " 
			                                 + "    SELECT stop_num FROM Stop  WHERE station_id = (SELECT station_id FROM Station WHERE name =   r.end_stop) " 
			                                 + "    AND transit_line_name = r.transit_line_name " 
			                                 + ") " 
			                                 + "GROUP BY " + (revenueBy.equals("transitLine") ? "r.transit_line_name" : "r.username");
			
		                        PreparedStatement ps = con.prepareStatement(query); ResultSet rs = ps.executeQuery();
		                        
		                        while (rs.next()) {
		            %>
		            <tr>
		                <td><%= rs.getString("entity") %></td> <td>$<%= rs.getDouble("total_revenue") %></td>
		            </tr>
		            <%
		                        }
	                            rs.close(); ps.close(); con.close();
	                        } 
	                        catch (Exception e) { out.println("<p>Error retrieving data: " + e.getMessage() + "</p>"); }
	                    }
	                %>
		        </tbody>
		    </table>
		</div>
	
	    <div id="tab3" class="tab-content">		
		    <div>
		        <%
		            try {
		                ApplicationDB db = new ApplicationDB(); Connection con = db.getConnection();
		                String query = "WITH StopCounts AS (SELECT t1.transit_line_name, t1.stop_num AS start_stop_num, t2.stop_num AS end_stop_num, t2.stop_num - "
			                         + "    t1.stop_num AS stop_difference FROM Stop AS t1 "
			                         + "    JOIN Stop AS t2 ON t1.transit_line_name = t2.transit_line_name WHERE t1.stop_num < t2.stop_num"
			                         + "), "
			                         + "ReservationFares AS (SELECT r.username, r.reservation_number_id, "
			                         + "        ("
			                         + "            (s.base_fare  *  (CASE WHEN r.is_round_trip THEN 2 ELSE 1 END) / total_stops.total_stop_count) "
			                         + "            * stop_count.stop_difference * (CASE r.class WHEN 'Economy' THEN 1 WHEN 'Business' THEN 2 END) "
			                         + "            * (CASE r.fare_type WHEN 'Child' THEN 0.75 WHEN 'Senior' THEN 0.65  WHEN  'Disabled' THEN 0.50 ELSE 1 END)"
			                         + "        ) AS total_fare "
			                         + "    FROM Reservation AS r "
			                         + "    JOIN Schedule AS s ON r.transit_line_name = s.transit_line_name "
			                         + "    JOIN (SELECT transit_line_name, COUNT(*) AS total_stop_count FROM Stop GROUP BY transit_line_name) AS total_stops "
			                         + "        ON total_stops.transit_line_name = r.transit_line_name "
			                         + "    JOIN StopCounts AS stop_count "
			                         + "        ON  stop_count.transit_line_name = r.transit_line_name "
			                         + "        AND stop_count.start_stop_num = ("
			                         + "            SELECT stop_num FROM Stop WHERE station_id = (SELECT station_id FROM Station WHERE name = r.start_stop) AND"
			                         + "            transit_line_name = r.transit_line_name"
			                         + "        ) "
			                         + "        AND stop_count.end_stop_num   = ("
			                         + "            SELECT stop_num  FROM Stop WHERE station_id  =  (SELECT station_id FROM Station WHERE name = r.end_stop) "
			                         + "            AND transit_line_name = r.transit_line_name"
			                         + "        )"
			                         + "), "
			                         + "CustomerRevenues AS (SELECT  username,  SUM(total_fare)  AS  total_revenue  FROM  ReservationFares GROUP BY username) "
			                         + "SELECT username, total_revenue FROM CustomerRevenues ORDER BY total_revenue DESC LIMIT 1;";
			                         
		                PreparedStatement ps = con.prepareStatement(query); ResultSet rs = ps.executeQuery();
		                
		                if (rs.next()) {
		                	out.println("<p><strong>Best Customer:</strong> " + rs.getString("username") + 
		                          " has generated the highest revenue for the system, contributing an impressive total of <strong>$" + rs.getDouble("total_revenue") 
		                          + "</strong>. This reflects their frequent usage and loyalty to our services.</p>");
		                }
		                rs.close(); ps.close(); con.close();
		            }
		        	catch (Exception e) { out.println("<p>Error retrieving data: " + e.getMessage() + "</p>"); }
		        %>
		    </div>
		
		    <div>
		        <h4>Top 5 Active Transit Lines</h4>
		        <table>
		            <thead><tr><th>Transit Line Name</th> <th>Reservations</th> <th>Year</th> <th>Month</th></tr></thead>
		            <tbody>
		                <%
		                    try {
		                        ApplicationDB db = new ApplicationDB(); Connection con = db.getConnection();
		                        String query = "SELECT transit_line_name, COUNT(*) AS number_of_reservations, YEAR(date_made) AS year, MONTH(date_made) AS month " +
		                            "FROM Reservation GROUP BY transit_line_name, YEAR(date_made), MONTH(date_made) ORDER BY number_of_reservations DESC LIMIT 5";
		                        
		                        PreparedStatement ps = con.prepareStatement(query); ResultSet rs = ps.executeQuery();
		                        while (rs.next()) {
		                %>
		                <tr>
		                    <td><%= rs.getString("transit_line_name") %></td> <td><%= rs.getInt("number_of_reservations") %></td> <td><%= rs.getInt("year") %></td>
		                    <td><%= rs.getInt("month") %></td>
		                </tr>
		                <%
		                        }
		                        rs.close(); ps.close(); con.close();
		                    } 
		                	catch (Exception e) { out.println("<p>Error retrieving data: " + e.getMessage() + "</p>"); }
		                %>
		            </tbody>
		        </table>
		    </div>
		</div>
	</div>
	
</body>
</html>