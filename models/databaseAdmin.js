const pg = require('pg');


const pool2 = new pg.Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_DATABASE_LOGGING,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT
});

module.exports = pool2;
