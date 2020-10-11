const  Migrations= artifacts.require("Migrations");
const  Greeter= artifacts.require("Greeter");
const  SupplyDrugs= artifacts.require("SupplyDrugs.sol");
const  SupplyChainProduct= artifacts.require("SupplyChainProduct.sol");
const  Strings= artifacts.require("Strings.sol");
const  Ownable= artifacts.require("Ownable.sol");

module.exports = function (deployer) {
  deployer.deploy(Greeter);
  deployer.deploy(Migrations);
  deployer.deploy(SupplyDrugs);
  deployer.deploy(SupplyChainProduct);
  deployer.deploy(Strings);
  deployer.deploy(Ownable);
};
