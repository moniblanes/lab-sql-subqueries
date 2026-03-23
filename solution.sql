USE sakila;

-- =========================
-- CHALLENGE
-- =========================

-- 1. Number of copies of "Hunchback Impossible" in inventory
SELECT 
    COUNT(*) AS copies
FROM inventory
WHERE film_id = (
    SELECT film_id
    FROM film
    WHERE title = 'Hunchback Impossible'
);

-- 2. Films longer than the average length
SELECT 
    title,
    length
FROM film
WHERE length > (
    SELECT AVG(length)
    FROM film
);

-- 3. Actors in the film "Alone Trip"
SELECT 
    first_name,
    last_name
FROM actor
WHERE actor_id IN (
    SELECT actor_id
    FROM film_actor
    WHERE film_id = (
        SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'
    )
);


-- =========================
-- BONUS
-- =========================

-- 4. Movies categorized as Family
SELECT 
    title
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM film_category
    WHERE category_id = (
        SELECT category_id
        FROM category
        WHERE name = 'Family'
    )
);

-- 5. Customers from Canada (SUBQUERY)
SELECT 
    first_name,
    last_name,
    email
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE city_id IN (
        SELECT city_id
        FROM city
        WHERE country_id = (
            SELECT country_id
            FROM country
            WHERE country = 'Canada'
        )
    )
);

-- 5. Customers from Canada (JOIN)
SELECT 
    customer.first_name,
    customer.last_name,
    customer.email
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE country.country = 'Canada';


-- 6. Films of the most prolific actor
SELECT 
    title
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM film_actor
    WHERE actor_id = (
        SELECT actor_id
        FROM film_actor
        GROUP BY actor_id
        ORDER BY COUNT(film_id) DESC
        LIMIT 1
    )
);

-- 7. Films rented by the most profitable customer
SELECT DISTINCT
    film.title
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.customer_id = (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1
);

-- 8. Customers who spent more than average
SELECT 
    customer_id,
    SUM(amount) AS total_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (
    SELECT AVG(total_per_customer)
    FROM (
        SELECT SUM(amount) AS total_per_customer
        FROM payment
        GROUP BY customer_id
    ) AS subquery
);
