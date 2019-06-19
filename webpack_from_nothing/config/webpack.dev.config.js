const path = require("path");
const Merge = require("webpack-merge");
const CommonConfig = require("./webpack.common.config.js");

module.exports = Merge(CommonConfig, {
  output: {
    path: path.resolve(__dirname, "../dev"),
    filename: "bundle.js"
  },
});
