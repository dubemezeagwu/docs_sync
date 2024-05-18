const mongoose = require("mongoose");

const documentSchema = new mongoose.Schema({
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
      uid: {
        type: String,
        required: true,
      },
      role: {
        type: String,
        enum: ["viewer", "editor"],
        default: "viewer",
      },
    },
  ],
});

documentSchema.pre("save", function (next) {
  if (!this.public && this.collaborators.length > 0) {
    this.collaborators = [];
  }
  next();
});

const Document = mongoose.model("Document", documentSchema);
module.exports = Document;
