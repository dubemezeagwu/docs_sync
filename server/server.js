const dotenv = require("dotenv");
const app = require("./app");
const http = require("http");
const mongoose = require("mongoose");
const Document = require("./models/documentModel");

process.on("uncaughtException", (err) => {
  console.log(err.name, err.message);
  process.exit(1);
});

dotenv.config({ path: "./config.env" });

const database = process.env.DATABASE.replace(
  "<PASSWORD>",
  process.env.DATABASE_PASSWORD,
);

var socketServer = http.createServer(app);
var io = require("socket.io")(socketServer);

mongoose
  .connect(database, { useNewUrlParser: true, useUnifiedTopology: true })
  .then((con) => {
    console.log(con.connections);
    console.log("DB connection successful");
  })
  .catch((err) => {
    console.log(err);
  });

io.on("connection", (socket) => {
  socket.on("join", (documentId) => {
    socket.join(documentId);
    console.log("joined!");
  });

  socket.on("typing", (data) => {
    socket.broadcast.emit("changes", data);
  });

  socket.on("save", (data) => {
    saveData(data);
  });
});

const saveData = async (data) => {
  await Document.findByIdAndUpdate(
    data.room,
    { content: data.delta },
    { new: true },
  );
};

const port = process.env.PORT || 3001;
const server = socketServer.listen(port, "0.0.0.0", () => {
  console.log(`App is running on port ${port}`);
});

process.on("unhandledRejection", (err) => {
  console.log(err.name, err.message);
  server.close(() => {
    process.exit(1);
  });
});
