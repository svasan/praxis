const path = require("path");
const glob = require("glob");

var testFiles = glob.sync("**/*.test.js")
    .filter( function(el) {return el != "test/bundle.test.js";} )
    .map( function(el) {return "./" + el;} );

module.exports = {
  entry: testFiles,
  output: {
    path: path.resolve(__dirname, "."),
    filename: "bundle.test.js"
  },
  mode: "none"
};
