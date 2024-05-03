const Document = require("./../models/documentModel");
const catchAsync = require("./../utils/catchAsync");
const AppError = require("./../utils/appError");

exports.createDocument = catchAsync(async (req, res, next) => {
  const { createdAt } = req.body;

  const document = await Document.create({
    uid: req.user.id,
    title: "Untitled Document",
    createdAt: createdAt,
  });
  res.status(201).json({
    status: "success",
    data: {
      document: document,
    },
  });
});
