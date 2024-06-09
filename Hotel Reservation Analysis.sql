drop table Hotel_Reservation;
create table Hotel_Reservation(
Booking_ID nvarchar(15),
no_of_adults int,
no_of_children int,
no_of_weekend_nights int,
no_of_week_nights int,
type_of_meal_plan nvarchar(20),
room_type_reserved nvarchar(20),
lead_time int,
arrival_date date,
market_segment_type nvarchar(15),	
avg_price_per_room float,
booking_status nvarchar(20)
);

load data infile "D:\\Mentorness Project\\Hotel Reservation Dataset.csv"
into table Hotel_Reservation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Booking_ID, no_of_adults, no_of_children, no_of_weekend_nights, 	
no_of_week_nights, type_of_meal_plan, room_type_reserved, 
lead_time, @arrival_date, market_segment_type, avg_price_per_room,
booking_status)
SET arrival_date = STR_TO_DATE(@arrival_date, '%d-%m-%Y');

select*from Hotel_Reservation;

/*Q1. What is the total number of reservations in the dataset?*/
SELECT booking_status, COUNT(*) AS Total_Reserve
FROM Hotel_Reservation
GROUP BY booking_status;
/*SO ANS is 493 is the total Number of Reservation
Canceled 207
Not_Canceled 493*/

/*Q2. Which meal plan is the most popular among guests?*/
select type_of_meal_plan, count(*) as MostPopular
from hotel_reservation
group by type_of_meal_plan;
/*ANS is Meal Plan 1 is the most popular among guests
Meal Plan 1	= 527
Not Selected = 109
Meal Plan 2	= 64*/

/*Q3. What is the average price per room for reservations involving children?*/
SELECT AVG(avg_price_per_room) AS AvgPricePerRoomWithChildren
FROM Hotel_Reservation
WHERE no_of_children > 0;
/*Ans is 144.57 */

/*Q4. How many reservations were made for the year 20XX (replace XX with the desired year)?*/
SELECT COUNT(*) AS Total_Reservations
FROM Hotel_Reservation
WHERE YEAR(arrival_date) = 2018;
/*For 2017 it is 123 and for 2018 is 577*/

/*Q5. What is the most commonly booked room type?*/
select room_type_reserved, count(*) as Most_commonly_booked_room
from hotel_reservation
group by room_type_reserved;
/*Ans is Room_Type 1 is most commonly booked room after that Room_Type 4 is Most commonly booked room.
Room_Type 1 - 534
Room_Type 4 - 130
Room_Type 6 - 18
Room_Type 2 - 8
Room_Type 7 - 6
Room_Type 5 - 4
*/

/*Q6. How many reservations fall on a weekend (no_of_weekend_nights > 0)?*/
SELECT booking_status, COUNT(*) AS Weekend_Reservations
FROM Hotel_Reservation
WHERE no_of_weekend_nights > 0
group by booking_status;
/*Ans is 383 and out of which
Canceled - 121
Not_Canceled - 262*/


/*Q7. What is the highest and lowest lead time for reservations?*/
SELECT MAX(lead_time) AS Highest_Lead_Time
FROM Hotel_Reservation;
-- Max or highest lead time is 443
SELECT MIN(lead_time) AS Highest_Lead_Time
FROM Hotel_Reservation;
-- Min or Lowest lead time is 0


/*Q8. What is the most common market segment type for reservations?*/
select market_segment_type, count(*) as Most_Common_Mark_seg_type
from hotel_reservation
group by market_segment_type
order by Most_Common_Mark_seg_type desc
limit 1;
-- so ans is Online is the most common market segment type with 518 and offline is second most with 140 


/* Q9. How many reservations have a booking status of "Confirmed"?*/
SELECT booking_status, COUNT(*) AS Total_Reserve
FROM Hotel_Reservation
GROUP BY booking_status;
-- 493 booking status is confirmed or not canceled


/*Q10. What is the total number of adults and children across all reservations?*/
select sum(no_of_adults) as Ttl_noOf_Adu, sum(no_of_children) as ttl_child
from hotel_reservation;
-- 1316 are total adults and 69 are total child


/*Q11. What is the average number of weekend nights for reservations involving children?*/
SELECT AVG(no_of_weekend_nights) AS Avg_Weekend_Nights_With_Children
FROM Hotel_Reservation
WHERE no_of_children > 0;
-- The average number of weekend nights for reservations involving children is 1


/*Q12. How many reservations were made in each month of the year?*/
SELECT EXTRACT(MONTH FROM arrival_date) AS Month, COUNT(*) AS Reservations_Count
FROM Hotel_Reservation
GROUP BY EXTRACT(MONTH FROM arrival_date);
-- In Oct there is higest reservation count 103 and in jan there is lowest 11


/*Q13. What is the average number of nights (both weekend and weekday) spent by guests for each room
type?*/
SELECT room_type_reserved, AVG(no_of_weekend_nights + no_of_week_nights) AS Avg_Nights
FROM Hotel_Reservation
GROUP BY room_type_reserved;
/*Room_Type 4 - 3.8000
Room_Type 6 - 3.6111
Room_Type 2 - 3.0000
Room_Type 1 - 2.8783
Room_Type 7 - 2.6667
Room_Type 5 - 2.5000*/


/*Q14. For reservations involving children, what is the most common room type, and what is the average
price for that room type?*/
WITH Children_Reservations AS (
SELECT *
FROM Hotel_Reservation
WHERE no_of_children > 0
)
SELECT room_type_reserved, AVG(avg_price_per_room) AS Avg_Price
FROM Children_Reservations
GROUP BY room_type_reserved
ORDER BY COUNT(*) DESC
LIMIT 1;
-- For reservations involving children, the most common room type is Room_Type 1, and the average price for that room type is 123.123


/*Q15. Find the market segment type that generates the highest average price per room.*/
select market_segment_type, max(avg_price_per_room)
from hotel_reservation
group by market_segment_type;
-- Online market segment type generates the highest avg price per room with 258.
