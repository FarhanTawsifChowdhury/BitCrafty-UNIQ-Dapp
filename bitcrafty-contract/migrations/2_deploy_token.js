const UNIQ = artifacts.require("UNIQ");

module.exports = function(deployer) {
    deployer.deploy(UNIQ,500000);
};
