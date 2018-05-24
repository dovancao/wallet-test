var ERC233ReceivingContract = artifacts.require("./ERC233ReceivingContract.sol");

module.exports = function(deployer) {
  deployer.deploy(ERC233ReceivingContract);
};
