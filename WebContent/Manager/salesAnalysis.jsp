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
	
	    button { flex: 1 1 100%;  background-color: #304352;  color: white;  border: none;  cursor: pointer;  font-size: 16px;  padding: 15px; }
	    button:hover { background-color: #555; }
	
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
        
        	<div class="nav-links"> <a href="managerHome.jsp">Return Home</a> </div>
	        
            <a href="../logout.jsp" class="button bg-white black fw-600 no-underline mx-5 py-5 px-8 rounded-lg shadow-lg hover-bg-gray-200"
               style="font-size: 18px;"> Logout </a>
        </div>
    </nav>
    
    <div class="container">
	    <h2 class="text-center" style="margin-bottom: 18px;">Monthly Sales Report</h2>
	    <table>
	        <thead> <tr><th>Year</th><th>Month</th><th>Total Sales</th></tr>  </thead>
	        <tbody>
	            <%
	                try {
	                    ApplicationDB db = new ApplicationDB(); Connection con = db.getConnection();
	                    String query = "SELECT YEAR(r.date_made) AS year, MONTH(r.date_made)  AS  month, SUM(total_fare) AS total_sales FROM Reservation AS r "
	                                 + "JOIN ( SELECT r.reservation_number_id, r.date_made, ( "
	                                 + "            (s.base_fare  *  (CASE WHEN r.is_round_trip THEN 2 ELSE 1 END) / total_stops.total_stop_count) "
	                                 + "            * stop_count.stop_difference * (CASE r.class WHEN 'Economy' THEN 1 WHEN 'Business' THEN 2 END) "
	                                 + "            * (CASE r.fare_type  WHEN 'Child' THEN 0.75 WHEN 'Senior' THEN 0.65 WHEN 'Disabled' THEN 0.50 ELSE 1 END) "
	                                 + "        ) AS total_fare "
	                                 + "    FROM Reservation AS r JOIN Schedule AS s ON r.transit_line_name = s.transit_line_name "
	                                 + "    JOIN (SELECT transit_line_name, COUNT(*) AS total_stop_count FROM Stop GROUP BY transit_line_name) AS total_stops "
	                                 + "        ON total_stops.transit_line_name = r.transit_line_name "
	                                 + "    JOIN (SELECT t1.transit_line_name, t1.stop_num AS start_stop_num, t2.stop_num AS end_stop_num, "
	                                 + "        t2.stop_num - t1.stop_num AS stop_difference "
	                                 + "        FROM Stop AS t1 JOIN Stop AS t2 ON t1.transit_line_name = t2.transit_line_name WHERE t1.stop_num < t2.stop_num "
	                                 + "    ) AS stop_count ON stop_count.transit_line_name = r.transit_line_name "
	                                 + "    AND stop_count.start_stop_num = ( "
	                                 + "        SELECT stop_num FROM Stop WHERE station_id = (SELECT station_id FROM Station WHERE name = r.start_stop) "
	                                 + "        AND transit_line_name = r.transit_line_name "
	                                 + "    ) "
	                                 + "    AND stop_count.end_stop_num = ( "
	                                 + "        SELECT stop_num FROM Stop WHERE station_id = (SELECT station_id FROM Station WHERE name =   r.end_stop) "
	                                 + "        AND transit_line_name = r.transit_line_name "
	                                 + "    ) "
	                                 + ") AS monthly_sales ON monthly_sales.reservation_number_id = r.reservation_number_id GROUP BY YEAR(r.date_made), "
	                                 + "MONTH(r.date_made) ORDER BY year, month DESC;";
	
	                    PreparedStatement ps = con.prepareStatement(query); ResultSet rs = ps.executeQuery();
	
	                    if (!rs.isBeforeFirst()) {
	                        out.println("<tr><td colspan='3'>No sales data available.</td></tr>");
	                    } 
	                    else {
	                        while (rs.next()) { int year = rs.getInt("year"); int month = rs.getInt("month"); double totalSales = rs.getDouble("total_sales");
	            %>
	            <tr>
	                <td><%= year %></td> <td><%= month %></td> <td>$<%= String.format("%.2f", totalSales) %></td>
	            </tr>
	            <%
	                        }
	                    }
                        rs.close(); ps.close(); con.close();
                    } 
                    catch (Exception e) { out.println("<p>Error retrieving data: " + e.getMessage() + "</p>"); }
            	%>
	        </tbody>
	    </table>
	</div>
	
</body>
</html>