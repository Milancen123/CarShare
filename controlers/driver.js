const pool = require('../models/database');


exports.postRide = async(req, res, next) => {
    console.log(req.body);
    const {numSeats, priceInCents, startDest, endDest, startTime, dateOfDepart, estimatedTime} = req.body;
    const driver_id = parseInt(req.user.id);
    try{
        const response = await pool.query('INSERT INTO ride (driver_id, num_seats, price_in_cents, start_dest, end_dest, start_time, date_of_depart, estimated_time) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *',
            [driver_id, parseInt(numSeats),priceInCents,startDest,endDest,startTime, dateOfDepart,estimatedTime]
        );

        res.status(201).json({
            success: true
        });

    }catch(err){
        next(err);
    }
}

exports.getRidesByDriverID = async(req, res, next) => {
    const userID = parseInt(req.user.id);
    try{
        const response = await pool.query("SELECT ride.id,ride.date_of_depart, ride.start_dest, ride.end_dest, ride.start_time, ride.estimated_time, driver.first_name FROM ride INNER JOIN driver ON ride.driver_id = driver.id WHERE driver.id = $1 ORDER BY ride.date_of_depart DESC",
            [userID]
        );
        console.log("OVO JE ODGORVOR bazepodataka");
        console.log(response);
        res.status(200).json({
            success: true,
            data: response.rows
        });
        
    }catch(err){
        next(new ErrorResponse(err.message, 500));
    }

}


exports.getRideById = async(req, res, next) => {
    const id = parseInt(req.params.ride_id);
    console.log(id);
    try{
        const results = await pool.query("SELECT ride.id, ride.start_dest, ride.end_dest,ride.price_in_cents, ride.num_seats, ride.start_time, ride.estimated_time, ride.date_of_depart, driver.first_name, driver.acc_picture FROM ride INNER JOIN driver ON driver.id = ride.driver_id WHERE ride.id = $1", [id]);
        const ride = results.rows[0];
        console.log("-----------------------------------------------------");
        console.log("------------PODACI ZA VOZNJU-------------------------");
        console.log(ride);
        res.status(200).json({
            success: true,
            data: ride
        });  
    }catch(err){
        next(new ErrorResponse(err.message, 404));
    }
}


exports.getPassengersByRideId = async(req,res, next) => {
    const rideID = parseInt(req.params.ride_id);
    console.log(`RIDEID ${rideID}`);
    try{
        const response = await pool.query("SELECT passenger.id, passenger.first_name, passenger.acc_picture FROM passenger INNER JOIN reservations ON reservations.passenger_id = passenger.id WHERE reservations.ride_id = $1",
            [rideID]
        );

        if(response.rows.length != 0){
            console.log(response.rows);
            res.status(200).json({
                success: true,
                data: response.rows,
            });
        }else {
            res.status(200).json({
                success: true,
                data: []
            })
        }
    }catch(err){
        next(new ErrorResponse(err.message, 500));
    }
}


exports.checkRide = async (req,res,next) => {
    const rideID = parseInt(req.params.ride_id);
    try{
        const results = await pool.query("SELECT * FROM ride WHERE ride.id = $1", [rideID]);
        if(!!results.rows[0]){
            res.status(200).json({
                success: true
            });
        }else{
            res.status(200).json({
                success: false
            });
        }
    }catch(err){
        next(err);
    }
}


exports.deleteRide = async (req,res,next) => {
    const ride_id = parseInt(req.params.ride_id);
    try{
        const response = await pool.query("DELETE FROM ride WHERE ride.id = $1", [ride_id]);
        res.json({
            success:true
        });
    }catch(err){
        next(err);
    }
}


exports.updateRide = async (req,res,next) => {
    const ride_id = parseInt(req.params.ride_id);
    const [date_start, time_start, time_end, start_dest, end_dest, price] = req.body;

    console.log(req.body);
    

    try{
        
    }catch(err){
        next(err);

    }
}