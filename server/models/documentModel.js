const mongoose = require("mongoose");

const documentSchema = new mongoose.Schema(
  {
    uid: {
      required: true,
      type: String,
    },
    public: {
      type: Boolean,
      default: false,
    },
    createdAt: {
      required: true,
      type: Number,
    },
    title: {
      required: true,
      type: String,
      trim: true,
    },
    content: {
      type: Array,
      default: [],
    },
    collaborators: [
      {
        _id: false,
        user: {
          type: mongoose.Schema.ObjectId,
          ref: "User",
          required: true,
        },
        role: {
          type: String,
          enum: ["viewer", "editor"],
          default: "viewer",
        },
      },
    ],
  },
  {
    versionKey: false,
  },
);

documentSchema.pre(/^find/, function (next) {
  this.populate({
    path: "collaborators.user",
    select: "name email profilePicture",
  });
  next();
});

documentSchema.pre("save", function (next) {
  if (!this.public && this.collaborators.length > 0) {
    this.collaborators = [];
  }
  next();
});

const Document = mongoose.model("Document", documentSchema);
module.exports = Document;
