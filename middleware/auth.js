const jwt = require('jsonwebtoken');
const errorResponse = require("../utils/errorResponse");
const ErrorResponse = require('../utils/errorResponse');
const pool = require("../models/database");
const pool2 = require("../models/databaseAdmin");


// ensure authentication method

exports.protect = async (req ,res, next) => {
    let token;
    console.log(req.query);
    if((req.headers.authorization && req.headers.authorization.startsWith("Bearer"))) {
        token = req.headers.authorization.split(" ")[1];
    }else if(!!req.query.token){
        token = req.query.token;
        console.log(token);
    }
    console.log(token);
    if(!token) {
        return next(new ErrorResponse("Not authorized", 401) );
    }

    try{
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const results = await pool.query("SELECT * FROM passenger WHERE id = $1", [parseInt(decoded.id)]);
        const user = results.rows[0];
        console.log(results.rows);
        console.log("SAD SAM OVDE USO");
        if(!user){
            return next(new ErrorResponse("No user found with this id", 404));
        }

        req.user = user;
        next();

    }catch(error){
        return next(new ErrorResponse("Not authorized to access this route", 401));
    }
}


exports.protectAdmin = async (req ,res, next) => {
    let token;
    console.log(req.query);
    if((req.headers.authorization && req.headers.authorization.startsWith("Bearer"))) {
        token = req.headers.authorization.split(" ")[1];
    }else if(!!req.query.token){
        token = req.query.token;
        console.log(token);
    }
    console.log(token);
    if(!token) {
        return res.redirect('/api/admin/');
        // return next(new ErrorResponse("Not authorized", 401) );
    }

    try{
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const results = await pool2.query("SELECT * FROM users WHERE id = $1", [parseInt(decoded.id)]);
        const user = results.rows[0];
        console.log(results.rows);
        console.log("SAD SAM OVDE USO");
        if(!user){
            return next(new ErrorResponse("No user found with this id", 404));
        }

        req.user = user;
        next();

    }catch(error){
        return next(new ErrorResponse("Not authorized to access this route", 401));
    }
}


exports.protectDriver = async (req ,res, next) => {
    let token;
    console.log(req.query);
    if((req.headers.authorization && req.headers.authorization.startsWith("Bearer"))) {
        token = req.headers.authorization.split(" ")[1];
    }else if(!!req.query.token){
        token = req.query.token;
        console.log(token);
    }
    console.log(token);
    if(!token) {
        return res.redirect('/api/driver/');
        // return next(new ErrorResponse("Not authorized", 401) );
    }

    try{
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const results = await pool.query("SELECT * FROM driver WHERE id = $1", [parseInt(decoded.id)]);
        const user = results.rows[0];
        console.log(results.rows);
        console.log("SAD SAM OVDE USO");
        if(!user){
            return next(new ErrorResponse("No user found with this id", 404));
        }

        req.user = user;
        next();

    }catch(error){
        return next(new ErrorResponse("Not authorized to access this route", 401));
    }
}