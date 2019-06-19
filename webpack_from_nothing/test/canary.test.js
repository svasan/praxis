import previewer from "../js/markdownPreviewer"

describe("canary", function() {
  test("can run a test", function () {
    expect(true).toBe(true);
  });

  test("can load markdownPreviewer", function () {
    expect(previewer).toBeDefined();
  });

});
