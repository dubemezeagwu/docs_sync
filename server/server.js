const dotenv = require("dotenv");
const app = require("./app");
const http = require("http");
const mongoose = require("mongoose");

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
  .connect(database, {})
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
});

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
