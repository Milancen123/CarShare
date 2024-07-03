const pool2 = require("../models/databaseAdmin");
const pool = require("../models/database");
const {passwordHash} = require('../utils/hashPassword');



exports.renderHome = (req,res, next) => {
    console.log("DALI SAM USAO OVDE");
    res.render('home');
}

exports.renderLogin = (req, res, next) => {
    console.log("SAD SAM OVDE");
    res.render('login-admin');
}


exports.getDrivers = async (req, res, next) => {
    console.log("SAD SAM U GET DRIVERS f-ji")
    try {
        let results = await pool.query('SELECT * FROM registrations WHERE admited = false');
        res.status(200).json(results.rows);
    } catch (err) {
        next(err);
    }
}


exports.updateDriver = async (req, res, next) => {
    const email = req.body.email;
    try {
        await pool.query("UPDATE registrations SET admited = true WHERE email = $1", [email]);
        res.status(200).json("OK");
    } catch (err) {
        next(err);
    }
}


exports.deleteDriversRegistration = async (req, res, next) => {
    const email = req.body.email;
    console.log(email);

    try {
        await pool.query("DELETE FROM registrations WHERE email = $1", [email]);
        res.status(200).json("OK");
    } catch (err) {
        next(err);
    }
}


exports.createDriver = async (req, res, next) => {
    console.log("DO OVDE SAM SAD DOSAO");
    const first_name = req.body.first_name;
    const last_name = req.body.last_name;
    const car_model = req.body.car_model;
    const car_image = req.body.car_image;
    const bank_acc = req.body.bank_acc;
    const plate_number = req.body.plate_number;
    const email = req.body.email;
    const password = req.body.password;

    try {

        const hash = await passwordHash(password, 10);
        await pool.query('INSERT INTO driver (first_name, last_name, car_model, car_image, bank_acc, plate_number, email, password) VALUES ($1,$2,$3,$4,$5,$6,$7,$8)', [first_name, last_name, car_model, car_image, bank_acc, plate_number, email, hash]);
        res.status(201).json("OK");
    } catch (err) {
        next(err);
    }
}