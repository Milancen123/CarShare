const bcrypt = require('bcrypt');


exports.passwordHash = async (password, saltRounds) => {
    try{
        const salt = await bcrypt.genSalt(saltRounds);
        return await bcrypt.hash(password, salt);
    }catch(err){
        console.log(err);
    }
}


exports.comparePassword = async(password, hash) => {
    try{
        const matchFound = await bcrypt.compare(password, hash);
        return matchFound;
    }catch(err){
        return false;
    }
}