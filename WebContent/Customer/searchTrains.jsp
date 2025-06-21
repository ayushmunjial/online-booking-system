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
        
        	<div class="nav-links"> <a href="../userHome.jsp">Return Home</a> </div>
	        
            <a href="../logout.jsp" class="button bg-white black fw-600 no-underline mx-5 py-5 px-8 rounded-lg shadow-lg hover-bg-gray-200"
               style="font-size: 18px;"> Logout </a>
        </div>
    </nav>

    <div class="container">

        <div class="tabs">
            <div class="tab active" onclick="openTab(event, 'tab1')">Search and Sort All Trains</div>
            <div class="tab" onclick="openTab(event, 'tab2')">Search Train Schedules</div>
            <div class="tab" onclick="openTab(event, 'tab3')">Browse All Train Stops</div>
        </div>

        <div id="tab1" class="tab-content active">
            <form action="showTrains.jsp" method="post">
            
                <select name="sortType">
                <option value="destination">Destination</option> <option value="origin">Origin</option> <option value="arrival_time">Arrival</option> 
                    <option value="departure_time">Departure</option> <option value="base_fare">Base Fare</option>
                </select>
                
                <select name="sortOrder"> 
                	<option value="ascending">Ascending</option> <option value="descending">Descending</option> </select>
                <button>Search</button>
            </form>
        </div>

        <div id="tab2" class="tab-content">
            <form action="showScheds.jsp" method="post">   <input name="origin" type="number" placeholder="Enter origin station ID" required />
        		<input name="dest"  type="number"  placeholder="Enter destination station ID" required />  <input name="date" type="date" required/> 
        		<button>Search</button>
            </form>
        </div>

        <div id="tab3" class="tab-content">
            <form  action="showStops.jsp"  method="post">   <input  name="origin"  type="number"  placeholder="Enter origin station ID"  required />
                <input name="dest" type="number" placeholder="Enter destination station ID" required />
                <input name="line" type="text" placeholder="Enter transit line name" required /> <button>Search</button>
            </form>
        </div>
    </div>
    
</body>
</html>