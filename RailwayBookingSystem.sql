CREATE DATABASE IF NOT EXISTS `RailwayBookingSystem` DEFAULT CHARACTER SET latin1; USE `RailwayBookingSystem`;

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

DROP TABLE IF EXISTS `Train`; CREATE TABLE Train (train_id INT PRIMARY KEY AUTO_INCREMENT, num_seats INT, num_cars INT);

DROP TABLE IF EXISTS `Station`;
CREATE TABLE Station (station_id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(100) NOT NULL, city VARCHAR(50) NOT NULL, state VARCHAR(50) NOT NULL, zip VARCHAR(10));

DROP TABLE IF EXISTS `Schedule`;
CREATE TABLE Schedule (
    transit_line_name VARCHAR(100) PRIMARY KEY, isDelayed BOOLEAN DEFAULT FALSE, train_id INT NOT NULL, num_seats_available INT, 
    base_fare FLOAT NOT NULL, origin VARCHAR(50) NOT NULL, destination VARCHAR(50) NOT NULL, departure_datetime DATETIME NOT NULL, arrival_datetime DATETIME NOT NULL,
    
	FOREIGN KEY (train_id)  REFERENCES  Train(train_id) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `Stop`;
CREATE TABLE Stop (
    stop_num INT, transit_line_name VARCHAR(100) NOT NULL, station_id INT NOT NULL, arrival_time DATETIME, departure_time DATETIME, 
    
    PRIMARY KEY (stop_num, transit_line_name, station_id), FOREIGN KEY (station_id) REFERENCES Station(station_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (transit_line_name) REFERENCES Schedule(transit_line_name) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `Customer`;
CREATE TABLE Customer (
    username VARCHAR(50) PRIMARY KEY, email VARCHAR(100) UNIQUE NOT NULL, password VARCHAR(255) NOT NULL, first_name VARCHAR(50) NOT NULL, 
    last_name VARCHAR(50) NOT NULL, phone_num1 VARCHAR(15), phone_num2 VARCHAR(15), street_address VARCHAR(100), city VARCHAR(50), state VARCHAR(50), zip VARCHAR(10)
);

DROP TABLE IF EXISTS `Reservation`;
CREATE TABLE Reservation (
    reservation_number_id INT PRIMARY KEY AUTO_INCREMENT, username VARCHAR(50) NOT NULL, transit_line_name VARCHAR(100) NOT NULL, start_stop VARCHAR(50) NOT NULL, 
    end_stop VARCHAR(50) NOT NULL, CHECK (start_stop <> end_stop), date_made DATE NOT NULL, is_round_trip BOOLEAN DEFAULT FALSE, seat_number VARCHAR(10) NOT NULL,
    class Enum ('Economy', 'Business') NOT NULL, fare_type ENUM('Regular', 'Child', 'Senior', 'Disabled') NOT NULL, passenger VARCHAR(50) NOT NULL, 
    
    FOREIGN KEY (username) REFERENCES Customer(username) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (transit_line_name) REFERENCES Schedule(transit_line_name) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `Employee`;
CREATE TABLE Employee (
    ssn VARCHAR(11), username VARCHAR(50) PRIMARY KEY, password VARCHAR(255) NOT NULL, first_name VARCHAR(50) NOT NULL, last_name VARCHAR(50) NOT NULL
);

DROP TABLE IF EXISTS `Support`;
CREATE TABLE Support (username VARCHAR(50) PRIMARY KEY, FOREIGN KEY (username) REFERENCES Employee(username) ON DELETE CASCADE ON UPDATE CASCADE);

DROP TABLE IF EXISTS `Manager`;
CREATE TABLE Manager (username VARCHAR(50) PRIMARY KEY, FOREIGN KEY (username) REFERENCES Employee(username) ON DELETE CASCADE ON UPDATE CASCADE);

DROP TABLE IF EXISTS `Messages`;
CREATE TABLE Messages (
    message_id INT PRIMARY KEY AUTO_INCREMENT, customer_username VARCHAR(50) NOT NULL, support_username VARCHAR(50), content VARCHAR(450) NOT NULL, reply VARCHAR(450), 
    sender ENUM('Customer', 'Support') NOT NULL, timestamp DATETIME NOT NULL,
    
    FOREIGN KEY (support_username)  REFERENCES  Support(username) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (customer_username) REFERENCES Customer(username) ON DELETE CASCADE ON UPDATE CASCADE
);

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

INSERT INTO Employee (ssn, username, password, first_name, last_name) VALUES ('000-00-0000', 'admin', 'admin', 'Admin', 'Admin'); INSERT INTO Manager (username) VALUES ('admin');

INSERT INTO Employee (ssn, username, password, first_name, last_name) 
VALUES 
    ('111-11-1111', 'ayush_xyz', 'ayushpass', 'Ayush', 'XYZ'),  ('222-22-2222', 'krish_abc', 'krishpass', 'Krish', 'ABC');

INSERT INTO Support (username) VALUES ('ayush_xyz'), ('krish_abc');

INSERT INTO Train (train_id, num_seats, num_cars) VALUES (201, 120, 10);

INSERT INTO Station (station_id, name, city, state, zip) 
VALUES 
    (101, 'Trenton Transit Center', 'Trenton', 'NJ', '08608'), (102, 'New Brunswick Station', 'New Brunswick', 'NJ', '08901'), (103, 'Metropark Station', 'Iselin', 'NJ', '08830'),
    (104, 'Newark Penn Station', 'Newark', 'NJ', '07102'), (105, 'New York Penn Station', 'New York', 'NY', '10001');

INSERT INTO Schedule (transit_line_name, isDelayed, train_id, num_seats_available, base_fare, origin, destination, departure_datetime, arrival_datetime) 
VALUES 
	('Northeast Corridor', FALSE, 201, 120, 60, 'Trenton Transit Center', 'New York Penn Station', '2025-11-17 06:00:00', '2025-11-17 07:30:00');

INSERT INTO Stop (stop_num, transit_line_name, station_id, arrival_time, departure_time) 
VALUES 
    (1, 'Northeast Corridor', 101, NULL, '2025-11-17 06:00:00'), (2, 'Northeast Corridor', 102, '2025-11-17 06:20:00', '2025-11-17 06:22:00'), 
    (3, 'Northeast Corridor', 103, '2025-11-17 06:40:00', '2025-11-17 06:42:00'),
    (4, 'Northeast Corridor', 104, '2025-11-17 07:10:00', '2025-11-17 07:12:00'), (5, 'Northeast Corridor', 105, '2025-11-17 07:30:00', NULL);

INSERT INTO Customer (username, email, password, first_name, last_name, street_address, city, state, zip, phone_num1) 
VALUES 
	('john_paker_nec', 'john.paker.nec@example.com', 'pass12NEC2025', 'John', 'Paker', '789 Saint St', 'New York City', 'NY', '08608', '555-7890'),
    ('jane_smith_nec', 'jane.smith.nec@example.com', 'secureNEC2025', 'Jane', 'Smith', '456 Maple St', 'New Brunswick', 'NJ', '08901', '555-4567');

INSERT INTO Reservation (reservation_number_id, username, transit_line_name, start_stop, end_stop, date_made, is_round_trip, seat_number, class, passenger, fare_type) 
VALUES 
    (301, 'john_paker_nec', 'Northeast Corridor', 'Trenton Transit Center', 'New York Penn Station', '2023-11-16', TRUE, 'A1', 'Business', 'John Paker', 'Child'),
    (302, 'jane_smith_nec', 'Northeast Corridor', 'New Brunswick Station', 'New York Penn Station', '2023-11-16', FALSE, 'B5', 'Economy', 'Jane Smith', 'Disabled');
    
INSERT INTO Train (train_id, num_seats, num_cars) VALUES (202, 100, 8);

INSERT INTO Station (station_id, name, city, state, zip) 
VALUES 
    (201, 'Bay Head Station', 'Bay Head', 'NJ', '08742'), (202, 'Long Branch Station', 'Long Branch', 'NJ', '07740'), (203, 'Asbury Park Station', 'Asbury Park', 'NJ', '07712'),
    (204, 'Newark Penn Station', 'Newark', 'NJ', '07102'), (205, 'Hoboken Terminal', 'Hoboken', 'NJ', '07030');

INSERT INTO Schedule (transit_line_name, isDelayed, train_id, num_seats_available, base_fare, origin, destination, departure_datetime, arrival_datetime) 
VALUES 
	('North Jersey Coast Line', FALSE, 202, 100, 50, 'Bay Head Station', 'Hoboken Terminal', '2023-11-17 07:00:00', '2023-11-17 08:45:00');

INSERT INTO Stop (stop_num, transit_line_name, station_id, arrival_time, departure_time) 
VALUES 
    (1, 'North Jersey Coast Line', 201, NULL, '2023-11-17 07:00:00'), (2, 'North Jersey Coast Line', 202, '2023-11-17 07:25:00', '2023-11-17 07:30:00'), 
    (3, 'North Jersey Coast Line', 203, '2023-11-17 07:45:00', '2023-11-17 07:50:00'),
    (4, 'North Jersey Coast Line', 204, '2023-11-17 08:30:00', '2023-11-17 08:35:00'), (5, 'North Jersey Coast Line', 205, '2023-11-17 08:45:00', NULL);

INSERT INTO Customer (username, email, password, first_name, last_name, street_address, city, state, zip, phone_num1) 
VALUES 
    ('alice_jones_njcl', 'alice.jones.njcl@example.com', 'passNJCL2023', 'Alice', 'Jones', '123 Ocean Ave', 'Hoboken', 'NJ', '08742', '555-1234'),
    ('bob_smith_njcl', 'bob.smith.njcl@example.com', 'secureNJCL2023', 'Bob', 'Smith',  '456 Board St', 'Asbury Park', 'NJ', '07712', '555-5678');

INSERT INTO Reservation (reservation_number_id, username, transit_line_name, start_stop, end_stop, date_made, is_round_trip, seat_number, class, passenger, fare_type) 
VALUES 
    (401, 'alice_jones_njcl', 'North Jersey Coast Line', 'Bay Head Station', 'Hoboken Terminal', '2023-11-16', TRUE, 'C1', 'Business', 'Alice Jones', 'Senior'),
    (402, 'bob_smith_njcl', 'North Jersey Coast Line', 'Asbury Park Station', 'Hoboken Terminal', '2023-11-16', FALSE, 'D3', 'Economy', 'Bob Smith', 'Regular');

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# The total fare for each reservation by considering various factors such as base fare, stop differences, class multipliers, discounts, and whether the reservation is a round trip.
SELECT r.reservation_number_id,
    (
        SUM(
            (s.base_fare * (CASE WHEN r.is_round_trip THEN 2 ELSE 1 END) / total_stops.total_stop_count) * stop_count.stop_difference * (CASE r.class WHEN 'Economy' THEN 1 
            WHEN 'Business' THEN 2 END) * (CASE r.fare_type WHEN 'Child' THEN 0.75 WHEN 'Senior' THEN 0.65 WHEN 'Disabled' THEN 0.50 ELSE 1 END)
        )
    ) AS total_fare FROM  Reservation AS r
JOIN  Schedule AS s ON r.transit_line_name = s.transit_line_name
JOIN (SELECT transit_line_name, COUNT(*) AS total_stop_count FROM Stop GROUP BY transit_line_name) AS total_stops ON  total_stops.transit_line_name = r.transit_line_name
JOIN 
    (SELECT t1.transit_line_name, t1.stop_num AS start_stop_num, t2.stop_num AS end_stop_num, t2.stop_num - t1.stop_num AS stop_difference FROM Stop AS t1 JOIN Stop AS t2 
     ON t1.transit_line_name = t2.transit_line_name WHERE  t1.stop_num < t2.stop_num) AS stop_count ON stop_count.transit_line_name = r.transit_line_name
     
    AND stop_count.end_stop_num = (SELECT stop_num FROM Stop WHERE station_id = (SELECT station_id FROM Station WHERE name = r.end_stop) AND transit_line_name = r.transit_line_name)
AND stop_count.start_stop_num = (SELECT stop_num FROM Stop WHERE station_id = (SELECT station_id FROM Station WHERE name = r.start_stop) AND transit_line_name = r.transit_line_name)
GROUP BY r.reservation_number_id;

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Manager/Admin-Level Functionality
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# Total revenue (sales) for each month by summing the fare of all reservations, considering base fare, number of stops traveled, class multipliers, discounts, and round trip status.
SELECT YEAR(r.date_made) AS year, MONTH(r.date_made) AS month, SUM(total_fare) AS total_sales FROM Reservation AS r JOIN
    (
        SELECT r.reservation_number_id, r.date_made, 
            (
                (s.base_fare * (CASE WHEN r.is_round_trip THEN 2 ELSE 1 END) / total_stops.total_stop_count) * stop_count.stop_difference * (CASE r.class WHEN 'Economy' THEN 1 
				WHEN 'Business' THEN 2 END) * (CASE r.fare_type WHEN 'Child' THEN 0.75 WHEN 'Senior' THEN 0.65 WHEN 'Disabled' THEN 0.50 ELSE 1 END)
            ) AS total_fare FROM Reservation AS r
        JOIN Schedule AS s ON r.transit_line_name = s.transit_line_name
        JOIN (SELECT transit_line_name, COUNT(*) AS total_stop_count FROM Stop GROUP BY transit_line_name) AS total_stops ON total_stops.transit_line_name = r.transit_line_name
        JOIN 
            (SELECT t1.transit_line_name, t1.stop_num AS start_stop_num, t2.stop_num AS end_stop_num, t2.stop_num - t1.stop_num AS stop_difference FROM Stop AS t1 JOIN Stop AS t2 
             ON t1.transit_line_name = t2.transit_line_name WHERE t1.stop_num < t2.stop_num) AS stop_count ON stop_count.transit_line_name = r.transit_line_name
             
		AND stop_count.end_stop_num = (SELECT stop_num FROM Stop WHERE station_id = (SELECT station_id FROM Station WHERE name = r.end_stop) AND transit_line_name = r.transit_line_name)
	AND stop_count.start_stop_num = (SELECT stop_num FROM Stop WHERE station_id = (SELECT station_id FROM Station WHERE name = r.start_stop) AND transit_line_name = r.transit_line_name)
    ) 
    AS monthly_sales
ON monthly_sales.reservation_number_id = r.reservation_number_id GROUP BY YEAR(r.date_made), MONTH(r.date_made) ORDER BY year, month;

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# A detailed list of reservations filtered by either a specific transit line or a specific customer, providing information such as reservation number, stops, and class details.
SELECT r.reservation_number_id, r.username, r.transit_line_name, r.start_stop, r.end_stop, r.date_made, r.class, r.fare_type FROM Reservation AS r WHERE 
    r.transit_line_name = 'Northeast Corridor' OR r.username = 'alice_jones_njcl'; -- Replace with the desired transit line or with desired customer name
    
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# Calculates total revenue generated by a specific customer or transit line name by summing up their reservation fares, accounting for discounts, class, and round trip status.
SELECT SUM(total_fare) AS total_revenue FROM 
(
    SELECT r.reservation_number_id, 
        (
            (s.base_fare * (CASE WHEN r.is_round_trip THEN 2 ELSE 1 END) / total_stops.total_stop_count) * stop_count.stop_difference * (CASE r.class WHEN 'Economy' THEN 1 
			WHEN 'Business' THEN 2 END) * (CASE r.fare_type WHEN 'Child' THEN 0.75 WHEN 'Senior' THEN 0.65 WHEN 'Disabled' THEN 0.50 ELSE 1 END)
        ) AS total_fare
    FROM Reservation AS r
    JOIN Schedule AS s ON r.transit_line_name = s.transit_line_name
    JOIN 
        (SELECT transit_line_name, COUNT(*) AS total_stop_count FROM Stop GROUP BY transit_line_name) AS total_stops ON total_stops.transit_line_name = r.transit_line_name
    JOIN 
        (SELECT t1.transit_line_name, t1.stop_num AS start_stop_num, t2.stop_num AS end_stop_num, t2.stop_num - t1.stop_num AS stop_difference FROM Stop AS t1 JOIN Stop AS t2 
         ON t1.transit_line_name = t2.transit_line_name WHERE t1.stop_num < t2.stop_num) AS stop_count ON stop_count.transit_line_name = r.transit_line_name
         
	AND stop_count.start_stop_num = (SELECT stop_num FROM Stop WHERE station_id = (SELECT station_id FROM Station WHERE name = r.start_stop) AND transit_line_name = r.transit_line_name)
        AND stop_count.end_stop_num = (SELECT stop_num FROM Stop WHERE station_id = (SELECT station_id FROM Station WHERE name = r.end_stop) AND transit_line_name = r.transit_line_name)
    WHERE r.username = 'alice_jones_njcl' or  r.transit_line_name = 'TRANSITLINENAME' -- Replace with specific customer username or with specific transit line name
) AS customer_revenue;
    
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# Customer who generated the most total revenue by calculating fare for each reservation based on stops, class, discounts, and round trip status, aggregating total fare per customer. 
WITH 
StopCounts AS (SELECT t1.transit_line_name, t1.stop_num AS start_stop_num, t2.stop_num AS end_stop_num, t2.stop_num - t1.stop_num AS stop_difference FROM Stop AS t1 JOIN Stop AS t2 ON 
        t1.transit_line_name = t2.transit_line_name WHERE t1.stop_num < t2.stop_num
),
-- Calculate the total fare for each reservation
ReservationFares AS (
    SELECT r.username, r.reservation_number_id, 
        (
            (s.base_fare * (CASE WHEN r.is_round_trip THEN 2 ELSE 1 END) / total_stops.total_stop_count) * stop_count.stop_difference * (CASE r.class WHEN 'Economy' THEN 1 
			WHEN 'Business' THEN 2 END) * (CASE r.fare_type WHEN 'Child' THEN 0.75 WHEN 'Senior' THEN 0.65 WHEN 'Disabled' THEN 0.50 ELSE 1 END)
        ) AS total_fare FROM Reservation AS r
    JOIN Schedule AS s ON r.transit_line_name = s.transit_line_name
    JOIN 
        (SELECT transit_line_name, COUNT(*) AS total_stop_count FROM Stop GROUP BY transit_line_name) AS total_stops ON total_stops.transit_line_name = r.transit_line_name
    JOIN StopCounts AS stop_count ON  stop_count.transit_line_name = r.transit_line_name
	AND stop_count.start_stop_num = (SELECT stop_num FROM Stop WHERE station_id = (SELECT station_id FROM Station WHERE name = r.start_stop) AND transit_line_name = r.transit_line_name)
        AND stop_count.end_stop_num = (SELECT stop_num FROM Stop WHERE station_id = (SELECT station_id FROM Station WHERE name = r.end_stop) AND transit_line_name = r.transit_line_name)
),
-- Calculate the sum of total fare every customer
CustomerRevenues AS (SELECT username, SUM(total_fare) AS total_revenue FROM ReservationFares GROUP BY username)
-- Find customer(s) with the maximum total revenue
SELECT username FROM CustomerRevenues WHERE total_revenue = (SELECT MAX(total_revenue) FROM CustomerRevenues);

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# The top 5 transit lines with the most number of reservations per month by grouping reservations by transit line and date. Limit output to the top 5 active transit lines.
SELECT r.transit_line_name, COUNT(*) AS number_of_reservations, YEAR(r.date_made) AS year, MONTH(r.date_made)  AS month FROM Reservation AS r GROUP BY r.transit_line_name, 
	YEAR(r.date_made), MONTH(r.date_made) ORDER BY number_of_reservations DESC LIMIT 5;

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Representative-Level Functionality
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# A list of unique customers who made reservations on a specified transit line and date. It filters results based on the provided transit line name and the reservation date.
SELECT DISTINCT c.username, c.first_name, c.last_name FROM Customer AS c JOIN Reservation AS r ON c.username = r.username 
	WHERE r.transit_line_name = 'North Jersey Coast Line' AND r.date_made = '2023-11-16'; -- Replace with the desired transit line name and with the desired date accordingly

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# All train schedules where a specified station is either the origin or the destination. It filters the Schedule table using station name for both roles and returns matching results.
SELECT * FROM Schedule WHERE origin = 'New York Penn Station' OR destination = 'New York Penn Station';

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!