const Generator = require("yeoman-generator");
const templatePath = require("../../libs/templatePath");

module.exports = class extends Generator {
  constructor(args, opts) {
    super(args, opts);
    this.log("Initializing...");
  }

  install() {
    this.log("Installing...");
  }

  start() {
    this.log("Start...");
  }

  writing() {
    this.log("Writing..");
    const self = this;
    self.fs.copyTpl(
      templatePath("elm/"),
      self.destinationPath(`src/`)
    );
  }
};
