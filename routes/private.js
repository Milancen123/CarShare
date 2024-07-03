const express = require('express');
const {getPrivateData, getRides, getRideById, reserveRide, checkReservation, getPassengersByRideId, cancelRide, getRidesByPassengerID, getUserData, updateUserData} = require('../controlers/private');
const {protect} = require('../middleware/auth')


const router = express.Router();

router.route('/').get(protect, getPrivateData);

router.post('/searchRides', protect, getRides);

router.get('/searchRides/:id', protect, getRideById);

router.post('/reserveRide/:ride_id', protect, reserveRide);

router.get('/checkReservation/:ride_id', protect, checkReservation);

router.get('/getPassengers/:ride_id', protect, getPassengersByRideId);

router.post('/cancelRide/:ride_id', protect, cancelRide);

router.get('/getRidesByPassengerID', protect, getRidesByPassengerID);

//da dobijes podatke o korisniku
router.get('/user', protect, getUserData);

router.put('/user', protect, updateUserData);

module.exports = router;