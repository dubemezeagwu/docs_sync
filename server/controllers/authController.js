const User = require("./../models/userModel");
const catchAsync = require("./../utils/catchAsync");
const jwt = require("jsonwebtoken");
const AppError = require("./../utils/appError");

exports.signup = catchAsync(async (req, res, next) => {
  const { name, email, profilePicture} = req.body;

  // let newUser = await User.findOne({email: email});

  // if (!newUser){
  //   newUser = new User({
  //     name: name,
  //     email: email,
  //     profilePicture: profilePicture,
  //   })
  // }

  const newUser = await User.create({
    name: name,
    email: email,
    profilePicture: profilePicture,
  });

  res.status(201).json({
    status: "success",
    data: {
      user: newUser,
    },
  });
})