var Splitter = artifacts.require("./Splitter.sol");

module.exports = function(deployer) {
  deployer.deploy(Splitter,"0x9d2cb381449d30e819bcc339c786c67b1d14239d","0xa12a2b8b48852708d7d2d7a1bb3ea30957c0a5e9");
};
