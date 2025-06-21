<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" 
	import="com.cs336.pkg.*, java.io.*, java.util.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*, java.text.*"%>

<%
    try {
    	String transitLine = request.getParameter("transitLine");    String baseFare = request.getParameter("baseFare"); 
    	String isDelayed = request.getParameter("isDelayed");  String departureTime = request.getParameter("departure");
        String arrivalTime = request.getParameter("arrival"); String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");  session  =  request.getSession();    session.removeAttribute("schedError");
        
        SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  dateTimeFormat.setLenient(false);
        
        ApplicationDB db = new ApplicationDB(); Connection con = db.getConnection();

        try {
            java.util.Date departureDate = dateTimeFormat.parse(departureTime); java.util.Date arrivalDate = dateTimeFormat.parse(arrivalTime);

            if (departureDate.after(arrivalDate)) { 
            	session.setAttribute("schedError", "Departure time must be before arrival time.");   response.sendRedirect("manageTrains.jsp");
                return;
            }
        } 
        catch (ParseException e) { session.setAttribute("schedError", "Invalid datetime format. Please use 'yyyy-MM-dd HH:mm:ss'."); 
            response.sendRedirect("manageTrains.jsp"); return;
        }

        try {
            float fare = Float.parseFloat(baseFare);
            if (fare < 0) {
                session.setAttribute("schedError", "Base fare must be a positive value.");  response.sendRedirect("manageTrains.jsp"); return;
            }
        } 
        catch (NumberFormatException e) {
            session.setAttribute("schedError", "Invalid base fare. Please enter a numeric value."); response.sendRedirect("manageTrains.jsp");
            return;
        }
        
        String checkTransitLineQuery = "SELECT COUNT(*) AS count FROM Schedule WHERE transit_line_name = ?";
        PreparedStatement ps = con.prepareStatement(checkTransitLineQuery);   ps.setString(1, transitLine);   ResultSet rs = ps.executeQuery();
        
        if (rs.next() && rs.getInt("count") == 0) {       session.setAttribute("schedError", "Transit line does not exist."); 
        	response.sendRedirect("manageTrains.jsp"); return;
        }

        String validateStationQuery = "SELECT COUNT(*) AS count FROM Station WHERE name = ?";
        PreparedStatement psValidate = con.prepareStatement(validateStationQuery);

        psValidate.setString(1, origin); rs = psValidate.executeQuery();
        
        if (rs.next() && rs.getInt("count") == 0) {
            session.setAttribute("schedError", "Origin station does not exist.");  response.sendRedirect("manageTrains.jsp"); 
            return;
        }

        psValidate.setString(1, destination); rs = psValidate.executeQuery();
        if (rs.next() && rs.getInt("count") == 0) {
        session.setAttribute("schedError", "Destination station does not exist."); response.sendRedirect("manageTrains.jsp");
            return;
        }

        String updateScheduleQuery = "UPDATE Schedule SET base_fare = ?, isDelayed = ?, departure_datetime = ?, arrival_datetime = ?, origin = " 
        							 + "?, destination = ? WHERE transit_line_name = ?";
        
        ps = con.prepareStatement(updateScheduleQuery);        ps.setFloat(1, Float.parseFloat(baseFare)); 
        ps.setBoolean(2, Boolean.parseBoolean(isDelayed)); ps.setString(3, departureTime); ps.setString(4, arrivalTime); ps.setString(5, origin);
        ps.setString(6, destination); ps.setString(7, transitLine); int rowsAffected = ps.executeUpdate();

        if (rowsAffected > 0) {
            String firstStopQuery = "SELECT station_id FROM Stop WHERE transit_line_name = ? ORDER BY arrival_time ASC LIMIT 1";
            String lastStopQuery = "SELECT station_id FROM Stop WHERE transit_line_name = ? ORDER BY arrival_time DESC LIMIT 1";

            PreparedStatement psFirstStop = con.prepareStatement(firstStopQuery); psFirstStop.setString(1, transitLine); 
            rs = psFirstStop.executeQuery();
            
            if (rs.next()) { String firstStationID = rs.getString("station_id"); 
                String updateFirstStop = "UPDATE Stop SET departure_time = ? WHERE station_id = ? AND transit_line_name = ?";
                
                PreparedStatement psUpdateFirstStop = con.prepareStatement(updateFirstStop);     psUpdateFirstStop.setString(1, departureTime); 
                psUpdateFirstStop.setString(2, firstStationID); psUpdateFirstStop.setString(3, transitLine); psUpdateFirstStop.executeUpdate();
            }

            PreparedStatement psLastStop = con.prepareStatement(lastStopQuery);   psLastStop.setString(1, transitLine);
            rs = psLastStop.executeQuery();
            
            if (rs.next()) {  String lastStationID = rs.getString("station_id");
                String updateLastStop  =  "UPDATE Stop SET arrival_time = ? WHERE station_id = ? AND transit_line_name = ?";
                
                PreparedStatement psUpdateLastStop = con.prepareStatement(updateLastStop);          psUpdateLastStop.setString(1, arrivalTime);
                psUpdateLastStop.setString(2, lastStationID);     psUpdateLastStop.setString(3, transitLine); psUpdateLastStop.executeUpdate();
            }
            
            response.sendRedirect("manageTrains.jsp");
        } 
        else {
            session.setAttribute("schedError", "Schedule update failed. No rows were updated.");
        }
        rs.close(); ps.close(); con.close();
    }
	catch (Exception e) { out.println("<p>Error retrieving data: " + e.getMessage() + "</p>"); }
%>