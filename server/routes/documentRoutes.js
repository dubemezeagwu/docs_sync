const express = require("express");
const authController = require("./../controllers/authController");
const documentController = require("./../controllers/documentController");

const router = express.Router();

router.post(
  "/docs/create",
  authController.protect,
  documentController.createDocument,
);

router.get(
  "/docs/me",
  authController.protect,
  documentController.getUserDocuments,
);

module.exports = router;
