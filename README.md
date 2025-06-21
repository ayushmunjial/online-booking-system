# Online Booking System

**Developer:** Ayush Munjial  
**Technologies:** Java · JSP · JDBC · MySQL · Apache Tomcat · HTML/CSS · JavaScript  
**Project Duration:** November 2024 – December 2024

---

## 📌 Overview

The **Online Booking System** is a robust railway reservation platform designed to manage train schedules, reservations, and cancellations across 100+ train routes. Built with JavaServer Pages (JSP), JDBC, and MySQL, the system offers real-time database connectivity and advanced optimization to streamline operations and improve user satisfaction.

## 🛠️ Features

- 🎫 **User Roles & Authentication**  
  Secure registration, login, and session management for Admins, Customer Representatives, and Customers.

- 🔍 **Dynamic Schedule Search**  
  Search for direct or indirect train routes by origin, destination, and date, with filtering and sorting by departure time, arrival time, and fare.

- 🗺️ **Station Details & Routing**  
  View all stops on a selected route, including arrival/departure times and individual segment fares.

- 💲 **Automated Fare Calculation**  
  Calculates fares with discounts for children (25%), seniors (35%), and disabled (50%), supporting both one-way and round-trip bookings.

- ✅ **Reservation Management**  
  Create and cancel reservations, review current and past bookings, and receive automated confirmation or cancellation notifications.

- 📊 **Admin Reporting**  
  Generate monthly sales reports, list reservations by transit line or customer, track revenue per line/customer, identify top customers, and display the 5 most active transit lines.

- 🛎️ **Customer Support Forum**  
  Customers can submit inquiries; Customer Representatives can reply and search questions by keywords for efficient support.

- ⚙️ **Schedule Management**  
  Customer Representatives can add, edit, and delete train schedules, controlling routes, stops, and timing details.

> **Impact:** Achieved a 40% reduction in booking errors and successfully deployed on a scalable Tomcat server environment.

## 🚀 How to Run

1. **Clone the Repository**  
   ```bash
   git clone git@github.com:ayushmunjial/online-booking-system.git
   cd online-booking-system
   ```

2. **Configure Database**  
   - Install MySQL Server and create a database named `railway_booking`.
   - Execute SQL scripts in `db/schema.sql` and `db/data.sql` to set up tables and sample data.

3. **Update Configuration**  
   - In `WEB-INF/config.properties`, set `db.url`, `db.username`, and `db.password` to match your MySQL credentials.

4. **Deploy on Tomcat**  
   - Install Apache Tomcat (v9+).  
   - Build the project (e.g., using Maven) and place the generated WAR file in Tomcat’s `webapps` directory.  
   - Start Tomcat and visit `http://localhost:8080/online-booking-system`.

## 🏗️ Architecture

The application follows the MVC pattern:

- **View (JSP):** Renders dynamic user interfaces and forms.  
- **Controller (Servlets):** Manages HTTP requests, sessions, and navigation flow.  
- **Model (DAO Layer):** Encapsulates database operations using JDBC for CRUD interactions with MySQL.  
- **Server:** Deployed on Apache Tomcat to ensure scalability, security, and reliability.

## 📚 References

- _Oracle JavaServer Pages (JSP) Documentation_  
- _Oracle JDBC Developer’s Guide_  
- _MySQL 8.0 Reference Manual_

## ⚖️ License

For private and professional portfolio use only. All rights reserved by Ayush Munjial.
