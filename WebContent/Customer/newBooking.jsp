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
		
	    input, select { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 8px; font-size: 16px;  box-sizing: border-box; 
	    	font-family: 'American Typewriter', serif;  
	    }
	
	    table { width: 100%; border-spacing: 10px; } td { padding: 5px; }
	
	    .container form button { 
	    	display: block; width: 100%; color: white; font-size: 16px; border: none; cursor: pointer; padding: 10px 20px; margin: 20px auto; 
	    	border-radius: 5px;  font-family: 'American Typewriter', serif; text-align: center; transition: background-color 0.3s ease;
	    }
	
	    .container form button[type="submit"] { background-color: #4CAF50; } 
	    
	    .container form button[type="submit"]:hover { background-color: #45a049; }
	    
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

    <div class="container"> <h2>Create a Reservation</h2>
    
        <form action="postBooking.jsp" method="post">

            <table>
                <tr>
                    <td><input required name="transitLine" type="text" placeholder="Transit Line Name" /></td>
                    <td>
                        <select required name="class">  <option value="economy">Economy</option> <option value="business">Business</option> 
                        </select>
                    </td>
                    <td><input required name="originID" type="text" placeholder="Origin Station ID" /></td>
                    <td><input required name="destID" type="text" placeholder="Destination Station ID" /></td>
                    <td><input required name="seatNumber" type="text" placeholder="Seat Number" /></td>
                    
                    <td>
                        <select required name="isRoundTrip"> <option value="false">One-Way</option> <option value="true">Round Trip</option>
                        </select>
                    </td>
                    <td>
                        <select required name="fareType"> 
                        	<option value="none">None</option>  <option value="child">Child</option>  <option value="senior">Senior</option> 
                        	<option value="disabled">Disabled</option>
                        </select>
                    </td>
                </tr>
            </table>
            
            <% 
		       String messageError = (String) session.getAttribute("messageError");
		
		        if (messageError != null) {
		    %>
		        <p style="color: red; text-align: center;"><%= messageError %></p>
		    <% 
		            session.removeAttribute("messageError");
		        }
		    %>
		    
            <button type="submit">Submit Form</button>
        </form>
        
        <a href="reservations.jsp" class="return-button">Return Back</a>
    </div>
</body>
</html>