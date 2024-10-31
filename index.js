const { Pool } = require('pg');

// PostgreSQL connection
const pool = new Pool({
  user: 'postgres', //This _should_ be your username, as it's the default one Postgres uses
  host: 'localhost',
  database: 'your_database_name', //This should be changed to reflect your actual database
  password: 'your_database_password', //This should be changed to reflect the password you used when setting up Postgres
  port: 5432,
});

/**
 * Creates the database tables, if they do not already exist.
 */
async function createTable() {
  await pool.query(`
      CREATE TABLE IF NOT EXISTS movies (
          movie_id SERIAL PRIMARY KEY,
          title VARCHAR(100) NOT NULL,
          year INTEGER,
          genre VARCHAR(50),
          director VARCHAR(100)
      );

      CREATE TABLE IF NOT EXISTS customers (
          customer_id SERIAL PRIMARY KEY,
          first_name VARCHAR(50) NOT NULL,
          last_name VARCHAR(50) NOT NULL,
          email VARCHAR(100) UNIQUE NOT NULL,
          phone_number VARCHAR(20)
      );

      CREATE TABLE IF NOT EXISTS rentals (
          rental_id SERIAL PRIMARY KEY,
          customer_id INTEGER REFERENCES customers(customer_id),
          movie_id INTEGER REFERENCES movies(movie_id),
          rental_date DATE,
          due_date DATE
      );
  `);
}

async function insertMovie(title, year, genre, director) {
  await pool.query('INSERT INTO movies (title, year, genre, director) VALUES ($1, $2, $3, $4)', [title, year, genre, director]);
}

async function displayMovies() {
  const result = await pool.query('SELECT * FROM movies');
  console.table(result.rows);
}

async function updateCustomerEmail(customerId, newEmail) {
  await pool.query('UPDATE customers SET email = $1 WHERE customer_id = $2', [newEmail, customerId]);
}

async function removeCustomer(customerId) {
  await pool.query('DELETE FROM rentals WHERE customer_id = $1', [customerId]);
  await pool.query('DELETE FROM customers WHERE customer_id = $1', [customerId]);
}

/**
 * Prints a help message to the console
 */
function printHelp() {
  console.log('Usage:');
  console.log('  insert <title> <year> <genre> <director> - Insert a movie');
  console.log('  show - Show all movies');
  console.log('  update <customer_id> <new_email> - Update a customer\'s email');
  console.log('  remove <customer_id> - Remove a customer from the database');
}

/**
 * Runs our CLI app to manage the movie rentals database
 */
async function runCLI() {
  await createTable();

  const args = process.argv.slice(2);
  switch (args[0]) {
    case 'insert':
      if (args.length !== 5) {
        printHelp();
        return;
      }
      await insertMovie(args[1], parseInt(args[2]), args[3], args[4]);
      break;
    case 'show':
      await displayMovies();
      break;
    case 'update':
      if (args.length !== 3) {
        printHelp();
        return;
      }
      await updateCustomerEmail(parseInt(args[1]), args[2]);
      break;
    case 'remove':
      if (args.length !== 2) {
        printHelp();
        return;
      }
      await removeCustomer(parseInt(args[1]));
      break;
    default:
      printHelp();
      break;
  }
};

runCLI();
