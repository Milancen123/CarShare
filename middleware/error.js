const ErrorResponse = require('../utils/errorResponse');

const errorHandler = (err, req, res, next) => {
    let error = { ...err};
    error.message = err.message;

    error =  new Error("Something happened");
    console.log(err);
}

module.exports = errorHandler;