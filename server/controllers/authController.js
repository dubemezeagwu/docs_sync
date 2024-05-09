const User = require("./../models/userModel");
const catchAsync = require("./../utils/catchAsync");
const { promisify } = require("util");
const jwt = require("jsonwebtoken");
const AppError = require("./../utils/appError");

const authToken = (id) => {
  return jwt.sign({ id: id }, process.env.JWT_SECRET_KEY, {
    expiresIn: process.env.JWT_EXPIRES_IN,
  });
};

const createAndSendToken = (user, statusCode, res) => {
  const token = authToken(user._id);
  const cookieOptions = {
    expires: new Date(
      Date.now() + process.env.JWT_COOKIE_EXPIRES_IN * 24 * 60 * 60 * 1000,
    ),
    httpOnly: true,
  };

  if (process.env.NODE_ENV == "production") cookieOptions.secure = true;
  res.cookie("jwt", token, cookieOptions);

  res.status(statusCode).json({
    status: "success",
    token: token,
    data: {
      user: user,
    },
  });
};

exports.signup = catchAsync(async (req, res, next) => {
  const { name, email, profilePicture } = req.body;

  let user = await User.findOne({ email: email }).select("-__v");

  if (user) {
    createAndSendToken(user, 200, res);
  } else {
    user = await User.create({
      name: name,
      email: email,
      profilePicture: profilePicture,
    });
    createAndSendToken(user, 201, res);
  }
});

exports.protect = catchAsync(async (req, res, next) => {
  // 1) Getting token and check if it is present
  let token;
  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith("Bearer")
  ) {
    token = req.headers.authorization.split(" ")[1];
  }
  console.log(token);
  if (!token) {
    return next(
      new AppError(
        "You are not signed in! Please sign in to gain access.",
        401,
      ),
    );
  }

  // 2) Verification token
  const decoded = await promisify(jwt.verify)(
    token,
    process.env.JWT_SECRET_KEY,
  );

  // 3) Check if user still exists
  const freshUser = await User.findById(decoded.id).select("-__v");
  if (!freshUser) {
    return next(
      new AppError(
        "Token verification failed! Please try and sign in again",
        401,
      ),
    );
  }

  req.user = freshUser;
  req.token = token;
  next();
});

exports.getAllUsers = catchAsync(async (req, res, next) => {
  const allUsers = await User.find();
  res.status(200).json({
    status: "success",
    results: allUsers.length,
    data: {
      users: allUsers,
    },
  });
});

exports.getCurrentUser = catchAsync(async (req, res, next) => {
  res.status(200).json({
    status: "success",
    token: req.token,
    data: {
      user: req.user,
    },
  });
});
