const HtmlPlugin = require("html-webpack-plugin");

module.exports = {
  plugins: [
    new HtmlPlugin({
      template: "./html/index.html"
    })
  ],
  entry: "./js/index.js",
  mode: "none"
};
