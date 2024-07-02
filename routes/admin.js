const express = require('express');
const router = express.Router();
const {protectAdmin} = require('../middleware/auth')
const { renderHome, renderLogin,getDrivers, updateDriver,deleteDriversRegistration, createDriver} = require('../controlers/admin');


// router.get('/', renderLogin);

router.get('/', renderLogin);
router.get('/home',protectAdmin, renderHome);

router.get('/drivers', protectAdmin, getDrivers);
router.post('/drivers', protectAdmin, createDriver)
router.put('/drivers', protectAdmin, updateDriver);
router.delete('/drivers', protectAdmin, deleteDriversRegistration);



module.exports = router;
