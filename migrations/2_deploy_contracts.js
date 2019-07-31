var CrowdFunding = artifacts.require("./CrowdFunding.sol");
var CrowdFundingFactory = artifacts.require("./CrowdFundingFactory.sol");

module.exports = function(deployer, accounts) {
  deployer.deploy(CrowdFundingFactory);
};