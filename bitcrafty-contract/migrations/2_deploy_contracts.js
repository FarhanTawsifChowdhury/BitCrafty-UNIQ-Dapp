const UNIQ = artifacts.require("UNIQ");
const BitCrafty_Contract = artifacts.require("BitCrafty_Contract");

module.exports = function(deployer) {
    //deployer.deploy(UNIQ);
    deployer.deploy(BitCrafty_Contract);
};
