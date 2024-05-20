const Document = require("./../models/documentModel");
const catchAsync = require("./../utils/catchAsync");
const AppError = require("./../utils/appError");

exports.createDocument = catchAsync(async (req, res, next) => {
  const { createdAt, isPublic } = req.body;
  const userId = req.user.id;

  const publicDocCount = await Document.countDocuments({
    uid: userId,
    public: true,
  });
  const privateDocCount = await Document.countDocuments({
    uid: userId,
    public: false,
  });

  let titleBase = "Untitled Document";
  if (isPublic) {
    titleBase = `Public Document #${publicDocCount + 1}`;
  } else {
    titleBase = `Private Document #${privateDocCount + 1}`;
  }

  const document = await Document.create({
    uid: req.user.id,
    title: titleBase,
    createdAt: createdAt,
    public: isPublic || false,
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
    return next(new AppError("No document found matching that ID", 404));
  }
  res.status(200).json({
    status: "success",
    results: documents.length,
    data: {
      document: documents,
    },
  });
});

exports.updateDocumentTitle = catchAsync(async (req, res, next) => {
  const { id, title } = req.body;

  const document = await Document.findByIdAndUpdate(
    id,
    { title },
    {
      new: true,
      runValidators: true,
    },
  ).select("-__v");
  res.status(200).json({
    status: "success",
    data: {
      document: document,
    },
  });
});

exports.addCollaborators = catchAsync(async (req, res, next) => {
  const { id, collaborators } = req.body;

  const document = await Document.findById(id);

  if (!document) {
    return next(new AppError("No document found with that ID", 404));
  }

  document.collaborators = collaborators.map((collaborator) => ({
    uid: collaborator.uid,
    role: collaborator.role || "viewer",
  }));

  await document.save();

  res.status(200).json({
    status: "success",
    data: {
      document: document,
    },
  });
});

exports.getDocumentById = catchAsync(async (req, res, next) => {
  let { id } = req.params;
  if (id.startsWith(":")) {
    id = id.slice(1);
  }
  const document = await Document.findById(id).select("-__v");
  if (document.length == 0) {
    return next(new AppError("No document exists/matches that id", 404));
  }
  res.status(200).json({
    status: "success",
    data: {
      document: document,
    },
  });
});

exports.deleteDocument = catchAsync(async (req, res, next) => {
  let { id } = req.params;
  if (id.startsWith(":")) {
    id = id.slice(1);
  }
  const document = await Document.findByIdAndDelete(id);

  if (!document) {
    return next(new AppError("No tour found with that ID", 404));
  }
  res.status(204).json({
    status: "success",
    data: {
      document: null,
    },
  });
});
