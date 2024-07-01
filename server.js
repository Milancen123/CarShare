require('dotenv').config();

const express = require('express');
const app = express();

const pg = require('pg');
const errorHandler = require('./middleware/error');
const cors = require('cors');
const morgan = require('morgan');


app.use(express.json());
app.use(cors());
app.use(morgan('dev'));
app.use('/api/auth', require('./routes/auth'));
app.use('/api/private', require('./routes/private'));





const PORT = process.env.PORT || 8000;




app.use(errorHandler);

const server = app.listen(PORT, () => console.log("server is runinig on PORT: " + PORT));


process.on("unhandledRejection", (err, promise) => {
    console.log(`Logged Error: ${err}`);
    server.close(()=> process.exit(1));
})