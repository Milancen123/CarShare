const express = require('express');
const router = express.Router();

const { register, login, forgotpassword, resetpassword } = require('../controlers/auth');

router.post('/register', register);
router.post('/login', login);
router.post('/forgotpassword', forgotpassword);
router.post('/resetpassword/:resettoken', resetpassword);


module.exports = router;
