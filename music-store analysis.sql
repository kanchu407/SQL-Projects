create database music_store;
use music_store;

-- Who is the senior most employee based on job title? */
select title,first_name, last_name 
from employee
order by levels
DESC limit 1;

-- Which countries have the most Invoices?
select 
	count(*) as most_invoices, billing_country
from invoice
group by billing_country
order by most_invoices DESC;

-- What are top 3 values of total invoice?
select 
	total,
	ROUND(sum(total),2) as total_billing 
from invoice
group by total
order by total_billing DESC limit 3;

-- Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
-- Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals.

select 
	billing_city, 
    ROUND(sum(total),2) as total_billing
from invoice
group by billing_city
order by total_billing DESC limit 1;

-- Who is the best customer? 
-- The customer who has spent the most money will be declared the best customer. 
-- Write a query that returns the person who has spent the most money.
select
	customer.customer_id,
	ROUND(sum(total),2) as total_spent,
    first_name,
    last_name
from customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id, first_name, last_name
order by total_spent DESC limit 1;

-- Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
-- Return your list ordered alphabetically by email starting with A.
select 
	email, 
    first_name, 
    last_name, 
    genre.name as genre
from customer 
join invoice using (customer_id)
join invoice_line using(invoice_id)
join track using (track_id)
join genre using (genre_id)
where genre.name like 'Rock'
order by email;

-- Let's invite the artists who have written the most rock music in our dataset. 
-- Write a query that returns the Artist name and total track count of the top 10 rock bands
select
	artist.name as artist_name,
    count(track_id) tracks_count
from track
join album on track.album_id = album.album_id
join artist on album.artist_id = artist.artist_id
group by artist_name
order by tracks_count DESC limit 10;

-- Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. 
-- Order by the song length with the longest songs listed first.
select
	track.name as TrackName,
    milliseconds 
from track
where milliseconds > (select avg(milliseconds) from track)
order by milliseconds DESC;

-- Find how much amount spent by each customer on artists? 
-- Write a query to return customer name, artist name and total spent.
select
	first_name,last_name,artist.name, round(sum(invoice_line.unit_price*invoice_line.quantity),0) as total_spent
from customer
join invoice using (customer_id)
join invoice_line using (invoice_id)
join track using (track_id)
join album using (album_id)
join artist using (artist_id)
group by first_name, last_name, artist.name
order by total_spent DESC;

-- We want to find out the most popular music Genre for each country. 
-- We determine the most popular genre as the genre with the highest amount of purchases. 
-- Write a query that returns each country along with the top Genre. 
-- For countries where the maximum number of purchases is shared return all Genres.

select 
	genre.name as genre,
    customer.country as country,
    -- sum(invoice.total) as total_purchase,
    count(invoice_line.quantity) as invoice_counts    
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY country,genre
	ORDER BY genre DESC, invoice_counts DESC;
    

-- Write a query that determines the customer that has spent the most on music for each country. 
-- Write a query that returns the country along with the top customer and how much they spent. 

select 
	customer.customer_id,
    customer.first_name, 
    customer.last_name,
    customer.country, 
    round(sum(invoice.total),2) as total_spent
from customer
join invoice using (customer_id)
join invoice_line using (invoice_id)
group by 1,2,3,4
order by total_spent DESC ;











