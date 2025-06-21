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
	    <h2 class="text-center">Manage Customer Representatives</h2>
	    <div class="tabs">
	        <div class="tab active" onclick="openTab(event, 'createTab')">Add Representative</div>
	        <div class="tab" onclick="openTab(event, 'updateTab')">Edit Representative</div>
	        <div class="tab" onclick="openTab(event, 'deleteTab')">Remove Representative</div>
	    </div>
	
	    <%
	        String error = (String) session.getAttribute("error");
	        if (error != null) { out.println("<p style='color:red;'>" + error + "</p>"); session.removeAttribute("error"); }
	    %>
	
		<div id="createTab" class="tab-content active">
		    <form action="supportSignIn.jsp" method="post"> 
		    	<input type="hidden" name="action" value="create">   <input type="text" name="username" placeholder="Username" required>
		        <input type="password" name="password" placeholder="Password" required>
		        <input type="text"  name="firstName" placeholder="First Name" required>
		        <input type="text"  name="lastName"  placeholder="Last Name"  required>
		        <input type="text" name="ssn" placeholder="Enter SSN" required>        
		        
		        <button type="submit" style="background-color: green; color: white;">Submit Form</button>
		    </form>
		    
		    <%
		        if ("create".equals(request.getParameter("action"))) {
		            String ssn = request.getParameter("ssn");             String username = request.getParameter("username");
		            String password = request.getParameter("password");
		            String firstName = request.getParameter("firstName"); String lastName = request.getParameter("lastName");
		
		            String ssnRegex = "^(\\d{3}-\\d{2}-\\d{4})$";
		            if (!ssn.matches(ssnRegex)) { session.setAttribute("error", "Invalid SSN format. Please use '123-45-6789'.");
		                response.sendRedirect("supportSignIn.jsp"); return;
		            }
		
		            try {
		                ApplicationDB db = new ApplicationDB(); Connection con = db.getConnection();
		                String checkQuery = "SELECT COUNT(*) AS count FROM Employee WHERE ssn = ? OR username = ?";
		                
		                PreparedStatement psCheck = con.prepareStatement(checkQuery);  psCheck.setString(1, ssn); psCheck.setString(2, username);
		                ResultSet rsCheck = psCheck.executeQuery();
		
		                if (rsCheck.next() && rsCheck.getInt("count") > 0) {
		                    session.setAttribute("error", "SSN or Username already exists."); response.sendRedirect("supportSignIn.jsp"); return;
		                }
		
		                String insertEmployee = "INSERT INTO Employee (ssn, username, password, first_name, last_name) VALUES (?, ?, ?, ?, ?)";
		                PreparedStatement psInsertEmployee = con.prepareStatement(insertEmployee);
		                
		                psInsertEmployee.setString(1, ssn);  psInsertEmployee.setString(2, username);  psInsertEmployee.setString(3, password);
		                psInsertEmployee.setString(4, firstName);  psInsertEmployee.setString(5, lastName);   psInsertEmployee.executeUpdate();
		
		                String insertSupport = "INSERT INTO Support (username) VALUES (?)";
		                PreparedStatement psInsertSupport = con.prepareStatement(insertSupport);
		                psInsertSupport.setString(1, username); psInsertSupport.executeUpdate();
		
		                psInsertEmployee.close();   psInsertSupport.close();   con.close();
		            } 
		            catch (Exception e) { out.println("<p>Error adding data: " + e.getMessage() + "</p>"); }
		        }
		    %>
		</div>
	
		<div id="updateTab" class="tab-content">
		    <form action="supportSignIn.jsp" method="post">
		        <input type="hidden" name="action" value="search"> <input type="text" name="username"  placeholder="Enter Username"  required>
		        <button type="submit">LookUp</button>
		    </form>
		    
		    <% if ("search".equals(request.getParameter("action"))) { String username = request.getParameter("username");
		    	try {
		            ApplicationDB db = new ApplicationDB(); Connection con = db.getConnection();
		            String searchQuery = "SELECT * FROM Employee WHERE username = ?";
		            
		            PreparedStatement ps = con.prepareStatement(searchQuery); ps.setString(1, username); ResultSet rs = ps.executeQuery();
		
		            if (rs.next()) {
		    %>
		    <form action="supportSignIn.jsp" method="post"> <input type="hidden" name="action" value="update">
		        <table>
		            <thead> <tr> <th>SSN</th><th>Username</th><th>Password</th><th>First Name</th><th>Last Name</th><th>Action</th> </tr>  </thead>
		            <tbody>
		                <tr>
		                    <td><input type="text" name="ssn"  value="<%= rs.getString("ssn") %>" readonly></td>
		                    <td><input type="text" name="username" value="<%= rs.getString("username") %>"></td>
		                    <td><input type="text" name="password" value="<%= rs.getString("password") %>"></td>
		                    <td><input type="text" name="firstName" value="<%= rs.getString("first_name") %>"></td>
		                    <td><input type="text" name="lastName" value="<%= rs.getString("last_name") %>"></td>
	<td><button type="submit" style="background-color: green; color: white; border: none; padding: 10px 20px; cursor: pointer;">Update</button></td>
		                </tr>
		            </tbody>
		        </table>
		    </form>
		    <% } 
		            else {
			        session.setAttribute("error", "No representative found with username: " + username); response.sendRedirect("supportSignIn.jsp");
			    	}
                    rs.close(); ps.close(); con.close();
                } 
                catch (Exception e) { out.println("<p>Error retrieving data: " + e.getMessage() + "</p>"); }
            }
		    %>
		
		    <% if ("update".equals(request.getParameter("action"))) {
		        String ssn = request.getParameter("ssn");             String username = request.getParameter("username");
		        String password = request.getParameter("password");
		        String firstName = request.getParameter("firstName"); String lastName = request.getParameter("lastName");
		
		        try {
		            ApplicationDB db = new ApplicationDB(); Connection con = db.getConnection();
		            String updateQuery = "UPDATE Employee SET username = ?, password = ?, first_name = ?, last_name = ? WHERE ssn = ?";
		            
		            PreparedStatement ps = con.prepareStatement(updateQuery);   ps.setString(1, username);   ps.setString(2, password);
		            ps.setString(3, firstName);  ps.setString(4, lastName);  ps.setString(5, ssn);  ps.executeUpdate();   ps.close();  con.close();
		        }
		        catch (Exception e) { out.println("<p>Error updating data: " + e.getMessage() + "</p>"); }
		    }
		    %>
		</div>
	
	    <div id="deleteTab" class="tab-content">
		    <form action="supportSignIn.jsp" method="post">
		        <input type="hidden" name="action" value="delete">     <input type="text" name="username"  placeholder="Enter Username"  required>
		        <button type="submit" 
		        	style="background-color: #d9534f; padding: 15px 30px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); 
		        	transition: background-color 0.3s ease; justify-content: center;"> Delete
		    	</button>
		    </form>
		    
		    <p style="text-align: center; color: #999; margin-top: 20px; font-size: 14px;"> Note: Deleting an employee is permanent and cannot be undone. </p>
		    
		    <%
		        if ("delete".equals(request.getParameter("action"))) { String username = request.getParameter("username");
		            try {
		                ApplicationDB db = new ApplicationDB(); Connection con = db.getConnection();
		
		                if ("admin".equals(username)) {
		                    session.setAttribute("error", "Error: Admin account cannot be deleted."); response.sendRedirect("supportSignIn.jsp");
		                    return;
		                }
		                String checkUserQuery = "SELECT COUNT(*) AS count FROM Employee WHERE username = ?";
		                PreparedStatement psCheckUser = con.prepareStatement(checkUserQuery); psCheckUser.setString(1, username);
		                
		                ResultSet rs = psCheckUser.executeQuery();
		
		                if (rs.next() && rs.getInt("count") == 0) { session.setAttribute("error", "Error: User does not exist.");
		                    response.sendRedirect("supportSignIn.jsp");
		                } 
		                else {
		                    String deleteSupportQuery = "DELETE FROM Support WHERE username = ?";
		                    
		                    PreparedStatement psDeleteSupport = con.prepareStatement(deleteSupportQuery);
		                    psDeleteSupport.setString(1, username);      psDeleteSupport.executeUpdate();
		
		                    String deleteEmployeeQuery = "DELETE FROM Employee WHERE username = ?";
		                    
		                    PreparedStatement psDeleteEmployee = con.prepareStatement(deleteEmployeeQuery);
		                    psDeleteEmployee.setString(1, username);      psDeleteEmployee.executeUpdate();
		                    
		                    session.removeAttribute("error");
		                }
		                rs.close(); psCheckUser.close(); con.close();
		            }
		            catch (Exception e) { out.println("<p>Error retrieving data: " + e.getMessage() + "</p>"); }
		        }
		    %>
		</div>
	</div>

</body>
</html>