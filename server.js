require('dotenv').config();

const express = require('express');
const app = express();

const pg = require('pg');
const errorHandler = require('./middleware/error');
const cors = require('cors');
const morgan = require('morgan');

app.set("view engine", "ejs");
app.use(express.static(__dirname + "/public"));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());
app.use(morgan('dev'));

app.use((req, res, next) => {
    res.set('Cache-Control', 'no-store, no-cache, must-revalidate, private');
    next();
});


app.use('/api/auth', require('./routes/auth'));
app.use('/api/private', require('./routes/private'));
app.use('/api/admin', require('./routes/admin'));
app.use('/api/driver', require('./routes/driver'));





const PORT = process.env.PORT || 8000;




app.use(errorHandler);

const server = app.listen(PORT, () => console.log("server is runinig on PORT: " + PORT));


process.on("unhandledRejection", (err, promise) => {
    console.log(`Logged Error: ${err}`);
    server.close(()=> process.exit(1));
})