const path = require("path");

module.exports = {
  entry: "./test/canary.test.js",
  output: {
    path: path.resolve(__dirname, "."),
    filename: "bundle.test.js"
  },
  mode: "none"
};
