const pool = require('../models/database');


exports.postRide = async(req, res, next) => {
    console.log(req.body);
    const {numSeats, priceInCents, startDest, endDest, startTime, dateOfDepart, estimatedTime} = req.body;
    const driver_id = parseInt(req.user.id);
    try{
        const response = await pool.query('INSERT INTO ride (driver_id, num_seats, price_in_cents, start_dest, end_dest, start_time, date_of_depart, estimated_time) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *',
            [driver_id, parseInt(numSeats),priceInCents,startDest,endDest,startTime, dateOfDepart,estimatedTime]
        );

        console.log(response);

    }catch(err){
        next(err);
    }
}