const pool = require('../models/database');
const pool2 = require('../models/databaseAdmin');
const ErrorResponse = require('../utils/errorResponse');
const jwt = require('jsonwebtoken');

const { passwordHash, comparePassword } = require('../utils/hashPassword');




exports.registerDriver = async (req,res, next) => {
  console.log("OVDE SAM SAD");
  const {first_name,last_name,email,password,car_model,car_image,bank_acc,plate_number} = req.body;
  try{
    const response = await pool.query('INSERT INTO registrations (first_name, last_name, car_model, bank_acc, plate_number, email, password) VALUES ($1, $2, $3, $4, $5, $6, $7)',
      [first_name,last_name,car_model, bank_acc,plate_number,email,password]
    );
    res.status(200).json({
      success:true,
    });
  }catch(err){
    console.log(err);
  }
}


// Ensure you have these functions defined in your controllers file
exports.register = async (req, res, next) => {
  const { first_name, last_name, email, password } = req.body
  try {
    const saltRounds = 10;
    const hash = await passwordHash(password, saltRounds);
    const response = await pool.query('INSERT INTO passenger (first_name, last_name, email, password) VALUES ($1, $2, $3, $4) RETURNING *', [first_name, last_name, email, hash]);
    const user = response.rows[0];
    res.status(200).json({
      success:true,
    });

  } catch (err) {
    next(err);
  }
  // registration logic here

}


  exports.login = async(req, res, next) => {
    const {email, password, tab} = req.body;
    if(!email || !password) {
      return next(new ErrorResponse("Please provide email or password", 400))
    }


    try{
      const results = await pool.query(`SELECT * FROM ${tab} WHERE email = $1`, [email]);
      const user = results.rows[0];
      if(user.email == email) {
        const match = await comparePassword(password, user.password);
        console.log(email, password, user.password);
        if(!match) {
          return next(new ErrorResponse("Invalid credentials", 401))
        }else{
          sendToken(user, 200, res);
        }
      }

    }catch(err){
      next(err)
    }
  };


  exports.loginAdmin = async(req, res, next) => {
    const {email, password} = req.body;
    console.log("OVO JE U BODY ZA loginADMIN:");
    console.log(req.body);
    if(!email || !password) {
      return next(new ErrorResponse("Please provide email or password", 400))
    }


    try{
      const results = await pool2.query('SELECT * FROM users WHERE email = $1', [email]);
      const user = results.rows[0];
      if(user.email == email) {
        const match = await comparePassword(password, user.password);
        console.log(email, password, user.password);
        if(!match) {
          return next(new ErrorResponse("Invalid credentials", 401))
        }else{
          sendToken(user, 200, res);
        }
      }

    }catch(err){
      next(err)
    }
  }; 



  exports.forgotpassword = async (req, res) => {
    // // forgot password logic here
    // const {email} = req.body;

    // try{
    //   const results = await pool.query('SELECT * FROM passenger WHERE email=$1', [email]);
    //   const user = results.rows[0];
    //   if(!user) {
    //     return new ErrorResponse("Email couldnt be sent", 404);
    //   }

    //   const resetToken = 
    // }catch(err){

    // }
    res.send('Forgot Password endpoint');
  };




  exports.resetpassword = (req, res) => {
    // reset password logic here
    res.send('Reset Password endpoint');
  };



  const getSignedToken = (user) => {
    return jwt.sign({id: user.id}, process.env.JWT_SECRET, {expiresIn: process.env.JWT_EXPIRE});
  }

  const sendToken = (user, statusCode, res) => {
    const token = getSignedToken(user);
    res.status(statusCode).json({success:true, token});

  }

  const setToken = (user, statusCode, res) => {
    const token = getSignedToken(user);
    localStorage.setItem('authToken', token);

  }