const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
    lowerCase: true,
  },
  profilePicture: {
    type: String,
    required: true,
    trim: true
  }
})

const User = mongoose.model("User", userSchema);
module.exports = User;