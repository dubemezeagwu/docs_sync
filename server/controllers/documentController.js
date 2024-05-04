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

exports.getUserDocuments = catchAsync(async (req, res, next) => {
  const documents = await Document.find({ uid: req.user.id }).select("-__v");
  if (documents.length == 0) {
    return next(new AppError("No documents found matching that ID", 404));
  }
  res.status(200).json({
    status: "success",
    results: documents.length,
    data: {
      document: documents,
    },
  });
});
