const BitCrafty_Contract = artifacts.require("BitCrafty_Contract");

module.exports = function(deployer) {
    //await deployer.deploy(UNIQ_Application);
    deployer.deploy(BitCrafty_Contract);
};
