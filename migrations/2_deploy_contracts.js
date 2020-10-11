const Greeter = artifacts.require("Greeter");
const  SupplyDrugs= artifacts.require("SupplyDrugs.sol");
const  Strings= artifacts.require("Strings.sol");
const  Ownable= artifacts.require("Ownable.sol");

module.exports = function (deployer) {
  deployer.deploy(Greeter);
  deployer.deploy(SupplyDrugs);
  deployer.deploy(Strings);
  deployer.deploy(Ownable);
};
