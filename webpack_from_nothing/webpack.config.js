const path = require("path")

module.exports = {
  entry: "./js/index.js",
  output: {
    path: path.resolve(__dirname, "dist"),
    filename: "bundle-[contenthash].js"
  },
  mode: "none",
  optimization: {
    minimize: true
  }
}
