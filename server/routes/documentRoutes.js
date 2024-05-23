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

router.patch(
  "/docs/updateTitle",
  authController.protect,
  documentController.updateDocumentTitle,
);

router.get(
  "/docs/:id",
  authController.protect,
  documentController.getDocumentById,
);

router.delete(
  "/docs/delete/:id",
  authController.protect,
  documentController.deleteDocument,
);

router.patch(
  "/docs/addCollaborators",
  authController.protect,
  documentController.addCollaborators,
);

router.patch(
  "/docs/removeCollaborators",
  authController.protect,
  documentController.removeCollaborators,
);

module.exports = router;
