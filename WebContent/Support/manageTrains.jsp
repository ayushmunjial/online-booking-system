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
        
        	<div class="nav-links"> <a href="supportHome.jsp">Return Home</a> </div>
	        
            <a href="../logout.jsp" class="button bg-white black fw-600 no-underline mx-5 py-5 px-8 rounded-lg shadow-lg hover-bg-gray-200"
               style="font-size: 18px;"> Logout </a>
        </div>
    </nav>
    
    <div class="container">
    <div class="tabs">
        <div class="tab active" onclick="openTab(event, 'editTab')">Edit Train Schedules</div>
        <div class="tab" onclick="openTab(event, 'deleteTab')">Delete Train Schedules</div>
    </div>

	<div id="editTab" class="tab-content active">
		<%
		String schedError = (String) session.getAttribute("schedError");		
		if (schedError != null) { out.println("<p style='color: red;'>" + schedError + "</p>"); session.removeAttribute("schedError"); }
		
	    String stopError = (String) session.getAttribute("stopError");
	    if (stopError != null) {  out.println("<p style='color: red;'>" + stopError + "</p>");   session.removeAttribute("stopError"); }
		%>
		
	    <form action="manageTrains.jsp" method="post" style="margin-bottom: 20px;"> <input type="hidden" name="editAction" value="edit">
	        <input type="text" name="transitLine" placeholder="Enter Transit Line Name" required style="padding: 10px; width: 50%; margin-bottom: 10px;">
	        <button type="submit">LookUp Train</button>
	    </form>
	
	    <%
	    String editAction = request.getParameter("editAction");
	    if ("edit".equals(editAction)) {
	        try {
	            ApplicationDB db = new ApplicationDB();   Connection con = db.getConnection();  String transitLine = request.getParameter("transitLine");
	            String query = "SELECT * FROM Schedule WHERE transit_line_name = ?";
	            
	            PreparedStatement ps = con.prepareStatement(query); ps.setString(1, transitLine); ResultSet rs = ps.executeQuery();
	
	            if (rs.next()) {
	                String trainID = rs.getString("train_id"); String origin = rs.getString("origin");  String destination = rs.getString("destination");
	                String departure = rs.getString("departure_datetime"); String arrival = rs.getString("arrival_datetime");
	                
	                double baseFare = rs.getDouble("base_fare"); boolean isDelayed = rs.getBoolean("isDelayed");
	                %>
	                <form action="updateSched.jsp" method="post">
	                    <table>
	                    	<tr> <th>Transit Line Name</th> <th>Train ID</th>  <th>Base Fare</th>  <th>Delayed</th> <th>Origin</th> <th>Destination</th>
	                            <th>Departure Time</th> <th>Arrival Time</th>
	                        </tr>
	                        
	                        <tr>
	                            <td><input type="text" name="transitLine" value="<%= transitLine %>" style="width: 100%; padding: 10px;" readonly></td>
	                            <td><input type="number" name="trainID" value="<%= trainID %>" style="width: 100%; padding: 10px;" readonly></td>
	                            <td><input type="number" step="0.01" name="baseFare" value="<%= baseFare %>"  style="width: 100%; padding: 10px;"></td>
	                            
	                            <td>
	                                <select name="isDelayed" style="width: 100%; padding: 10px;">
	                                    <option value="false" <%= isDelayed ? "" : "selected" %>>No</option>
	                                    <option value="true" <%= isDelayed ? "selected" : "" %>>Yes</option>
	                                </select>
	                            </td>
	                            
	                            <td><input type="text" name="origin" value="<%= origin %>" style="width: 100%; padding: 10px;"></td>
	                            <td><input type="text" name="destination" value="<%= destination %>" style="width: 100%; padding: 10px;"></td>
	                            <td><input type="text" name="departure" value="<%= departure %>" style="width: 100%; padding: 10px;"></td>
	                            <td><input type="text" name="arrival"   value="<%= arrival %>"   style="width: 100%; padding: 10px;"></td>
	                        </tr>
	                    </table>
	
	                    <button type="submit" 
	                        style="background-color: green; padding: 15px 30px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); 
	                        transition: background-color 0.3s ease; justify-content: center;"> Submit Form
	                    </button>
	                </form>
	
	                <h4>Modify Stops for Transit Line: <%= transitLine %></h4>
	                <table>
	                    <tr> <th>Station Name</th> <th>Station ID</th> <th>Arrival Time</th> <th>Departure Time</th> <th>Actions</th> </tr>
	                    
	                    <%
	                    String stopsQuery  = "SELECT s.name, st.station_id, st.arrival_time, st.departure_time FROM Stop st JOIN Station s ON " + 
	                    					 "st.station_id = s.station_id WHERE st.transit_line_name = ?";
	                    
	                    PreparedStatement stopsPs = con.prepareStatement(stopsQuery); stopsPs.setString(1, transitLine);  ResultSet stopsRs = stopsPs.executeQuery();
	
	                    while (stopsRs.next()) {
	                        String stationName = stopsRs.getString("name");  String stationID = stopsRs.getString("station_id");
	                        String arrivalTime = stopsRs.getString("arrival_time");  String departureTime = stopsRs.getString("departure_time");
	                    %>
	                    <tr>
	                        <td><input type="text" name="stationName_<%= stationID %>" value="<%= stationName %>" style="width: 100%; padding: 10px;" readonly></td>
	                        <td><input type="text" name="stationID_<%= stationID %>"   value="<%= stationID %>"   style="width: 100%; padding: 10px;" readonly></td>
	                        
	                        <td><input type="text" name="arrivalTime_<%= stationID %>"   value="<%= arrivalTime %>"   style="width: 100%; padding: 10px;"></td>
	                        <td><input type="text" name="departureTime_<%= stationID %>" value="<%= departureTime %>" style="width: 100%; padding: 10px;"></td>
	                        
	                        <td>
	                        
	                        <form id="form_<%= stationID %>" action="updateStops.jsp" method="post" style="display: inline-block;">
	                            <input type="hidden" name="stationID" value="<%= stationID %>"> <input type="hidden" name="action" value="update">
	                            <button type="submit" style="background-color: green; color: white; border: none; padding: 10px 20px; cursor: pointer;">Update</button>
	                        </form>
	                        
	                        <form action="updateStops.jsp" method="post" style="display: inline-block;">
	                            <input type="hidden" name="stationID" value="<%= stationID %>"> <input type="hidden" name="action" value="delete">
	                            <button type="submit" style="background-color:   red; color: white; border: none; padding: 10px 20px; cursor: pointer;">Delete</button>
	                        </form>
	                        
	                        </td>
	                    </tr>
	                    <%
	                    } 
	                    stopsRs.close(); stopsPs.close();
	                    %>
	                </table>
	                <%
	            } 
	            else { out.print("<p>No schedule found for the specified transit line.</p>"); } rs.close(); ps.close(); db.closeConnection(con);
	        } 
	        catch (Exception e) {  out.println("<p>Error retrieving data: " + e.getMessage() + "</p>"); }
	    }
	    %>
	</div>

    <div id="deleteTab" class="tab-content">
        <form action="manageTrains.jsp" method="post">
        	<input type="hidden" name="deleteAction" value="delete"> <input type="text" name="transitLine" placeholder="Enter Transit Line Name" required>
            
            <button type="submit" 
		        	style="background-color: #d9534f; padding: 15px 30px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); 
		        	transition: background-color 0.3s ease; justify-content: center;"> Delete
		    </button>
        </form>
        
        <p style="text-align: center; color: #999; margin-top: 20px; font-size: 14px;"> Note: Deleting a schedule is permanent and cannot be undone. </p>

        <%
        String deleteAction = request.getParameter("deleteAction");
        if ("delete".equals(deleteAction)) {
            try { 
            	ApplicationDB db = new ApplicationDB();   Connection con = db.getConnection();   String transitLine = request.getParameter("transitLine");
                String deleteQuery = "DELETE FROM Schedule WHERE transit_line_name = ?"; 
                
                PreparedStatement ps = con.prepareStatement(deleteQuery); ps.setString(1, transitLine);     int rowsAffected = ps.executeUpdate();

            if (rowsAffected <= 0) { out.print("<p>No schedule found for the specified transit line.</p>"); } 
            	ps.close(); db.closeConnection(con);
            }
            catch (Exception e) {      out.println("<p>Error retrieving data: " + e.getMessage() + "</p>"); }
        }
        %>
    </div>
</div>

</body>
</html>