<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" 
	import="com.cs336.pkg.*, java.io.*, java.util.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*"%>

<%

    try {
        ApplicationDB db = new ApplicationDB(); Connection con = db.getConnection(); String startStop = ""; String endStop = ""; 
        String username = (String) session.getAttribute("username");   String transitLine = request.getParameter("transitLine"); 
        
        String startStopID = request.getParameter("originID"); String endStopID = request.getParameter("destID");
        String seatNumber = request.getParameter("seatNumber"); String tripClass = request.getParameter("class");
        
        String fareType = request.getParameter("fareType"); 
        boolean isRoundTrip = "true".equals(request.getParameter("isRoundTrip"));      String passengerName = "";
        
        String trainLineQuery = "SELECT COUNT(*) AS line_count FROM Schedule WHERE transit_line_name = ?";
        
        PreparedStatement psTrainLine = con.prepareStatement(trainLineQuery); psTrainLine.setString(1, transitLine);
        ResultSet rsTrainLine = psTrainLine.executeQuery();
        
        if (rsTrainLine.next() && rsTrainLine.getInt("line_count") == 0) {
            session.setAttribute("messageError", "Invalid train line. Check the train line and try booking again.");
            response.sendRedirect("newBooking.jsp"); return;
        }
        
        rsTrainLine.close(); psTrainLine.close();

        String customerQuery = "SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM Customer WHERE username = ?";
        
		PreparedStatement psCustomer = con.prepareStatement(customerQuery); psCustomer.setString(1, username);
        ResultSet rsCustomer = psCustomer.executeQuery();
            		
        if (rsCustomer.next()) { passengerName = rsCustomer.getString("full_name"); }
        
        rsCustomer.close(); psCustomer.close();

        if (startStopID.equals(endStopID)) {
            session.setAttribute("messageError", "Start and end stops cannot be the same. Pick a valid stop pair.");
            response.sendRedirect("newBooking.jsp"); return;
        }

        String stationQuery = "SELECT name FROM Station WHERE station_id = ?";
        
        PreparedStatement psStation = con.prepareStatement(stationQuery); psStation.setString(1, startStopID);
        ResultSet rsStartStop = psStation.executeQuery();
        
        if (rsStartStop.next()) { startStop = rsStartStop.getString("name"); } rsStartStop.close();

        psStation.setString(1, endStopID); ResultSet rsEndStop = psStation.executeQuery();
        
        if (rsEndStop.next()) { endStop = rsEndStop.getString("name"); } rsEndStop.close(); psStation.close();

        String stopOrderQuery = "SELECT t1.stop_num AS origin_stop, t2.stop_num AS dest_stop FROM Stop t1 " +
                                "JOIN Stop t2 ON t1.transit_line_name = t2.transit_line_name " +
                                "WHERE t1.transit_line_name = ? AND t1.station_id = ? AND t2.station_id = ?";
        
        PreparedStatement psStopOrder = con.prepareStatement(stopOrderQuery);
        psStopOrder.setString(1, transitLine); psStopOrder.setString(2, startStopID); psStopOrder.setString(3, endStopID);
        ResultSet rsStopOrder = psStopOrder.executeQuery();

        if (rsStopOrder.next()) {
            int originStop = rsStopOrder.getInt("origin_stop"); int destStop = rsStopOrder.getInt("dest_stop");
            if (originStop >= destStop) {
                session.setAttribute("messageError", "Origin must come before destination. Please check and retry.");
                response.sendRedirect("newBooking.jsp"); return;
            }
        } 
        else {
            session.setAttribute("messageError","Stops not valid for this transit line. Pick valid stops instead.");
            response.sendRedirect("newBooking.jsp"); return;
        }
        rsStopOrder.close(); psStopOrder.close();

        // Fetch base fare and schedule date
        String scheduleQuery = "SELECT base_fare, departure_datetime FROM Schedule WHERE transit_line_name = ?";
        PreparedStatement psSchedule = con.prepareStatement(scheduleQuery);
        psSchedule.setString(1, transitLine);
        ResultSet rsSchedule = psSchedule.executeQuery();

        java.util.Date currentDate = new java.util.Date();
        if (rsSchedule.next()) {
            java.util.Date scheduleDate = rsSchedule.getTimestamp("departure_datetime");
            
            if (scheduleDate.before(currentDate)) {
                session.setAttribute("messageError", "Cannot book for an expired schedule. Pick a valid schedule.");
                response.sendRedirect("newBooking.jsp"); return;
            }
        }
        
        rsSchedule.close(); psSchedule.close();

        String reservationQuery = "INSERT INTO Reservation (username, transit_line_name, start_stop, end_stop, date_made, " + 
        				"is_round_trip, seat_number, class, fare_type, passenger) VALUES (?, ?, ?, ?, NOW(), ?, ?, ?, ?, ?)";
        
        PreparedStatement psReservation = con.prepareStatement(reservationQuery); psReservation.setString(1, username);
        
        psReservation.setString(2, transitLine);   psReservation.setString(3, startStop);   psReservation.setString(4, endStop);
        psReservation.setBoolean(5, isRoundTrip); psReservation.setString(6, seatNumber); psReservation.setString(7, tripClass);
        
        psReservation.setString(8, fareType); psReservation.setString(9, passengerName); psReservation.executeUpdate();
        psReservation.close();

        response.sendRedirect("reservations.jsp"); db.closeConnection(con);
    } 
	catch (Exception e) { session.setAttribute("errorMessage", "An unexpected error occurred. Please try again."); 
      	response.sendRedirect("newBooking.jsp");
    }
%>