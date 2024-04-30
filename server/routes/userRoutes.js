const express = require("express");
const authController = require("./../controllers/authController");

const router = express.Router();

router.post("/users/signup", authController.signup);
router.get(
  "/users/allUsers",
  authController.protect,
  authController.getAllUsers,
);
router.get("/users/me", authController.protect, authController.getCurrentUser);

module.exports = router;
