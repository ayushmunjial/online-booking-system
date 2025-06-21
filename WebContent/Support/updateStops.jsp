<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" 
	import="com.cs336.pkg.*, java.io.*, java.util.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*, java.text.*"%>
	
<%
    try {
    	ApplicationDB db = new ApplicationDB(); Connection con = db.getConnection(); PreparedStatement ps = null; ResultSet rs = null;
    	
        String action = request.getParameter("action"); String stationID = request.getParameter("stationID"); 
        String transitLine = request.getParameter("transitLine"); String arrivalTime = request.getParameter("arrivalTime");
    	String departureTime = request.getParameter("departureTime");    request.getSession().removeAttribute("stopError");

        SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  dateTimeFormat.setLenient(false);

        if ("update".equals(action)) {
            try {
                if (arrivalTime != null) dateTimeFormat.parse(arrivalTime);   if (departureTime != null) dateTimeFormat.parse(departureTime);
            } 
            catch (ParseException e) { request.getSession().setAttribute("stopError", "Invalid datetime format. Use 'yyyy-MM-dd HH:mm:ss'.");
                response.sendRedirect("manageTrains.jsp"); return;
            }

            String prevStopQuery = "SELECT arrival_time  FROM Stop WHERE transit_line_name = ? AND station_id < ? ORDER BY station_id DESC LIMIT 1";
            String nextStopQuery = "SELECT departure_time FROM Stop WHERE transit_line_name = ? AND station_id > ? ORDER BY station_id ASC LIMIT 1";

            PreparedStatement psPrev = con.prepareStatement(prevStopQuery); psPrev.setString(1, transitLine); psPrev.setString(2, stationID); 
            rs = psPrev.executeQuery();
            
            if (rs.next() && arrivalTime != null) { String prevDeparture = rs.getString("departure_time");
                if (prevDeparture != null && dateTimeFormat.parse(arrivalTime).before(dateTimeFormat.parse(prevDeparture))) {
                	
                    request.getSession().setAttribute("stopError", "Arrival time conflicts with the previous stop.");  
                    response.sendRedirect("manageTrains.jsp"); return;
                }
            }

            PreparedStatement psNext = con.prepareStatement(nextStopQuery); psNext.setString(1, transitLine); psNext.setString(2, stationID);
            rs = psNext.executeQuery();
            
            if (rs.next() && departureTime != null) {  String nextArrival = rs.getString("arrival_time");
                if (nextArrival != null  &&  dateTimeFormat.parse(departureTime).after(dateTimeFormat.parse(nextArrival))) {
                	
                    request.getSession().setAttribute("stopError", "Departure time conflicts with the next stop.");
                    response.sendRedirect("manageTrains.jsp"); return;
                }
            }

            String updateStopQuery = "UPDATE Stop SET arrival_time = ?, departure_time = ?  WHERE station_id = ? AND transit_line_name = ?";
            
            ps = con.prepareStatement(updateStopQuery);  ps.setString(1, arrivalTime);  ps.setString(2, departureTime);  ps.setString(3, stationID); 
            ps.setString(4, transitLine); ps.executeUpdate();

            String firstStopCheck = "SELECT station_id FROM Stop WHERE transit_line_name = ? ORDER BY station_id ASC LIMIT 1";
            
            ps = con.prepareStatement(firstStopCheck); ps.setString(1, transitLine); rs = ps.executeQuery();
            
            if (rs.next() && rs.getString("station_id").equals(stationID)) {
                String updateScheduleDeparture = "UPDATE Schedule SET departure_datetime = ? WHERE transit_line_name = ?";
                
                ps = con.prepareStatement(updateScheduleDeparture); ps.setString(1, departureTime); ps.setString(2, transitLine); ps.executeUpdate();
            }

            String lastStopCheck = "SELECT station_id FROM Stop WHERE transit_line_name = ? ORDER BY station_id DESC LIMIT 1";
            
            ps = con.prepareStatement(lastStopCheck); ps.setString(1, transitLine);  rs = ps.executeQuery();
            
            if (rs.next() && rs.getString("station_id").equals(stationID)) {
                String updateScheduleArrival = "UPDATE Schedule SET arrival_datetime = ? WHERE transit_line_name = ?";
                
                ps = con.prepareStatement(updateScheduleArrival);  ps.setString(1, arrivalTime);  ps.setString(2, transitLine);  ps.executeUpdate();
            }

        } 
        else if ("delete".equals(action)) {
            String firstStopCheck = "SELECT station_id FROM Stop WHERE transit_line_name = ? ORDER BY station_id ASC LIMIT 1";
            String lastStopCheck = "SELECT station_id FROM Stop WHERE transit_line_name = ? ORDER BY station_id DESC LIMIT 1";

            ps = con.prepareStatement(firstStopCheck); ps.setString(1, transitLine); rs = ps.executeQuery();
            
            if (rs.next() && rs.getString("station_id").equals(stationID)) {
                String updateScheduleOrigin = "UPDATE Schedule SET origin = ? WHERE transit_line_name = ?"; 
                
                ps = con.prepareStatement(updateScheduleOrigin);

                String nextStopQuery = "SELECT station_id, departure_time FROM Stop WHERE transit_line_name = ? AND station_id > ? ORDER BY station_id ASC LIMIT 1";
                
                ps = con.prepareStatement(nextStopQuery); ps.setString(1, transitLine); ps.setString(2, stationID); rs = ps.executeQuery();
                
                if (rs.next()) {
                    String nextStationID = rs.getString("station_id");  String nextDeparture = rs.getString("departure_time");
                    ps.setString(1, nextStationID); ps.executeUpdate();

                    String updateScheduleDeparture = "UPDATE Schedule SET departure_datetime = ? WHERE transit_line_name = ?";
                    ps = con.prepareStatement(updateScheduleDeparture); ps.setString(1, nextDeparture); ps.setString(2, transitLine); ps.executeUpdate();
                }
            }

            ps = con.prepareStatement(lastStopCheck); ps.setString(1, transitLine); rs = ps.executeQuery();
            
            if (rs.next() && rs.getString("station_id").equals(stationID)) {
                String updateScheduleDestination = "UPDATE Schedule SET destination = ? WHERE transit_line_name = ?";
                ps = con.prepareStatement(updateScheduleDestination);

                String prevStopQuery = "SELECT station_id, arrival_time FROM Stop WHERE transit_line_name = ? AND station_id < ? ORDER BY station_id DESC LIMIT 1";
                ps = con.prepareStatement(prevStopQuery); ps.setString(1, transitLine); ps.setString(2, stationID); rs = ps.executeQuery();
                
                if (rs.next()) {
                    String prevStationID = rs.getString("station_id"); String prevArrival = rs.getString("arrival_time");
                    ps.setString(1, prevStationID); ps.executeUpdate();

                    String updateScheduleArrival = "UPDATE Schedule SET arrival_datetime = ? WHERE transit_line_name = ?";
                    ps = con.prepareStatement(updateScheduleArrival);  ps.setString(1, prevArrival);  ps.setString(2, transitLine);  ps.executeUpdate();
                }
            }

            String deleteStopQuery = "DELETE FROM Stop WHERE station_id = ? AND transit_line_name = ?";
            ps = con.prepareStatement(deleteStopQuery);   ps.setString(1, stationID);   ps.setString(2, transitLine);   ps.executeUpdate();
        }

        response.sendRedirect("manageTrains.jsp"); rs.close(); ps.close(); con.close();
    }
	catch (Exception e) { out.println("<p>Error retrieving data: " + e.getMessage() + "</p>"); }
%>