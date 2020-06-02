const Generator = require("yeoman-generator");
const templatePath = require("../../libs/templatePath");

module.exports = class extends Generator {
  constructor(args, opts) {
    super(args, opts);
    this.log("Initializing...");
  }

  install() {
    this.log("Installing...");
    this.spawnCommand("elm", ["install", "elm/json"]);
    this.spawnCommand("elm", ["install", "elm/url"]);
    this.spawnCommand("elm", ["install", "elm-community/string-extra"]);
    this.spawnCommand("elm", ["install", "rtfeldman/elm-css"]);
  }

  start() {
    this.log("Start...");
  }

  writing() {
    this.log("Writing..");
    const self = this;
    self.fs.copyTpl(
      templatePath("storybook/"),
      self.destinationPath(`storybook/`)
    );
  }
};
