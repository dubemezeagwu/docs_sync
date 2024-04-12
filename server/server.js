const dotenv = require("dotenv");
const app = require("./app");
const mongoose = require("mongoose");

process.on("uncaughtException", (err) => {
  console.log(err.name, err.message);
  process.exit(1);
});

dotenv.config({ path: "./config.env" });

const database = process.env.DATABASE.replace(
  "<PASSWORD>",
  process.env.DATABASE_PASSWORD
);

mongoose.connect(database, {
}).then((con) => {
  console.log(con.connections);
  console.log("DB connection successful");
}).catch((err) => {
  console.log(err);
});

const port = process.env.PORT || 3001;
const server = app.listen(port, "0.0.0.0", () => {
  console.log(`App is running on port ${port}`);
});

process.on("unhandledRejection", (err) => {
  console.log(err.name, err.message);
  server.close(() => {
    process.exit(1);
  });
});