const express = require('express');
const { protectDriver } = require('../middleware/auth');
const { postRide } = require('../controlers/driver');
const router = express.Router();

router.post('/ride', protectDriver, postRide);

module.exports = router;
