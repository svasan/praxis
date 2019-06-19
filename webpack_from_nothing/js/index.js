import mdPreviewer from "./markdownPreviewer";

window.onload = function() {
  document.getElementById("editor").addEventListener(
    "submit",
    mdPreviewer.preview(document, "source", "preview")
  )
};
