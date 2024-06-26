const express = require("express");
const morgan = require("morgan");
const cors = require("cors");

const AppError = require("./utils/appError");
const globalErrorHandler = require("./controllers/errorController");
const userRouter = require("./routes/userRoutes");
const documentRouter = require("./routes/documentRoutes");

const app = express();

app.use(cors({ origin: "*" }));
app.use(morgan("dev"));
app.use(express.json());

app.use((req, res, next) => {
  console.log("Hello from the middleware!");
  next();
});

app.use("/api/v1", userRouter);
app.use("/api/v1", documentRouter);

app.all("*", (req, res, next) => {
  next(new AppError(`Can't find ${req.originalUrl} on this server!`, 404));
});

app.use(globalErrorHandler);

module.exports = app;
