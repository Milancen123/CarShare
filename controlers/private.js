const pool = require("../models/database");
const ErrorResponse = require("../utils/errorResponse");
const { passwordHash } = require("../utils/hashPassword");

exports.getPrivateData = (req, res, next) => {
    res.status(200).json({
        success:true,
        "data": "you got access to the private data in this route" 
    });
}

exports.getRides = async (req, res, next) => {
    const {start_dest, end_dest, num_seats, date} = req.body;
    console.log(req.body);
    try{
        const response = await pool.query("SELECT ride.id, ride.start_dest, ride.end_dest,ride.price_in_cents, ride.num_seats, ride.start_time, ride.estimated_time, ride.date_of_depart, driver.first_name, driver.acc_picture FROM ride INNER JOIN driver ON ride.driver_id = driver.id WHERE ride.start_dest = $1 AND ride.end_dest = $2 AND ride.num_seats >= $3 AND ride.date_of_depart = $4;",
            [start_dest, end_dest, parseInt(num_seats), date]);
        const data = (response.rows);

        res.json({
            success: true,
            "data": data,
        });

    }catch(err){
        next(new ErrorResponse("somehting broke", 404));
    }
}


exports.getRideById = async(req, res, next) => {
    const id = req.params.id;
    try{
        const results = await pool.query("SELECT ride.id, ride.start_dest, ride.end_dest,ride.price_in_cents, ride.num_seats, ride.start_time, ride.estimated_time, ride.date_of_depart, driver.first_name, driver.acc_picture FROM ride INNER JOIN driver ON ride.driver_id = driver.id WHERE ride.id = $1", [id]);
        const ride = results.rows[0];
        console.log(ride);
        res.status(200).json({
            success: true,
            data: ride
        });
        
    }catch(err){
        next(new ErrorResponse(err.message, 404));
    }

}


exports.reserveRide = async (req, res, next) => {
    try{
        const userID = req.user.id;
        const rideID = req.params.ride_id;
        const response = await pool.query("INSERT INTO reservations (ride_id, passenger_id) VALUES ($1, $2) RETURNING *",
            [rideID, userID]
        );

        res.status(200).json({
            success: true
        });

    }catch(err){
        next(new ErrorResponse(err.message, 500));
    }
}

exports.checkReservation = async (req, res, next) => {
    const userID = parseInt(req.user.id);
    const rideID = parseInt(req.params.ride_id);
    console.log(`USERID: ${userID} RIDEID ${rideID}`);
    try{
        const response = await pool.query("SELECT * FROM reservations WHERE ride_id = $1 AND passenger_id = $2",
            [rideID, userID]
        );
        console.log("/n/n/n-----------------------");
        console.log("OVO JE REZERVACIJA PODACI:");
        console.log(response);
        console.log("-----------------------/n/n/n");
        if(response.rows.length != 0){
            res.status(200).json({
                success: true,
                reserved: true
            });
        }else {
            res.status(200).json({
                success: true,
                reserved: false
            })
        }
    }catch(err){
        next(new ErrorResponse(err.message, 500));
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


exports.cancelRide = async(req, res, next) => {
    const rideID = parseInt(req.params.ride_id);
    const userID = parseInt(req.user.id);
    console.log(`RIDEID ${rideID}`);
    try{
        const response = await pool.query("DELETE FROM reservations WHERE reservations.passenger_id = $1 AND reservations.ride_id = $2 RETURNING reservations.passenger_id",
            [userID, rideID]
        );
        console.log("OVO JE ODGORVOR bazepodataka");
        console.log(response);
        res.status(200).json({
            success: true,
            data: response.rows[0]
        });
        
    }catch(err){
        next(new ErrorResponse(err.message, 500));
    }
}


exports.getRidesByPassengerID = async(req, res, next) => {
    const userID = parseInt(req.user.id);
    try{
        const response = await pool.query("SELECT ride.id,ride.date_of_depart, ride.start_dest, ride.end_dest, ride.start_time, ride.estimated_time, driver.first_name FROM reservations  INNER JOIN ride ON reservations.ride_id = ride.id INNER JOIN driver ON driver.id = ride.driver_id WHERE reservations.passenger_id = $1 ORDER BY ride.date_of_depart DESC",
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


exports.getUserData = async(req,res,next) => {
    try{
        console.log("UZEO SAM PODATKE O USERU");
        const response = await pool.query("SELECT first_name, last_name, email FROM passenger WHERE id = $1", [parseInt(req.user.id)]);
        res.status(200).json({
            success: true,
            data: response.rows[0]
        });

    }catch(err){
        next(err);
    }
}


exports.updateUserData = async (req,res,next) => {
    console.log("A SAD OVDE");
    console.log(req.body);
    const {first_name, last_name, password} = req.body;
    try{
        //hash password
        const hash = passwordHash(password, 10);
        const response = await pool.query('UPDATE passenger SET first_name = $1, last_name = $2, password = $3 WHERE id = $4 RETURNING *', 
            [first_name, last_name, hash, parseInt(req.user.id)]
        );
        if(!!response.rows[0]){
            res.status(200).json({
                success: true
            });
        }
    }catch(err){
        next(err);
    }
}