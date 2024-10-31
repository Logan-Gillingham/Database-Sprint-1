CREATE TABLE movies (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    year INTEGER,
    genre VARCHAR(50),
    director VARCHAR(100)
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20)
);

CREATE TABLE rentals (
    rental_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    movie_id INTEGER REFERENCES movies(movie_id),
    rental_date DATE,
    due_date DATE
);

INSERT INTO movies (title, year, genre, director)
VALUES
    ('The Shawshank Redemption', 1994, 'Drama', 'Frank Darabont'),
    ('The Godfather', 1972, 'Crime', 'Francis Ford Coppola'),
    ('The Dark Knight', 2008, 'Action', 'Christopher Nolan'),
    ('Pulp Fiction', 1994, 'Crime', 'Quentin Tarantino'),
    ('Forrest Gump', 1994, 'Drama', 'Robert Zemeckis');

INSERT INTO customers (first_name, last_name, email, phone_number)
VALUES
    ('John', 'Doe', 'johndoe@example.com', '123-456-7890'),
    ('Jane', 'Smith', 'janesmith@example.com', '987-654-3210'),
    ('Michael', 'Johnson', 'michaeljohnson@example.com', '555-555-5555'),
    ('Emily', 'Brown', 'emilybrown@example.com', '111-222-3333'),
    ('David', 'Wilson', 'davidwilson@example.com', '444-555-6666');

INSERT INTO rentals (customer_id, movie_id, rental_date, due_date)
VALUES
    (1, 1, '2023-11-01', '2023-11-08'),
    (2, 2, '2023-11-02', '2023-11-09'),
    (3, 3, '2023-11-03', '2023-11-10'),
    (4, 4, '2023-11-04', '2023-11-11'),
    (5, 5, '2023-11-05', '2023-11-12'),
    (1, 2, '2023-11-06', '2023-11-13'),
    (2, 1, '2023-11-07', '2023-11-14'),
    (3, 4, '2023-11-08', '2023-11-15'),
    (4, 3, '2023-11-09', '2023-11-16'),
    (5, 2, '2023-11-10', '2023-11-17');

SELECT m.title
FROM rentals r
JOIN movies m ON r.movie_id = m.movie_id
JOIN customers c ON r.customer_id = c.customer_id
WHERE c.email = 'johndoe@example.com';

SELECT c.first_name, c.last_name
FROM rentals r
JOIN movies m ON r.movie_id = m.movie_id
JOIN customers c ON r.customer_id = c.customer_id
WHERE m.title = 'The Shawshank Redemption';

SELECT c.first_name, c.last_name, r.rental_date, r.due_date
FROM rentals r
JOIN movies m ON r.movie_id = m.movie_id
JOIN customers c ON r.customer_id = c.customer_id
WHERE m.title = 'The Dark Knight';

SELECT c.first_name, c.last_name, r.rental_date, m.title
FROM rentals r
JOIN movies m ON r.movie_id = m.movie_id
JOIN customers c ON r.customer_id = c.customer_id
WHERE m.director = 'Christopher Nolan';

SELECT m.title
FROM rentals r
JOIN movies m ON r.movie_id = m.movie_id
WHERE r.due_date > CURRENT_DATE;