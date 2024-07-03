const express = require('express');
const { protectDriver } = require('../middleware/auth');
const { postRide, getRidesByDriverID, getRideById, getPassengersByRideId, checkRide, deleteRide, updateRide } = require('../controlers/driver');
const router = express.Router();

router.post('/ride', protectDriver, postRide);
router.get('/getRidesByDriverID', protectDriver, getRidesByDriverID);


router.get('/searchRides/:ride_id', protectDriver, getRideById);
router.get('/getPassengers/:ride_id', protectDriver, getPassengersByRideId);
router.get('/checkRide/:ride_id', protectDriver, checkRide);
router.delete('/deleteRide/:ride_id', protectDriver, deleteRide);
router.put('/updateRide/:ride_id', protectDriver, updateRide);


module.exports = router;
