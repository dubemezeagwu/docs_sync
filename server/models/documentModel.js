const mongoose = require("mongoose");

const collaboratorSchema = new mongoose.Schema(
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
  { _id: false },
);

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
  collaborators: [collaboratorSchema],
});

// remove the __v field from the res
// documentSchema.set("toJSON", {
//   transform: function (doc, ret) {
//     ret.id = ret._id.toString();
//     delete ret._id;
//     delete ret.__v;
//     return ret;
//   },
// });

documentSchema.pre("save", function (next) {
  if (!this.public && this.collaborators.length > 0) {
    this.collaborators = [];
  }
  next();
});

const Document = mongoose.model("Document", documentSchema);
module.exports = Document;
